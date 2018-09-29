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
public class RVP_Cocoa_SDK_User: A_RVP_Cocoa_SDK_Data_Object {
    /* ################################################################## */
    // MARK: - Public Methods and Calulated properties -
    /* ################################################################## */
    /**
     - returns all of the values for this object, as a Dictionary.
     */
    override public var asDictionary: [String: Any?] {
        var ret = super.asDictionary
        
        if 0 < self.loginID {
            ret["loginID"] = self.loginID
        }
        
        if let surname = self.surname {
            ret["surname"] = surname
        }
        
        if let middleName = self.middleName {
            ret["middleName"] = middleName
        }
        
        if let givenName = self.givenName {
            ret["givenName"] = givenName
        }
        
        if let nickame = self.nickame {
            ret["nickame"] = nickame
        }
        
        if let prefix = self.prefix {
            ret["prefix"] = prefix
        }
        
        if let suffix = self.suffix {
            ret["suffix"] = suffix
        }
        
        if !self.tag7.isEmpty {
            ret["tag7"] = self.tag7
        }
        
        if !self.tag8.isEmpty {
            ret["tag8"] = self.tag8
        }

        if !self.tag9.isEmpty {
            ret["tag9"] = self.tag9
        }

        return ret
    }
    
    /* ################################################################## */
    /**
     - returns the user surname, as an optional String
     */
    public var surname: String? {
        get {
            var ret: String?
            
            if let name = self._myData["surname"] as? String {
                ret = name
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                self._myData["surname"] = newValue
            }
        }
    }
    
    /* ################################################################## */
    /**
     - returns the user middle name, as an optional String
     */
    public var middleName: String? {
        get {
            var ret: String?
            
            if let name = self._myData["middle_name"] as? String {
                ret = name
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                self._myData["middle_name"] = newValue
            }
        }
    }
    
    /* ################################################################## */
    /**
     - returns the user given (first) name, as an optional String
     */
    public var givenName: String? {
        get {
            var ret: String?
            
            if let name = self._myData["given_name"] as? String {
                ret = name
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                self._myData["given_name"] = newValue
            }
        }
    }
    
    /* ################################################################## */
    /**
     - returns the user nickame, as an optional String
     */
    public var nickame: String? {
        get {
            var ret: String?
            
            if let name = self._myData["nickame"] as? String {
                ret = name
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                self._myData["nickname"] = newValue
            }
        }
    }
    
    /* ################################################################## */
    /**
     - returns the user prefix, as an optional String
     */
    public var prefix: String? {
        get {
            var ret: String?
            
            if let prefix = self._myData["prefix"] as? String {
                ret = prefix
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                self._myData["prefix"] = newValue
            }
        }
    }
    
    /* ################################################################## */
    /**
     - returns the user suffix, as an optional String
     */
    public var suffix: String? {
        get {
            var ret: String?
            
            if let prefix = self._myData["suffix"] as? String {
                ret = prefix
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                self._myData["suffix"] = newValue
            }
        }
    }
    
    /* ################################################################## */
    /**
     **NOTE:** Although this will let anyone with write permission set the ID, it will not be accepted on the server, unless the admin also has at least read permissions for the login object.
     
     - returns the associated login ID (if any). 0, if no associated login.
     */
    public var loginID: Int {
        get {
            var ret: Int = 0
            
            if let id = self._myData["associated_login_id"] as? Int {
                ret = id
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                self._myData["associated_login_id"] = newValue
            }
        }
    }

    /* ################################################################## */
    /**
     - returns the tag7 String.
     */
    public var tag7: String {
        get {
            var ret: String = ""
            
            if let tag = self._myData["tag7"] as? String {
                ret = tag
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                self._myData["tag7"] = newValue
            }
        }
    }

    /* ################################################################## */
    /**
     - returns the tag8 String.
     */
    public var tag8: String {
        get {
            var ret: String = ""
            
            if let tag = self._myData["tag8"] as? String {
                ret = tag
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                self._myData["tag8"] = newValue
            }
        }
    }

    /* ################################################################## */
    /**
     - returns the tag9 String.
     */
    public var tag9: String {
        get {
            var ret: String = ""
            
            if let tag = self._myData["tag9"] as? String {
                ret = tag
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                self._myData["tag9"] = newValue
            }
        }
    }

    /* ################################################################## */
    /**
     This is the default initializer.
     
     - parameter sdkInstance: REQUIRED (Can be nil) This is the SDK instance that "owns" this object. It may be nil for history instances.
     - parameter objectInfoData: REQUIRED This is the parsed JSON data for this object, as a Dictionary.
     */
    public override init(sdkInstance inSDKInstance: RVP_Cocoa_SDK?, objectInfoData inData: [String: Any]) {
        super.init(sdkInstance: inSDKInstance, objectInfoData: inData)
    }
    
    /* ################################################################## */
    /**
     This method tells the SDK to fetch the associated login object.
     
     Nothing happens, if this user does not have an associated login.
     
     - returns: true, if we have an instance, and have requested it be fetched. False, if we have no instance.
     */
    public func fetchLoginInstance() -> Bool {
        var ret = false
        
        if 0 < self.loginID {
            self._sdkInstance?.fetchLogins([self.loginID])
            ret = true
        }
        
        return ret
    }
}
