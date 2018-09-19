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
// MARK: - Class Extensions -
/* ###################################################################################################################################### */
/**
 This adds various functionality to the String class.
 */
extension String {
    /* ################################################################## */
    /**
     This tests a string to see if a given substring is present at the start.
     
     - parameter inSubstring: The substring to test.
     
     - returns: true, if the string begins with the given substring.
     */
    func beginsWith (_ inSubstring: String) -> Bool {
        var ret: Bool = false
        if let range = self.range(of: inSubstring) {
            ret = (range.lowerBound == self.startIndex)
        }
        return ret
    }
    
    /* ################################################################## */
    /**
     The following calculated property comes from this: http://stackoverflow.com/a/27736118/879365
     
     This extension function cleans up a URI string.
     
     - returns: a string, cleaned for URI.
     */
    var urlEncodedString: String? {
        let customAllowedSet =  CharacterSet.urlQueryAllowed
        if let ret = self.addingPercentEncoding(withAllowedCharacters: customAllowedSet) {
            return ret
        } else {
            return ""
        }
    }

    /* ################################################################## */
    /**
     This was cribbed from here: https://stackoverflow.com/a/48867619/879365
     
     This is a quick "classmaker" from a String. You assume the String is the name of
     a class that you want to instantiate, so you use this to return a metatype that
     can be used to create a class.
     
     - returns: a metatype for a class, or nil, if the class cannot be instantiated.
     */
    var asClass: AnyClass? {
        // The first thing we do, is get the main app bundle. Failure retuend nil.
        guard
            let dict = Bundle.main.infoDictionary,
            var appName = dict["CFBundleName"] as? String
        else {
            return nil
        }
        
        // The app name will not tolerate spaces, so they are replaced with underscores.
        appName = appName.replacingOccurrences(of: " ", with: "_")
        
        // The class name is simply a namespace-focused string.
        let className = appName + "." + self
        
        // This looks through the app for the class being loaded. If it finds it, it returns the metatype for that class.
        return NSClassFromString(className)
    }

    /* ################################################################## */
    /**
     The following function comes from this: http://stackoverflow.com/a/27736118/879365
     
     This extension function creates a URI query string from given parameters.
     
     - parameter parameters: a dictionary containing query parameters and their values.
     
     - returns: a String, with the parameter list.
     */
    static func queryStringFromParameters(_ parameters: [String: String]) -> String? {
        if parameters.isEmpty {
            return nil
        }
        
        var queryString: String?
        
        for (key, value) in parameters {
            if let encodedKey = key.urlEncodedString {
                if let encodedValue = value.urlEncodedString {
                    if queryString == nil {
                        queryString = "?"
                    } else {
                        queryString! += "&"
                    }
                    queryString! += encodedKey + "=" + encodedValue
                }
            }
        }
        return queryString
    }
    
    /* ################################################################## */
    /**
     "Cleans" a URI
     
     - returns: an implicitly unwrapped optional String. This is the given URI, "cleaned up" ("http[s]://" may be prefixed).
     */
    func cleanURI() -> String! {
        return self.cleanURI(sslRequired: false)
    }
    
    /* ################################################################## */
    /**
     "Cleans" a URI, allowing SSL requirement to be specified.
     
     - parameter sslRequired: If true, then we insist on SSL.
     
     - returns: an implicitly unwrapped optional String. This is the given URI, "cleaned up" ("http[s]://" may be prefixed)
     */
    func cleanURI(sslRequired: Bool) -> String! {
        var ret: String! = self.urlEncodedString
        
        // Very kludgy way of checking for an HTTPS URI.
        let wasHTTP: Bool = ret.lowercased().beginsWith("http://")
        let wasHTTPS: Bool = ret.lowercased().beginsWith("https://")
        
        // Yeah, this is pathetic, but it's quick, simple, and works a charm.
        ret = ret.replacingOccurrences(of: "^http[s]{0,1}://", with: "", options: NSString.CompareOptions.regularExpression)
        
        if wasHTTPS || (sslRequired && !wasHTTP && !wasHTTPS) {
            ret = "https://" + ret
        } else {
            ret = "http://" + ret
        }
        
        return ret
    }
    
}
