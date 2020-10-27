/* ###################################################################################################################################### */
/**
    © Copyright 2018, The Great Rift Valley Software Company.
    
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
    
    The Great Rift Valley Software Company: https://riftvalleysoftware.com
*/

import Foundation

/* ###################################################################################################################################### */
// MARK: - Main Class -
/* ###################################################################################################################################### */
/**
 */
public class RVP_Cocoa_SDK_Login: A_RVP_Cocoa_SDK_Security_Object {
    /* ################################################################## */
    // MARK: - Internal Calculated Properties
    /* ################################################################## */
    /**
     - returns: a string, with the "plugin path" for the data item, with no ID attached. READ ONLY
     */
    override internal var _pluginPathNoID: String {
        return "/people/logins"
    }

    /* ################################################################## */
    /**
     - returns: a string, with the plugin type. READ ONLY
     */
    override internal var _pluginType: String {
        return "login"
    }

    /* ################################################################## */
    // MARK: - Public Properties and Calculated Properties
    /* ################################################################## */
    /**
     - returns: all of the values for this object, as a Dictionary. READ ONLY
     */
    override public var asDictionary: [String: Any?] {
        var ret = super.asDictionary
        ret ["isManager"] = self.isManager
        ret ["isMainAdmin"] = self.isMainAdmin
        ret ["isLoggedIn"] = self.isLoggedIn
        if let userObjectID = self.userObjectID {
            ret ["userObjectID"] = userObjectID
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     **NOTE:** Although this will let anyone with write permission set the ID, it will not be accepted on the server, unless the admin also has at least read permissions for the user object.
     
     - returns: the ID (Int) of any User Object associated with this login. nil, if there is none.
     */
    public var userObjectID: Int? {
        get {
            var ret: Int?
            
            if let userObjectID = self._myData["user_object_id"] as? Int {
                ret = userObjectID
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                self._myData["user_object_id"] = newValue
            }
        }
    }

    /* ################################################################## */
    /**
     - returns: true, if this login is currently logged in. READ ONLY
     */
    public var isLoggedIn: Bool {
        var ret = false
        
        if let isLoggedIn = self._myData["current_login"] as? Bool {
            ret = isLoggedIn
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     - returns: true, if this login is a Manager login. READ ONLY
     */
    public var isManager: Bool {
        var ret = false
        
        if let isManager = self._myData["is_manager"] as? Bool {
            ret = isManager
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     - returns: true, if this login is a "God" (Main admin) login. READ ONLY
     */
    public var isMainAdmin: Bool {
        var ret = false
        
        if let isMainAdmin = self._myData["is_main_admin"] as? Bool {
            ret = isMainAdmin
        }
        
        return ret
    }

    /* ################################################################## */
    // MARK: - Public Instance Methods
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
     Password changes are write-only. We can't see existing passwords, only send a new one.
     
     - parameter: The new password, as a String
     */
    public func changePasswordTo(_ inPassword: String) {
        if self.isWriteable,
           !inPassword.isEmpty {
            self._myData["password"] = inPassword
        }
    }
    
    /* ################################################################## */
    /**
     This is called to convert this login to a manager.
     */
    public func convertLoginToManager() {
        sdkInstance?._convertLogin(self, toManager: true)
    }
    
    /* ################################################################## */
    /**
     This is called to convert this login to a standard user.
     */
    public func convertLoginToUser() {
        sdkInstance?._convertLogin(self, toManager: false)
    }
}
