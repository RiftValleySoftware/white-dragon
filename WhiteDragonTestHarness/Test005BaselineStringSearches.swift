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

import UIKit
import MapKit

/* ###################################################################################################################################### */
// MARK: - Test Class -
/* ###################################################################################################################################### */
/**
 */
class Test005BaselineStringSearches: TestBaseViewController {
    /* ################################################################## */
    /**
     */
    struct SearchStructure {
        var tags: [String: String] = [:]
        var location: RVP_Cocoa_SDK.LocationSpecification?
        var plugin: String = ""
    }
    
    /* ################################################################## */
    /**
     */
    override var presets: [(name: String, values: [Any])] {
        var retArray: [(name: String, values: [Any])] = []
        
        var mdAdminObject: (name: String, values: [Any]) {
            let mdAdminLocation = RVP_Cocoa_SDK.LocationSpecification(  coords: CLLocationCoordinate2D(latitude: 39.310103, longitude: -76.598405),
                                                                        radiusInKm: 20.0,
                                                                        autoRadiusThreshold: 1)
            let mdAdminObject = SearchStructure(    tags: ["name": "MDAdmin"],
                                                    location: mdAdminLocation,
                                                    plugin: "baseline")
            
            return (name: "MDAdmin", values: [mdAdminObject])
        }
        
        let mdAdminLocation = RVP_Cocoa_SDK.LocationSpecification(  coords: CLLocationCoordinate2D(latitude: 39.310103, longitude: -76.598405),
                                                                    radiusInKm: 20.0,
                                                                    autoRadiusThreshold: 1)
        var imagesObject: (name: String, values: [Any]) {
            let imagesObject = SearchStructure(    tags: ["tag1": "image"],
                                                   location: nil,
                                                   plugin: "baseline")
            
            return (name: "ImageThings", values: [imagesObject])
        }

        retArray.append(mdAdminObject)
        retArray.append(imagesObject)

        return  retArray
    }
    
    /* ################################################################## */
    /**
     */
    override func getObjects() {
        self.clearResults()
        if let sdkInstance = self.mySDKTester?.sdkInstance {
            self.activityScreen?.isHidden = false
            let row = self.objectListPicker.selectedRow(inComponent: 0)
            if let param = (self.presets[row].values as? [SearchStructure])?[0] {
                let tags = param.tags
                let location = param.location
                let plugin = param.plugin
                
                sdkInstance.fetchObjectsByString(tags, andLocation: location, withPlugin: plugin)
            }
        }
    }
}
