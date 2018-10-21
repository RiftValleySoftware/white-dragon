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
import WhiteDragon

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
        
        init(tags: [String: String] = [:], location: RVP_Cocoa_SDK.LocationSpecification? = nil, plugin: String = "") {
            self.tags = tags
            self.location = location
            self.plugin = plugin
        }
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
            
            return (name: "Image Things", values: [imagesObject])
        }
        
        var videosObject: (name: String, values: [Any]) {
            let videosObject = SearchStructure(    tags: ["tag1": "video"],
                                                   location: nil,
                                                   plugin: "baseline")
            
            return (name: "Video Things", values: [videosObject])
        }
        
        var churchesObject: (name: String, values: [Any]) {
            let churchesObject = SearchStructure(    tags: ["venue": "%church%"],
                                                     location: nil,
                                                     plugin: "baseline")
            
            return (name: "Church Places", values: [churchesObject])
        }
        
        var beastsOfNoNationsObject: (name: String, values: [Any]) {
            let beastsOfNoNationsObject = SearchStructure(    tags: ["nation": ""],
                                                              location: nil,
                                                              plugin: "baseline")
            
            return (name: "Beasts of No Nations", values: [beastsOfNoNationsObject])
        }
        
        var enoughObject: (name: String, values: [Any]) {
            let enoughObject = SearchStructure(    tags: ["name": "%enough%"],
                                                   location: nil,
                                                   plugin: "baseline")
            
            return (name: "Enough in the Name", values: [enoughObject])
        }
        
        var theObject: (name: String, values: [Any]) {
            let theObject = SearchStructure(    tags: ["name": "%the%"],
                                                location: nil,
                                                plugin: "baseline")
            
            return (name: "The in the Name", values: [theObject])
        }
        
        var anyTextObject: (name: String, values: [Any]) {
            let anyTextObject = SearchStructure(    tags: ["tag9": "%"],
                                                location: nil,
                                                plugin: "baseline")
            
            return (name: "Anything in Tag 9", values: [anyTextObject])
        }

        retArray.append(contentsOf: [mdAdminObject,
                                     imagesObject,
                                     videosObject,
                                     churchesObject,
                                     beastsOfNoNationsObject,
                                     enoughObject,
                                     theObject,
                                     anyTextObject
            ])

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
                
                sdkInstance.fetchObjectsUsingCriteria(tags, andLocation: location, withPlugin: plugin)
            }
        }
    }
}
