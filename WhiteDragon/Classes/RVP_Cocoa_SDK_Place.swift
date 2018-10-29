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
public class RVP_Cocoa_SDK_Place: A_RVP_Cocoa_SDK_Data_Object {
    /* ################################################################## */
    // MARK: - Internal Calculated Properties
    /* ################################################################## */
    /**
     - returns: a string, with the "plugin path" for the data item. READ ONLY
     */
    override internal var _pluginPath: String {
        return "/places/" + (0 != self.id ? String(self.id) : "")
    }
    
    /* ################################################################## */
    /**
     - returns: a string, with the plugin type. READ ONLY
     */
    override internal var _pluginType: String {
        return "places"
    }

    /* ################################################################## */
    // MARK: - Public Properties and Calculated Properties
    /* ################################################################## */
    /**
     - returns: all of the values for this object, as a Dictionary. READ ONLY
     */
    override public var asDictionary: [String: Any?] {
        var ret = super.asDictionary
        
        if !self.basicAddress.isEmpty {
            ret["basicAddress"] = self.basicAddress
        }
        
        if !self.venue.isEmpty {
            ret["venue"] = self.venue
        }

        if !self.streetAddress.isEmpty {
            ret["streetAddress"] = self.streetAddress
        }
        
        if !self.extraInformation.isEmpty {
            ret["extraInformation"] = self.extraInformation
        }
        
        if !self.town.isEmpty {
            ret["town"] = self.town
        }
        
        if !self.county.isEmpty {
            ret["county"] = self.county
        }
        
        if !self.state.isEmpty {
            ret["state"] = self.state
        }
        
        if !self.postalCode.isEmpty {
            ret["postalCode"] = self.postalCode
        }
        
        if !self.nation.isEmpty {
            ret["nation"] = self.nation
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
     - returns: the venue name String.
     */
    public var venue: String {
        get {
            var ret: String = ""
            
            if let addressElems = self._myData["address_elements"] as? [String: String], let name = addressElems["venue"] {
                ret = name
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                var newElements: [String: String] = [:]
                if let newElems = self._myData["address_elements"] as? [String: String] {
                   newElements = newElems
                }
                
                newElements["venue"] = newValue
                self._myData["address_elements"] = newElements
            }
        }
    }

    /* ################################################################## */
    /**
     - returns: the street address String.
     */
    public var streetAddress: String {
        get {
            var ret: String = ""
            
            if let addressElems = self._myData["address_elements"] as? [String: String], let name = addressElems["street_address"] {
                ret = name
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                var newElements: [String: String] = [:]
                if let newElems = self._myData["address_elements"] as? [String: String] {
                    newElements = newElems
                }
                
                newElements["street_address"] = newValue
                self._myData["address_elements"] = newElements
            }
        }
    }

    /* ################################################################## */
    /**
     - returns: the extra information String.
     */
    public var extraInformation: String {
        get {
            var ret: String = ""
            
            if let addressElems = self._myData["address_elements"] as? [String: String], let name = addressElems["extra_information"] {
                ret = name
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                var newElements: [String: String] = [:]
                if let newElems = self._myData["address_elements"] as? [String: String] {
                    newElements = newElems
                }
                
                newElements["extra_information"] = newValue
                self._myData["address_elements"] = newElements
            }
        }
    }

    /* ################################################################## */
    /**
     - returns: the town/city/municipality String.
     */
    public var town: String {
        get {
            var ret: String = ""
            
            if let addressElems = self._myData["address_elements"] as? [String: String], let name = addressElems["town"] {
                ret = name
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                var newElements: [String: String] = [:]
                if let newElems = self._myData["address_elements"] as? [String: String] {
                    newElements = newElems
                }
                
                newElements["town"] = newValue
                self._myData["address_elements"] = newElements
            }
        }
    }

    /* ################################################################## */
    /**
     - returns: the county/sub-municipality String.
     */
    public var county: String {
        get {
            var ret: String = ""
            
            if let addressElems = self._myData["address_elements"] as? [String: String], let name = addressElems["county"] {
                ret = name
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                var newElements: [String: String] = [:]
                if let newElems = self._myData["address_elements"] as? [String: String] {
                    newElements = newElems
                }
                
                newElements["county"] = newValue
                self._myData["address_elements"] = newElements
            }
        }
    }

    /* ################################################################## */
    /**
     - returns: the state/province String.
     */
    public var state: String {
        get {
            var ret: String = ""
            
            if let addressElems = self._myData["address_elements"] as? [String: String], let name = addressElems["state"] {
                ret = name
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                var newElements: [String: String] = [:]
                if let newElems = self._myData["address_elements"] as? [String: String] {
                    newElements = newElems
                }
                
                newElements["state"] = newValue
                self._myData["address_elements"] = newElements
            }
        }
    }

    /* ################################################################## */
    /**
     - returns: the postal/zip code String.
     */
    public var postalCode: String {
        get {
            var ret: String = ""
            
            if let addressElems = self._myData["address_elements"] as? [String: String], let name = addressElems["postal_code"] {
                ret = name
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                var newElements: [String: String] = [:]
                if let newElems = self._myData["address_elements"] as? [String: String] {
                    newElements = newElems
                }
                
                newElements["postal_code"] = newValue
                self._myData["address_elements"] = newElements
            }
        }
    }

    /* ################################################################## */
    /**
     - returns: the nation String.
     */
    public var nation: String {
        get {
            var ret: String = ""
            
            if let addressElems = self._myData["address_elements"] as? [String: String], let name = addressElems["nation"] {
                ret = name
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                var newElements: [String: String] = [:]
                if let newElems = self._myData["address_elements"] as? [String: String] {
                    newElements = newElems
                }
                
                newElements["nation"] = newValue
                self._myData["address_elements"] = newElements
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
    /**
     - returns: the basic address String. READ ONLY
     */
    public var basicAddress: String {
        var ret: String = ""
        
        if let address = self._myData["address"] as? String {
            ret = address
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
}
