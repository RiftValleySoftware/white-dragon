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
public class A_RVP_Cocoa_SDK_Security_Object: A_RVP_Cocoa_SDK_Object {
    /* ################################################################## */
    // MARK: - Public Methods and Calulated properties -
    /* ################################################################## */
    /**
     - returns all of the values for this object, as a Dictionary. READ ONLY
     */
    override public var asDictionary: [String: Any?] {
        var ret = super.asDictionary
        ret["loginID"] = self.loginID
        ret["securityTokens"] = self.securityTokens

        return ret
    }

    /* ################################################################## */
    /**
     - returns the object login ID, as a String. READ ONLY
     */
    public var loginID: String {
        var ret = ""
        
        if let loginID = self._myData["login_id"] as? String {
            ret = loginID
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     - returns the object security tokens, as an Array of Int. NOTE: The tokens are sorted, from lowest to highest, and include the ID of the login item. "1" is the "any logged-in-user" token that all logins are implied to have. READ ONLY
     */
    public var securityTokens: [Int] {
        get {
            var ret: [Int] = []
            
            if let securityTokens = self._myData["security_tokens"] as? [Int] {
                ret = securityTokens.sorted()
                if 1 != ret[0] {    // If 1 was not already there, we add it here.
                    ret.insert(1, at: 0)
                }
            }
            
            return ret
        }
        
        set {
            if (self._sdkInstance?.isManager)! && self._sdkInstance?.myLoginInfo != self && self.isWriteable {
                self._myData["security_tokens"] = newValue
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
        var originalData = inData
        if !originalData.isEmpty {  // We do this, so we have an original snapshot that is sorted.
            if let securityTokens = originalData["security_tokens"] as? [Int] {
                var newTokens = securityTokens.sorted()
                if 1 != newTokens[0] {    // If 1 was not already there, we add it here.
                    newTokens.insert(1, at: 0)
                }
                originalData["security_tokens"] = newTokens
            }
        }
        super.init(sdkInstance: inSDKInstance, objectInfoData: originalData)
    }
}
