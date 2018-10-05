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
// MARK: - Payload Class -
/* ###################################################################################################################################### */
/**
 This is a special class for representing the payload as an atomic object. It encapsulates the type and the payload, as a Data object.
 
 Expressing it as a class gives us a couple of things: 1) It allows us to keep it as a reference, as opposed to a copy, and 2) It allows us to easily extend the class with data interpretation.
 */
public class RVP_Cocoa_SDK_Payload {
    public var payloadData: Data?
    public var payloadType: String = ""
    
    /* ################################################################## */
    // MARK: - Public Methods -
    /* ################################################################## */
    /**
     Default Initializer.
     
     - parameter payloadData: The payload, as a Data object.
     - parameter payloadType: The payload's MIME type.
     */
    public init(payloadData inData: Data, payloadType inType: String) {
        self.payloadData = inData
        self.payloadType = inType
    }
}

/* ###################################################################################################################################### */
// MARK: - Main Class -
/* ###################################################################################################################################### */
/**
 This is a generic "data database" class, encapsulating the generic methods and data items that go with the data database.
 */
public class A_RVP_Cocoa_SDK_Data_Object: A_RVP_Cocoa_SDK_Object {
    /* ################################################################## */
    // MARK: - Public Methods and Calulated properties -
    /* ################################################################## */
    /**
     - returns all of the values for this object, as a Dictionary.
     */
    override public var asDictionary: [String: Any?] {
        var ret = super.asDictionary
        
        if self.isFuzzy {
            ret["isFuzzy"] = true
        }
        
        if !self.childrenIDs.isEmpty {
            ret["childrenIDs"] = self.childrenIDs
        }

        if let fuzzFactor = self.fuzzFactor, 0.0 < fuzzFactor {
            ret["fuzzFactor"] = fuzzFactor
        }
        
        if let location = self.location {
            ret["location"] = location
        }
        
        if let rawLocation = self.rawLocation {
            ret["raw_location"] = rawLocation
        }
        
        if let distance = self.distance {
            ret["distance"] = distance
        }

        if let canSeeThroughTheFuzz = self.canSeeThroughTheFuzz {
            ret["canSeeThroughTheFuzz"] = canSeeThroughTheFuzz
        }

        if let payload = self.payload {
            ret["payload"] = payload
        }

        return ret
    }
    
    /* ################################################################## */
    /**
     - returns the payload. If possible. The payload will be expressed as a Data object. The type will be the MIME type.
     */
    public var payload: RVP_Cocoa_SDK_Payload? {
        var ret: RVP_Cocoa_SDK_Payload?
        
        if  let payload = self._myData["payload"] as? String {
            // We need to remove the Base64 encoding for the data, then we convert it to a basic Data object.
            if let decodedData = NSData(base64Encoded: payload, options: NSData.Base64DecodingOptions(rawValue: 0)) as Data? {
                ret = RVP_Cocoa_SDK_Payload(payloadData: decodedData, payloadType: self.payloadType)
            }
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     - returns a Dictionary of Arrays of Int, with the IDs (not objects) of "children" records. The possible Dictionary keys are "people", "places" and "things". Each of the values will be an Array of Int, with the Children IDs. READ ONLY
     */
    public var childrenIDs: [String: [Int]] {
        var ret: [String: [Int]] = [:]
        
        if let childrenIDs = self._myData["children"] as? [String: [Int]] {
            ret = childrenIDs
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     - returns the payload type (MIME type). READ ONLY
     */
    public var payloadType: String {
        var ret: String = ""
        
        if let payloadType = self._myData["payload_type"] as? String {
            if let semicolon = payloadType.index(of: ";") {
                ret = String(payloadType.prefix(upTo: semicolon))
            }
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     This will return any distance sent by the server, or one calculated "on the spot,"
     if there was no server distance, the object has a location, and the searchLocation
     instance property was set.
     
     - returns the distance, if provided. READ ONLY
     */
    public var distance: CLLocationDistance? {
        var ret: CLLocationDistance?
        
        // If the server returned a distance, we always use that.
        if let distance = self._myData["distance"] as? Double {
            ret = distance
        } else if let loca = self.location, let searchCent = self.searchLocation {  // Otherwise, use CoreLocation to calculate the distance.
            let location = CLLocation(latitude: loca.latitude, longitude: loca.longitude)
            let searchCenter = CLLocation(latitude: searchCent.latitude, longitude: searchCent.longitude)
            ret = location.distance(from: searchCenter) / 1000.0    // Konvert to Km
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     - returns true, if the instance is fuzzy. READ ONLY
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
     - returns a "fuzz factor," which is the number of Kilometers of "slop" that location obfuscation uses. Be aware that it may not be available, in which case, this will be nil. If you set (or clear) the fuzz factor, the "isFuzzy" value may be changed.
     */
    public var fuzzFactor: Double? {
        get {
            var ret: Double?
            
            if let isFuzzy = self._myData["fuzzy"] as? Bool, isFuzzy {
                if let fuzzFactor = self._myData["fuzz_factor"] as? Double {
                    ret = fuzzFactor
                }
            }
            
            return ret
        }
        
        set {
            if self.isWriteable {
                self._myData["fuzz_factor"] = newValue
                self._myData["fuzzy"] = 0.0 != newValue
            }
        }
    }

    /* ################################################################## */
    /**
     - returns an Int, which is the token assigned as an "extra" token that "can see through the fuzz," meaning that holders of that token can see the "raw" location.
     */
    public var canSeeThroughTheFuzz: Int? {
        get {
            var ret: Int?
            
            if let canSeeThroughTheFuzz = self._myData["can_see_through_the_fuzz"] as? Int {
                ret = canSeeThroughTheFuzz
            }
            
            return ret
        }
        
        // We cannot set any tokens that we don't have, ourselves.
        set {
            if self.isWriteable, let newVal = newValue, (self._sdkInstance?.securityTokens.contains(newVal))! {
                self._myData["can_see_through_the_fuzz"] = newVal
            }
        }
    }
    
    /* ################################################################## */
    /**
     - returns the longitude and latitude as a coordinate. Be aware that they may not be available, in which case, it will be nil.
     */
    public var location: CLLocationCoordinate2D? {
        get {
            var ret: CLLocationCoordinate2D?
            
            if let long = self._myData["longitude"] as? Double, let lat = self._myData["latitude"] as? Double {
                ret = CLLocationCoordinate2D(latitude: lat, longitude: long)
            }
            
            return ret
        }
        
        set {
            if self.isWriteable, let newVal = newValue {
                self._myData["longitude"] = newVal.longitude
                self._myData["latitude"] = newVal.latitude
            }
        }
    }

    /* ################################################################## */
    /**
     This is a special "settable" property with the center of a radius search.
     If the object already has a "distance" property returned from the server,
     this is ignored. Otherwise, if it is provided, and the object has a long/lat,
     the "distance" read-only property will return a Vincenty's Formulae distance
     in Kilometers from this center.
     */
    public var searchLocation: CLLocationCoordinate2D? {
        if let sdkInstance = self.sdkInstance {
            return sdkInstance.searchLocation
        }
        
        return nil
    }
    
    /* ################################################################## */
    /**
     - returns the "raw" longitude and latitude as a coordinate. Be aware that they may not be available, in which case, it will be nil. READ ONLY
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
     This is the default initializer.
     
     - parameter sdkInstance: REQUIRED (Can be nil) This is the SDK instance that "owns" this object. It may be nil for history instances.
     - parameter objectInfoData: REQUIRED This is the parsed JSON data for this object, as a Dictionary.
     */
    public override init(sdkInstance inSDKInstance: RVP_Cocoa_SDK?, objectInfoData inData: [String: Any]) {
        super.init(sdkInstance: inSDKInstance, objectInfoData: inData)
    }
    
    /* ################################################################## */
    /**
     This asks the server to return all of the "children" objects. It could result in a fairly large response.
     */
    public func fetchChildrenObjects() {
        let childObjects = self.childrenIDs
        
        // We go through each of the plugin types, and ask for all the children for each plugin.
        for tup in childObjects {
            if let sdkInstance = self._sdkInstance {
                sdkInstance.fetchDataItemsByIDs(tup.value, andPlugin: tup.key)
            }
        }
    }
}
