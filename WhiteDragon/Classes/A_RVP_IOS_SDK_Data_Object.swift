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
import MapKit

/* ###################################################################################################################################### */
// MARK: - Main Class -
/* ###################################################################################################################################### */
/**
 */
public class A_RVP_IOS_SDK_Data_Object: A_RVP_IOS_SDK_Object {
    /* ################################################################## */
    // MARK: - Public Methods and Calulated properties -
    /* ################################################################## */
    /**
     - returns all of the values for this object, as a Dictionary.
     */
    override public var asDictionary: [String: Any?] {
        var ret = super.asDictionary
        
        ret ["isFuzzy"] = self.isFuzzy
        
        if let fuzzFactor = self.fuzzFactor {
            ret ["fuzzFactor"] = fuzzFactor
        }
        
        if let location = self.location {
            ret ["location"] = location
        }
        
        if let rawLocation = self.rawLocation {
            ret ["raw_location"] = rawLocation
        }

        return ret
    }

    /* ################################################################## */
    /**
     - returns true, if the instance is fuzzy.
     */
    public var isFuzzy: Bool {
        var ret: Bool = false
        
        if let isFuzzy = self._myData["fuzzy"] as? Bool {
            ret = isFuzzy
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     - returns a "fuzz factor," which is the number of Kilometers of "slop" that location obfuscation uses. Be aware that it may not be available, in which case, this will be nil.
     */
    public var fuzzFactor: Double? {
        var ret: Double?
        
        if let isFuzzy = self._myData["fuzzy"] as? Bool, isFuzzy {
            if let fuzzFactor = self._myData["fuzz_factor"] as? Double {
                ret = fuzzFactor
            }
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     - returns the longitude and latitude as a coordinate. Be aware that they may not be available, in which case, it will be nil.
     */
    public var location: CLLocationCoordinate2D? {
        var ret: CLLocationCoordinate2D?
        
        if let long = self._myData["longitude"] as? Double, let lat = self._myData["latitude"] as? Double {
            ret = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     - returns the "raw" longitude and latitude as a coordinate. Be aware that they may not be available, in which case, it will be nil.
     */
    public var rawLocation: CLLocationCoordinate2D? {
        var ret: CLLocationCoordinate2D?
        
        if let long = self._myData["raw_longitude"] as? Double, let lat = self._myData["raw_latitude"] as? Double {
            ret = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     */
    public override init(sdkInstance inSDKInstance: RVP_IOS_SDK? = nil, objectInfoData inData: [String: Any]) {
        super.init(sdkInstance: inSDKInstance, objectInfoData: inData)
    }
}
