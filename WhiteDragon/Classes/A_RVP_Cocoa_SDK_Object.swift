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
public class A_RVP_Cocoa_SDK_Object: NSObject {
    /* ################################################################## */
    // MARK: - Internal Variables -
    /* ################################################################## */
    /** This is the SDK object that "owns" this instance. It may be nil for change history entries. */
    internal weak var _sdkInstance: RVP_Cocoa_SDK?
    
    /** This records changes made during the current instantiation (not before) of this object. It has a tuple with a "before" instance, and an "after" instance. */
    internal var _changeHistory: [(before: A_RVP_Cocoa_SDK_Object?, after: A_RVP_Cocoa_SDK_Object?)] = []
    
    /** This contains the actual JSON data that was read from the server for this record. */
    internal var _myData: [String: Any] = [:]
    
    /** This is used to detect "dirty" conditions. This is a Dictionary full of SHA values of the original data. */
    internal var _myOriginalData: [String: Any] = [:]

    /* ################################################################## */
    // MARK: - Public Methods and Calulated properties -
    /* ################################################################## */
    /**
     - returns all of the values for this object, as a Dictionary.
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
     - returns true, if the data in the object has been changed since it was first created. READ ONLY
     */
    public var isDirty: Bool {
        var ret: Bool = false
        
        for item in self._myData {
            // Everything can be cast to an NSObject, and we can compare them.
            if let original = self._myOriginalData[item.key] as? NSObject {
                if let current = item.value as? NSObject {
                    if current != original {
                        ret = true
                        break
                    }
                } else {    // This should never happen.
                    #if DEBUG
                    print("There Is An Error in the Data! This should not have been encountered! The Data Object is not NSObject-Castable!")
                    #endif
                    ret = true
                    break
                }
            } else {    // If the item is missing, then we are definitely dirty.
                ret = true
                break
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
     - returns the object ID, as an Int. READ ONLY
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
     - returns true, if the current login can edit this record. READ ONLY
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
     - returns the last time the object was accessed. Nil, if no date available. READ ONLY
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
     - returns the object name, as a String
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
     
     - returns the read token, as an Int. Be aware that the read token may not be available, in which case, it will be nil.
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
     
     - returns the write token, as an Int. Be aware that the write token may not be available, in which case, it will be nil.
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
     - returns the language
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
     - returns the SDK instance that "owns" this instance.
     */
    public var sdkInstance: RVP_Cocoa_SDK? {
        return self._sdkInstance
    }
    
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
}
