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
 This is the fundamental base class for the various data item classes. It aggregates a bunch of generic functionality that can be applied across the board.
 */
public class A_RVP_Cocoa_SDK_Object: NSObject, Sequence {
    /* ################################################################## */
    // MARK: - Private Methods
    /* ################################################################## */
    /**
     This parses a new login object, and may also begin a user creation (depending on whether or not we are creating a pair).
     
     - parameter valueDictionary: This is a Dictionary of values to be applied to the new login.
     */
    private func _handleNewLogin(valueDictionary inValue: [String: Any]) {
        if let ret = self._sdkInstance?._makeNewInstanceFromDictionary(inValue, parent: self._pluginType) {
            self._sdkInstance?._callDelegateNewItem(ret)
            if self._sdkInstance?._creatingUserLoginPair ?? false {  // If this was a standalone, we send to the delegate. Otherwise, we create a new user, and wait.
                if let newLogin = ret as? RVP_Cocoa_SDK_Login { // Make sure we have an actual login. If so, we create a new user.
                    self._sdkInstance?._newLoginInstance = ret
                    self._sdkInstance?._newUserInstance = RVP_Cocoa_SDK_User(sdkInstance: self._sdkInstance, objectInfoData: ["associated_login_id": newLogin.id, "name": newLogin.name])
                    self._sdkInstance?._newUserInstance.sendToServer()
                } else {
                    self._sdkInstance?._handleError(RVP_Cocoa_SDK.SDK_Data_Errors.invalidData(Data()))
                }
            } else {
                self._sdkInstance?._newLoginInstance = nil
                self._sdkInstance?._newUserInstance = nil
                self._sdkInstance?._creatingUserLoginPair = false
                self._sdkInstance?._sendItemsToDelegate([ret])
            }
        }
    }
    
    /* ################################################################## */
    /**
     This parses a new user object. It may work in conjunction with a previously created login.
     
     - parameter valueDictionary: This is a Dictionary of values to be applied to the new login.
     */
    private func _handleNewUser(valueDictionary inValue: [String: Any]) {
        if let ret = self._sdkInstance?._makeNewInstanceFromDictionary(inValue, parent: self._pluginType) {
            self._sdkInstance?._callDelegateNewItem(ret)
            if let newLogin = self._sdkInstance?._newLoginInstance {
                self._sdkInstance?._sendItemsToDelegate([newLogin, ret])
            } else {
                self._sdkInstance?._sendItemsToDelegate([ret])
            }
            self._sdkInstance?._newLoginInstance = nil  // These get nilled out, no matter what.
            self._sdkInstance?._newUserInstance = nil
            self._sdkInstance?._creatingUserLoginPair = false
        }
    }
    
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
     This is used to detect "dirty" conditions. This is a Dictionary copy of the original data.
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
        
        var dataList = self._myData
        var oldDataList = self._myOriginalData
        
        // We have a special place in our heart for passwords.
        if self is RVP_Cocoa_SDK_Login && nil == dataList["password"] {
            dataList["password"] = ""
        }
        
        if self is RVP_Cocoa_SDK_Login && nil == oldDataList["password"] {
            oldDataList["password"] = ""
        }
        
        if nil != dataList["associated_login_id"] || nil != oldDataList["associated_login_id"] {
            if self._sdkInstance?.isMainAdmin ?? false {    // Only the main admin can change associated logins
                dataList["login_id"] =  dataList["associated_login_id"]  // We morhp into the version the server understands.
                oldDataList["login_id"] =  dataList["associated_login_id"]
            }
            
            dataList.removeValue(forKey: "associated_login_id") // In either case, we remove the original.
            oldDataList.removeValue(forKey: "associated_login_id")
        }

        // We go through, ignoring some of the temporary and calculated fields, and the payload.
        for item in dataList where
            "is_manager" != item.key
            && "is_main_admin" != item.key
            && "fuzzy" != item.key
            && "createLogin" != item.key
            && "distance" != item.key
            && "writeable" != item.key
            && "id" != item.key
            && "payload" != item.key
            && "payload_type" != item.key {
            if self.isNew {
                if let current = item.value as? NSObject {
                    // All values should be convertible to String.
                    if let uriKey = item.key.urlEncodedString {
                        if !uri.isEmpty {
                            uri += "&"
                        }
                        
                        // Conversion to string options for various data types.
                        if let valueString = (current as? String)?.urlEncodedString {
                            uri += "\(uriKey)=\(valueString)"
                        } else if let valueInt = current as? Int {  // Swift can get a bit particular about the various types of numbers, so just to be safe, I check each one.
                            uri += "\(uriKey)=\(String(valueInt))"
                        } else if let valueFloat = current as? Float {
                            uri += "\(uriKey)=\(String(valueFloat))"
                        } else if let valueDouble = current as? Double {
                            uri += "\(uriKey)=\(String(valueDouble))"
                        } else if let valueBool = current as? Bool {    // Bool is expressed as a 1 or a 0
                            uri += "\(uriKey)=\(valueBool ? "1" : "0")"
                        }
                    }
                } else {    // This should never happen.
                    #if DEBUG
                    print("There Is An Error in the Data! This should not have been encountered! The Data Object is not NSObject-Castable!")
                    #endif
                    break
                }
            } else if let original = oldDataList[item.key] as? NSObject {  // Payload is handled differently
                if let current = item.value as? NSObject {
                    // All values should be convertible to String.
                    if current != original, var uriKey = item.key.urlEncodedString {
                        if !uri.isEmpty {
                            uri += "&"
                        }
                        
                        // There's a special case for this.
                        if "associated_login_id" == uriKey, self._sdkInstance?.isMainAdmin ?? false {
                            uriKey = "login_id"
                        }
                        
                        // Conversion to string options for various data types.
                        if let valueString = (current as? String)?.urlEncodedString {
                            uri += "\(uriKey)=\(valueString)"
                        } else if let valueInt = current as? Int {  // Swift can get a bit particular about the various types of numbers, so just to be safe, I check each one.
                            uri += "\(uriKey)=\(String(valueInt))"
                        } else if let valueFloat = current as? Float {
                            uri += "\(uriKey)=\(String(valueFloat))"
                        } else if let valueDouble = current as? Double {
                            uri += "\(uriKey)=\(String(valueDouble))"
                        } else if let valueBool = current as? Bool {    // Bool is expressed as a 1 or a 0
                            uri += "\(uriKey)=\(valueBool ? "1" : "0")"
                        }
                    }
                } else {    // This should never happen.
                    #if DEBUG
                    print("There Is An Error in the Data! This should not have been encountered! The Data Object is not NSObject-Castable!")
                    #endif
                    break
                }
            }
        }
        
        // There's a special circumstance, where we can create a login ID to go with the user.
        if self.isNew, self is RVP_Cocoa_SDK_User, self.sdkInstance?.isManager ?? false, let create = self._myData["create_login"] as? Bool, create {
            if !uri.isEmpty {
                uri += "&"
            }
            
            uri += "login_user"
        }
        
        // We go through the original data as well, in case we deleted something.
        for item in oldDataList where
            "is_manager" != item.key
            && "is_main_admin" != item.key
            && "fuzzy" != item.key
            && "createLogin" != item.key
            && "distance" != item.key
            && "writeable" != item.key
            && "id" != item.key
            && "payload" != item.key
            && "payload_type" != item.key
            && nil == dataList[item.key] {
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
        return self._pluginPathNoID + "/" + (0 != self.id ? String(self.id) : "")
    }
    
    /* ################################################################## */
    /**
     - returns: a string, with the "plugin path" for the data item, with no ID attached. READ ONLY
     */
    internal var _pluginPathNoID: String {
        return "/baseline"
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
     - returns: Any URI components to the save. The base class returns nothing.
     */
    internal func _getChangeURIComponents() -> String {
        return ""
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
            if let innerCast = innerTuple.value as? [String: Any] {
                if let newValue = innerCast["new_login"] as? [String: Any] {
                    self._handleNewLogin(valueDictionary: newValue)
                } else if let newValue = innerCast["new_user"] as? [String: Any] {
                    self._handleNewUser(valueDictionary: newValue)
                } else if let newValue = innerCast["new_place"] as? [String: Any] {
                    if let ret = self._sdkInstance?._makeNewInstanceFromDictionary(newValue, parent: self._pluginType) {
                        self._sdkInstance?._callDelegateNewItem(ret)
                        self._sdkInstance?._sendItemsToDelegate([ret])
                        break
                    }
                } else if let newValue = innerCast["new_thing"] as? [String: Any] {
                    if let ret = self._sdkInstance?._makeNewInstanceFromDictionary(newValue, parent: self._pluginType) {
                        self._sdkInstance?._callDelegateNewItem(ret)
                        self._sdkInstance?._sendItemsToDelegate([ret])
                        break
                    }
                } else if let bfArray = innerTuple.value as? [[String: [String: Any]]] {
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
                            break
                        } else {
                            self._parseChangeJSON(innerInner)
                        }
                    }
                } else {
                    self._parseChangeJSON(innerCast)
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
     This returns keys that are the same as calculated public properties, so you can use it
     to get the methods/calculated properties you need to make changes.
     
     - returns: all of the values for this object, as a Dictionary. READ ONLY
     */
    public var asDictionary: [String: Any?] {
        var ret: [String: Any?] = ["id": self.id,
                                   "name": self.name,
                                   "lang": self.lang,
                                   "isWriteable": self.isWriteable,
                                   "isDirty": self.isDirty,
                                   "isNew": self.isNew,
                                   "readToken": self.readToken,
                                   "writeToken": self.writeToken]
        
        if let lastAccess = self.lastAccess {
            ret["lastAccess"] = lastAccess
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
     **NOTE:** Although this will let anyone with write permission set the token, it will not be accepted on the server, unless the admin also has the token.
     
     - returns: the read token, as an Int.
     */
    public var readToken: Int {
        get {
            var ret: Int = 0
            
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
     
     - returns: the write token, as an Int.
     */
    public var writeToken: Int {
        get {
            var ret: Int = 1
            
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
     - returns: the SDK instance that "owns" this instance. READ ONLY
     */
    public var sdkInstance: RVP_Cocoa_SDK? {
        return self._sdkInstance
    }

    /* ################################################################## */
    // MARK: - Public Instance Methods
    /* ################################################################## */
    /**
     This is the default initializer.
     
     - parameter sdkInstance: REQUIRED (Can be nil) This is the SDK instance that "owns" this object. It may be nil for history instances.
     - parameter objectInfoData: REQUIRED This is the parsed JSON data for this object, as a Dictionary. If it is empty, then this is considered a brand new object, and its ID will be zero, read and write will be set to 1, and it will be marked writeable. Additionally, nothing will be saved to the original data cache.
     */
    public init(sdkInstance inSDKInstance: RVP_Cocoa_SDK?, objectInfoData inData: [String: Any]) {
        super.init()
        self._sdkInstance = inSDKInstance
        var inMutableData = inData
        if inMutableData.isEmpty {
            inMutableData["id"] = 0
            inMutableData["read_token"] = 1
            inMutableData["write_token"] = 1
            inMutableData["writeable"] = true
            if self is RVP_Cocoa_SDK_Login {    // We generate a random string for the login ID.
                inMutableData["login_id"] = NSUUID().uuidString
            }
            self._myData = inMutableData   // This will change as we edit the object.
        } else {
            self._myData = inData   // This will change as we edit the object.
            self._myOriginalData = inData   // This is a "snapshot of the "before" state of the object.
        }
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
