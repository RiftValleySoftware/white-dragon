/***************************************************************************************************************************/
/**
    © Copyright 2018, Little Green Viper Software Development LLC.
    
    MIT License
    
    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
    files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
    modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
    OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
    CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    
    Little Green Viper Software Development: https://littlegreenviper.com
*/

import Foundation

/* ###################################################################################################################################### */
// MARK: - Main Class -
/* ###################################################################################################################################### */
/**
 */
public class A_RVP_Cocoa_SDK_Object: NSObject, Sequence {
    /* ################################################################## */
    // MARK: - Internal Properties
    /* ################################################################## */
    /**
     This is the SDK object that "owns" this instance.
     */
    internal weak var _sdkInstance: RVP_Cocoa_SDK?
    
    /* ################################################################## */
    /**
     This records changes made during the current instantiation (not before) of this object. It has an Array of structs with a "before" instance, and an "after" instance.
     
     Changes are only kept for the lifetime of this instance.
     */
    internal var _changeHistory: [RVP_Change_Record] = []
    
    /* ################################################################## */
    /**
     This contains the actual JSON data that was read from the server for this record.
     */
    internal var _myData: [String: Any] = [:]
    
    /* ################################################################## */
    /**
     This is used to detect "dirty" conditions. This is a Dictionary full of SHA values of the original data.
     */
    internal var _myOriginalData: [String: Any] = [:]

    /* ################################################################## */
    // MARK: - Internal Calculated Properties
    /* ################################################################## */
    /**
     - returns: The URI with any changed fields. Empty String, if no changes. READ ONLY
     */
    internal var _saveChangesURI: String {
        var uri = ""
        
        for item in self._myData {
            // Everything can be cast to an NSObject, and we can compare them.
            if "payload" != item.key, "payload_type" != item.key, let original = self._myOriginalData[item.key] as? NSObject {  // Payload is handled differently
                if let current = item.value as? NSObject {
                    // All values should be convertible to String.
                    if current != original, let uriKey = item.key.urlEncodedString, let valueString = (current as? String)?.urlEncodedString {
                        if !uri.isEmpty {
                            uri += "&"
                        }
                        
                        uri += "\(uriKey)=\(valueString)"
                    }
                } else {    // This should never happen.
                    #if DEBUG
                    print("There Is An Error in the Data! This should not have been encountered! The Data Object is not NSObject-Castable!")
                    #endif
                    break
                }
            }
        }
        
        // We go through the original data as well, in case we deleted something.
        for item in self._myOriginalData where "payload" != item.key && "payload_type" != item.key && nil == self._myData[item.key] {
            if !uri.isEmpty {
                uri += "&"
            }
            
            uri += "\(item.key)="
        }
        
        return uri
    }
    
    /* ################################################################## */
    /**
     - returns: a string, with the plugin type ("baseline", "people", "places" "things", "login". READ ONLY
     */
    internal var _pluginType: String {
        return "baseline"
    }
    
    /* ################################################################## */
    /**
     - returns: a string, with the "plugin path" for the data item. READ ONLY
     */
    internal var _pluginPath: String {
        return "/baseline/" + String(self.id)
    }

    /* ################################################################## */
    // MARK: - Internal Instance Methods
    /* ################################################################## */
    /**
     This handles making change records from the response from a PUT command.
     
     - parameter inChangeData: The response, as Data. It is JSON, and will be parsed as such.
     */
    internal func _handleChangeResponse(_ inChangeData: Data) {
        do {    // Extract a usable object from the given JSON data.
            let temp = try JSONSerialization.jsonObject(with: inChangeData, options: [])
            
            // We will have different Dictionaries, dependent on which response we got, but we can parse them generically.
            if let dict = temp as? [String: Any] {
                self._parseChangeJSON(dict) // Build our change history.
                self._myOriginalData = self._myData // OK. The old is now the new. We no longer need to feel "dirty."
            } else {
                self._sdkInstance?._handleError(RVP_Cocoa_SDK.SDK_Data_Errors.invalidData(inChangeData))
            }
        } catch {   // We end up here if the response is not a proper JSON object.
            self._sdkInstance?._handleError(RVP_Cocoa_SDK.SDK_Data_Errors.invalidData(inChangeData))
        }
    }
    
    /* ################################################################## */
    /**
     This handles making change records from the response from a PUT command.
     
     - parameter inChangeJSON: The response, as an unserialized JSON object (Dictionary).
     */
    internal func _parseChangeJSON(_ inChangeJSON: [String: Any]) {
        // What we do, is recursively dive into the response, ignoring keys until we hit an Array with Dictionaries containing "before" and "after" keys.
        // We then parse those into instances, which populate the change history for this instance.
        for innerTuple in inChangeJSON {
            if let bfArray = innerTuple.value as? [[String: [String: Any]]] {
                var temp: RVP_Change_Record?
                for innerInner in bfArray {
                    if let beforeObject = innerInner["before"] {
                        if nil == temp {
                            temp = RVP_Change_Record(date: Date(), before: nil, after: nil)
                        }
                        // We specify these to be "forced" instances. We don't want the cached one.
                        temp?.before = self._sdkInstance?._makeNewInstanceFromDictionary(beforeObject, parent: self._pluginType, forceNew: true)
                    }
                    
                    if let afterObject = innerInner["after"] {
                        temp?.after = self._sdkInstance?._makeNewInstanceFromDictionary(afterObject, parent: self._pluginType, forceNew: true)
                    }
                    
                    if nil != temp?.before, nil != temp?.after {
                        self._changeHistory.append(temp!)
                    } else {
                        self._parseChangeJSON(innerInner)
                    }
                }
            } else {
                if let value = innerTuple.value as? [String: Any] {
                    self._parseChangeJSON(value)
                }
            }
        }
    }
    
    /* ################################################################## */
    // MARK: - Public Data Structures
    /* ################################################################## */
    /**
     This is a change record struct.
     */
    public struct RVP_Change_Record {
        /** A Date object, with the time/date of the change. */
        var date: Date
        /** A copy of the object, before the change. */
        var before: A_RVP_Cocoa_SDK_Object?
        /** A copy of the object, after the change. */
        var after: A_RVP_Cocoa_SDK_Object?
    }
    
    /* ################################################################## */
    // MARK: - Public Properties and Calculated Properties
    /* ################################################################## */
    /**
     - returns: all of the values for this object, as a Dictionary. READ ONLY
     */
    public var asDictionary: [String: Any?] {
        var ret: [String: Any?] = ["id": self.id, "name": self.name, "isWriteable": self.isWriteable, "isDirty": self.isDirty]

        if let readToken = self.readToken {
            ret["readToken"] = readToken
        }
        
        if let writeToken = self.writeToken {
            ret["writeToken"] = writeToken
        }
        
        if let lastAccess = self.lastAccess {
            ret["lastAccess"] = lastAccess
        }
        
        if !self.lang.isEmpty {
            ret["lang"] = self.lang
        }

        return ret
    }

    /* ################################################################## */
    /**
     - returns: the object ID, as an Int. READ ONLY
     */
    public var id: Int {
        var ret = 0
        
        if let id = self._myData["id"] as? Int {
            ret = id
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     - returns: true, if the data in the object has been changed since it was first created. READ ONLY
     */
    public var isDirty: Bool {
        var ret: Bool = self.isNew    // New is automatically dirty.
        
        for item in self._myData where !ret {
            // Everything can be cast to an NSObject, and we can compare them.
            if let original = self._myOriginalData[item.key] as? NSObject {
                if let current = item.value as? NSObject {
                    if current != original {
                        ret = true
                    }
                } else {    // This should never happen.
                    #if DEBUG
                    print("There Is An Error in the Data! This should not have been encountered! The Data Object is not NSObject-Castable!")
                    #endif
                    if let originalString = original as? String { // Just make sure that we don't have an empty placeholder.
                        ret = !originalString.isEmpty
                    } else {
                        ret = true
                    }
                }
            } else {    // If the item was added, and is not empty, then we are definitely dirty.
                ret = true
            }
        }
        
        // We go through the original data as well, in case we deleted something.
        for item in self._myOriginalData where !ret && (nil == self._myData[item.key]) {
            ret = true
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     - returns: true, if the object is a new object that did not come from the server. READ ONLY
     */
    public var isNew: Bool {
        return 0 == self.id // If the ID is zero, then we are new.
    }

    /* ################################################################## */
    /**
     - returns: true, if the current login can edit this record. READ ONLY
     */
    public var isWriteable: Bool {
        var ret = false
        
        if let writeable = self._myData["writeable"] as? Bool {
            ret = writeable
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     - returns: the last time the object was accessed. Nil, if no date available. READ ONLY
     */
    public var lastAccess: Date? {
        if let dateString = self._myData["last_access"] as? String {
            let dateFormatter = ISO8601DateFormatter()
            let options: ISO8601DateFormatter.Options = [.withYear, .withMonth, .withDay, .withDashSeparatorInDate, .withSpaceBetweenDateAndTime, .withTime, .withColonSeparatorInTime]
            dateFormatter.formatOptions = options
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
        }
        
        return nil
    }

    /* ################################################################## */
    /**
     - returns: the object name, as a String
     */
    public var name: String {
        get {
            var ret = ""
            
            if let name = self._myData["name"] as? String {
                ret = name
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                self._myData["name"] = newValue
            }
        }
    }
    
    /* ################################################################## */
    /**
     **NOTE:** Although this will let anyone with write permission set the token, it will not be accepted on the server, unless the admin also has the token.
     
     - returns: the read token, as an Int. Be aware that the read token may not be available, in which case, it will be nil.
     */
    public var readToken: Int? {
        get {
            var ret: Int?
            
            if let id = self._myData["read_token"] as? Int {
                ret = id
            }
        
            return ret
        }
        
        set {
            if self.isWriteable {
                self._myData["read_token"] = newValue
            }
        }
    }
    
    /* ################################################################## */
    /**
     **NOTE:** Although this will let anyone with write permission set the token, it will not be accepted on the server, unless the admin also has the token.
     
     - returns: the write token, as an Int. Be aware that the write token may not be available, in which case, it will be nil.
     */
    public var writeToken: Int? {
        get {
            var ret: Int?
            
            if let id = self._myData["write_token"] as? Int {
                ret = id
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                self._myData["write_token"] = newValue
            }
        }
    }
    
    /* ################################################################## */
    /**
     - returns: the language
     */
    public var lang: String {
        get {
            var ret: String = ""
            
            if let lang = self._myData["lang"] as? String {
                ret = lang
            }
            
            return ret
        }
        
        set {
            self._myData["lang"] = newValue
        }
    }
    
    /* ################################################################## */
    /**
     - returns: the SDK instance that "owns" this instance. READ ONLY
     */
    public var sdkInstance: RVP_Cocoa_SDK? {
        return self._sdkInstance
    }

    /* ################################################################## */
    // MARK: - Internal Instance Methods
    /* ################################################################## */
    /**
     - returns: Any URI components to the save. The base class returns nothing.
     */
    internal func _getChangeURIComponents() -> String {
        return ""
    }

    /* ################################################################## */
    // MARK: - Public Instance Methods
    /* ################################################################## */
    /**
     This is the default initializer.
     
     - parameter sdkInstance: REQUIRED (Can be nil) This is the SDK instance that "owns" this object. It may be nil for history instances.
     - parameter objectInfoData: REQUIRED This is the parsed JSON data for this object, as a Dictionary.
     */
    public init(sdkInstance inSDKInstance: RVP_Cocoa_SDK?, objectInfoData inData: [String: Any]) {
        self._sdkInstance = inSDKInstance
        self._myData = inData
        self._myOriginalData = inData
    }
    
    /* ################################################################## */
    /**
     This accesses the raw original data. READ ONLY
     */
    public var myOriginalData: [String: Any] {
        return self._myOriginalData
    }
    
    /* ################################################################## */
    /**
     This accesses the raw current data.
     */
    public var myData: [String: Any] {
        get {
            return self._myData
        }
        
        set {
            self._myData = newValue
        }
    }
    
    /* ################################################################## */
    /**
     This reverts the data to the state before any changes were made.
     */
    public func revert() {
        self._myData = self._myOriginalData
    }
    
    /* ################################################################## */
    /**
     This handles sending our data (if necessary) to the server.
     */
    public func sendToServer() {
        self._sdkInstance?._putObject(self)
    }
    
    /* ################################################################## */
    // MARK: - Public Sequence Protocol Methods, Typedefs and Structs
    /* ################################################################## */
    /**
     This is the element type for the Sequence protocol.
     */
    public typealias Element = Any?
    
    /* ################################################################## */
    /**
     We have a subscript to return values, as if we were directly accessing the data. READ ONLY.
     This returns the "asDictionary" response, as opposed to direct "myData" access (use "myData" for that).
     */
    public subscript(_ inKey: String) -> Element? {
        return self.asDictionary[inKey]
    }
    
    /* ################################################################## */
    /**
     This is the Sequence Iterator Struct. This iterates the "asDictionary" response. READ ONLY.
     */
    public struct Iterator: IteratorProtocol {
        /** This is the captured list that we're iterating. */
        private let _owner: A_RVP_Cocoa_SDK_Object
        /** This is the current item in that list. */
        private var _index: Int
        
        /* ############################################################## */
        /**
         The default initializer.
         
         - parameter inOwner: This is the object to be iterated. The asDictionary output will be iterated. READ ONLY.
         */
        init(_ inOwner: A_RVP_Cocoa_SDK_Object) {
            self._owner = inOwner
            self._index = 0
        }
        
        /* ############################################################## */
        /**
         Simple "next" iterator method. Order is not guaranteed. This iterates the "live" object directly; not a copy.
         */
        mutating public func next() -> Element? {
            let iteratorListKeyArray = Array(self._owner.asDictionary.keys)
            if self._index < iteratorListKeyArray.count {
                let iteratorListKey = iteratorListKeyArray[self._index]
                self._index += 1
                return self._owner.asDictionary[iteratorListKey]
            } else {
                return nil
            }
        }
    }
    /* ################################################################## */
    /**
     - returns: a new iterator for the instance, which iterates the asDictionary response.It is read-only.
     */
    public func makeIterator() -> A_RVP_Cocoa_SDK_Object.Iterator {
        return Iterator(self)
    }
}
