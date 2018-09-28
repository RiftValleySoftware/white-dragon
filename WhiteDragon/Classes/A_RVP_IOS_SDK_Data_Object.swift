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
import AVKit
import PDFKit

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
        
        if let canSeeThroughTheFuzz = self.canSeeThroughTheFuzz {
            ret["canSeeThroughTheFuzz"] = canSeeThroughTheFuzz
        }

        if !self.payloadType.isEmpty {
            ret["payloadType"] = self.payloadType
        }

        if let payload = self.payload {
            ret["payload"] = payload
        }

        return ret
    }
    
    /* ################################################################## */
    /**
     - returns the payload. If possible, as an object (images are UIImage, Video and Audio are AVAsset).
     */
    public var payload: Any? {
        var ret: Any?
        
        if  let payloadType = self._myData["payload_type"] as? String,
            let payload = self._myData["payload"] as? String {
            if let decodedData = NSData(base64Encoded: payload, options: NSData.Base64DecodingOptions(rawValue: 0)) {
                let myData = decodedData as Data
                if let slash = payloadType.index(of: "/"), let semicolon = payloadType.index(of: ";") {
                    let start = payloadType.index(after: slash)
                    let mediaType = payloadType[start..<semicolon].lowercased()
                    if payloadType.beginsWith("image/") {
                        ret = UIImage(data: myData)
                    } else if payloadType.beginsWith("video/") || payloadType.beginsWith("audio/") {
                        do {
                            var suffix: String = ""
                            switch mediaType {
                            case "mp4":
                                suffix = ".m4v"
                                
                            case "mpg":
                                suffix = ".mpg"
                                
                            case "avi":
                                suffix = ".avi"
                                
                            case "mov":
                                suffix = ".mov"
                                
                            case "mp3":
                                suffix = ".mp3"
                                
                            case "wav":
                                suffix = ".wav"
                                
                            default:
                                ret = myData
                            }
                            
                            if !suffix.isEmpty {
                                // We create a path to a unique temporary file to grab the media.
                                let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString + suffix)
                                // Store the media in the temp file.
                                try myData.write(to: url, options: .atomic)
                                let options = [AVURLAssetPreferPreciseDurationAndTimingKey: true]
                                let asset = AVURLAsset(url: url, options: options)
                                ret = asset
                            }
                        } catch let error {
                            #if DEBUG
                            print("Error Encoding AV Media!: \(error)!")
                            #endif
                            NSLog("Error Encoding AV Media: %@", error._domain)
                        }
                    } else if payloadType.beginsWith("text/") {
                        switch mediaType {
                        case "plain":
                            ret = String(data: myData, encoding: .utf8)

                        default:
                            ret = myData
                        }
                    } else {
                        switch mediaType {
                        case "pdf":
                            ret = PDFDocument(data: myData)
                            
                        default:
                            ret = myData
                        }
                    }
               }
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
    public override init(sdkInstance inSDKInstance: RVP_IOS_SDK?, objectInfoData inData: [String: Any]) {
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
