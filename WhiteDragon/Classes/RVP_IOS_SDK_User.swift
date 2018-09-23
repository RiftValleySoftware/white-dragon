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
public class RVP_IOS_SDK_User: A_RVP_IOS_SDK_Data_Object {
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

        return ret
    }
    
    /* ################################################################## */
    /**
     - returns the user surname, as an optional String
     */
    public var surname: String? {
        var ret: String?
        
        if let name = self._myData["surname"] as? String {
            ret = name
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     - returns the user middle name, as an optional String
     */
    public var middleName: String? {
        var ret: String?
        
        if let name = self._myData["middle_name"] as? String {
            ret = name
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     - returns the user given (first) name, as an optional String
     */
    public var givenName: String? {
        var ret: String?
        
        if let name = self._myData["given_name"] as? String {
            ret = name
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     - returns the user nickame, as an optional String
     */
    public var nickame: String? {
        var ret: String?
        
        if let name = self._myData["nickame"] as? String {
            ret = name
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     - returns the user prefix, as an optional String
     */
    public var prefix: String? {
        var ret: String?
        
        if let prefix = self._myData["prefix"] as? String {
            ret = prefix
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     - returns the user suffix, as an optional String
     */
    public var suffix: String? {
        var ret: String?
        
        if let prefix = self._myData["suffix"] as? String {
            ret = prefix
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     - returns the associated login ID (if any). 0, if no associated login.
     */
    public var loginID: Int {
        var ret: Int = 0
        
        if let id = self._myData["associated_login_id"] as? Int {
            ret = id
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     This is the default initializer.
     
     - parameter sdkInstance: REQUIRED (Can be nil) This is the SDK instance that "owns" this object. It may be nil for history instances.
     - parameter objectInfoData: REQUIRED This is the parsed JSON data for this object, as a Dictionary.
     */
    public override init(sdkInstance inSDKInstance: RVP_IOS_SDK?, objectInfoData inData: [String: Any]) {
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
