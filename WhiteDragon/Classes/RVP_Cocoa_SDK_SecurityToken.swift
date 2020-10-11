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
 This class represents a generic "security token," as opposed to a login.
 */
public class RVP_Cocoa_SDK_SecurityToken: A_RVP_Cocoa_SDK_Security_Object {
    /* ################################################################## */
    // MARK: - Internal Calculated Properties
    /* ################################################################## */
    /**
     - returns: a string, with the "plugin path" for the data item, with no ID attached. READ ONLY
     */
    override internal var _pluginPathNoID: String {
        return "/baseline/tokens"
    }

    /* ################################################################## */
    /**
     - returns: a string, with the plugin type. READ ONLY
     */
    override internal var _pluginType: String {
        return "baseline"
    }
    
    /* ################################################################## */
    /**
     This handles creating a new token.
     */
    public func createNewToken() {
        self._sdkInstance?._postObject(self)
    }
}
