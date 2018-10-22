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
public class RVP_Cocoa_SDK_Thing: A_RVP_Cocoa_SDK_Data_Object {
    /* ################################################################## */
    // MARK: - Public Properties and Calculated Properties
    /* ################################################################## */
    /**
     - returns: all of the values for this object, as a Dictionary. READ ONLY
     */
    override public var asDictionary: [String: Any?] {
        var ret = super.asDictionary
        
        if !self.thingKey.isEmpty {
            ret["thingKey"] = self.thingKey
        }
        
        if !self.thingDescription.isEmpty {
            ret["thingDescription"] = self.thingDescription
        }
        
        if !self.tag2.isEmpty {
            ret["tag2"] = self.tag2
        }
        
        if !self.tag3.isEmpty {
            ret["tag3"] = self.tag3
        }
        
        if !self.tag4.isEmpty {
            ret["tag4"] = self.tag4
        }

        if !self.tag5.isEmpty {
            ret["tag5"] = self.tag5
        }

        if !self.tag6.isEmpty {
            ret["tag6"] = self.tag6
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
     - returns: the thing key String.
     */
    public var thingKey: String {
        get {
            var ret: String = ""
            
            if let key = self._myData["key"] as? String {
                ret = key
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                self._myData["key"] = newValue
            }
        }
    }
    
    /* ################################################################## */
    /**
     - returns: the thing description String.
     */
    public var thingDescription: String {
        get {
            var ret: String = ""
            
            if let desc = self._myData["description"] as? String {
                ret = desc
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                self._myData["description"] = newValue
            }
        }
    }

    /* ################################################################## */
    /**
     - returns: the tag2 String.
     */
    public var tag2: String {
        get {
            var ret: String = ""
            
            if let tag = self._myData["tag2"] as? String {
                ret = tag
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                self._myData["tag2"] = newValue
            }
        }
    }

    /* ################################################################## */
    /**
     - returns: the tag3 String.
     */
    public var tag3: String {
        get {
            var ret: String = ""
            
            if let tag = self._myData["tag3"] as? String {
                ret = tag
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                self._myData["tag3"] = newValue
            }
        }
    }

    /* ################################################################## */
    /**
     - returns: the tag4 String.
     */
    public var tag4: String {
        get {
            var ret: String = ""
            
            if let tag = self._myData["tag4"] as? String {
                ret = tag
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                self._myData["tag4"] = newValue
            }
        }
    }

    /* ################################################################## */
    /**
     - returns: the tag5 String.
     */
    public var tag5: String {
        get {
            var ret: String = ""
            
            if let tag = self._myData["tag5"] as? String {
                ret = tag
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                self._myData["tag5"] = newValue
            }
        }
    }

    /* ################################################################## */
    /**
     - returns: the tag6 String.
     */
    public var tag6: String {
        get {
            var ret: String = ""
            
            if let tag = self._myData["tag6"] as? String {
                ret = tag
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                self._myData["tag6"] = newValue
            }
        }
    }

    /* ################################################################## */
    /**
     - returns: the tag7 String.
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
     - returns: the tag8 String.
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
     - returns: the tag9 String.
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
}
