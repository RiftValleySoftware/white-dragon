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
public class RVP_IOS_SDK_Login: A_RVP_IOS_SDK_Security_Object {
    /* ################################################################## */
    // MARK: - Public Methods and Calulated properties -
    /* ################################################################## */
    /**
     - returns all of the values for this object, as a Dictionary.
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
     - returns the ID (Int) of any User Object associated with this login. nil, if there is none.
     */
    public var userObjectID: Int? {
        var ret: Int?
        
        if let userObjectID = self._myData["user_object_id"] as? Int {
            ret = userObjectID
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     - returns true, if this login is currently logged in.
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
     - returns true, if this login is a Manager login.
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
     - returns true, if this login is a "God" (Main admin) login.
     */
    public var isMainAdmin: Bool {
        var ret = false
        
        if let isMainAdmin = self._myData["is_main_admin"] as? Bool {
            ret = isMainAdmin
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
}
