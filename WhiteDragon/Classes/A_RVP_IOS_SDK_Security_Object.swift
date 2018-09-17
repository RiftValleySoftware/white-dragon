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
public class A_RVP_IOS_SDK_Security_Object: A_RVP_IOS_SDK_Object {
    /* ################################################################## */
    // MARK: - Public Methods and Calulated properties -
    /* ################################################################## */
    /**
     */
    public override init(sdkInstance inSDKInstance: RVP_IOS_SDK? = nil, objectInfoData inData: [String: Any]) {
        super.init(sdkInstance: inSDKInstance, objectInfoData: inData)
    }
    
    /* ################################################################## */
    /**
     - returns the object login ID, as a String
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
     - returns the object security tokens, as an Array of Int. NOTE: The tokens are sorted, from lowest to highest, and include (or may only be) the ID of the login item. "1" is the "any logged-in-user" token that all logins are implied to have.
     */
    public var securityTokens: [Int] {
        var ret: [Int] = []
        
        if let securityTokens = self._myData["security_tokens"] as? [Int] {
            ret = securityTokens.sorted()
        }
        
        return ret
    }
}