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
public class RVP_IOS_SDK_Place: A_RVP_IOS_SDK_Data_Object {
    /* ################################################################## */
    // MARK: - Public Methods and Calulated properties -
    /* ################################################################## */
    /**
     - returns all of the values for this object, as a Dictionary.
     */
    override public var asDictionary: [String: Any?] {
        var ret = super.asDictionary
        
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

        return ret
    }

    /* ################################################################## */
    /**
     - returns the venue name String.
     */
    public var venue: String {
        var ret: String = ""
        
        if let addressElems = self._myData["address_elements"] as? [String: String], let name = addressElems["venue"] {
            ret = name
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     - returns the street address String.
     */
    public var streetAddress: String {
        var ret: String = ""
        
        if let addressElems = self._myData["address_elements"] as? [String: String], let name = addressElems["street_address"] {
            ret = name
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     - returns the extra information String.
     */
    public var extraInformation: String {
        var ret: String = ""
        
        if let addressElems = self._myData["address_elements"] as? [String: String], let name = addressElems["extra_information"] {
            ret = name
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     - returns the town/city/municipality String.
     */
    public var town: String {
        var ret: String = ""
        
        if let addressElems = self._myData["address_elements"] as? [String: String], let name = addressElems["town"] {
            ret = name
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     - returns the county/sub-municipality String.
     */
    public var county: String {
        var ret: String = ""
        
        if let addressElems = self._myData["address_elements"] as? [String: String], let name = addressElems["county"] {
            ret = name
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     - returns the state/province String.
     */
    public var state: String {
        var ret: String = ""
        
        if let addressElems = self._myData["address_elements"] as? [String: String], let name = addressElems["state"] {
            ret = name
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     - returns the postal/zip code String.
     */
    public var postalCode: String {
        var ret: String = ""
        
        if let addressElems = self._myData["address_elements"] as? [String: String], let name = addressElems["postal_code"] {
            ret = name
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     - returns the nation String.
     */
    public var nation: String {
        var ret: String = ""
        
        if let addressElems = self._myData["address_elements"] as? [String: String], let name = addressElems["nation"] {
            ret = name
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
