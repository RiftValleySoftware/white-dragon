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

import UIKit
import MapKit
import WhiteDragon

/* ###################################################################################################################################### */
// MARK: - Test Class -
/* ###################################################################################################################################### */
/**
 */
class Test006BaselineLocationSearches: TestBaseViewController {
    @IBOutlet weak var autoRadiusSegmentedSwitch: UISegmentedControl!
    @IBOutlet weak var fixedRadiusSegmentedSwitch: UISegmentedControl!
    
    /* ################################################################## */
    /**
     */
    @IBAction func autoRadiusSwitchChanged(_ sender: UISegmentedControl) {
        self.clearResults()
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func fixedRadiusSwitchChanged(_ sender: UISegmentedControl) {
        self.clearResults()
    }

    /* ################################################################## */
    /**
     */
    override var presets: [(name: String, values: [Any])] {
        return  [(name: "The Washington Monument", values: [CLLocationDegrees(38.8895), CLLocationDegrees(-77.0353)]),
                 (name: "Baltimore Inner Harbor", values: [CLLocationDegrees(39.2858), CLLocationDegrees(-76.6131)]),
                 (name: "Charlestown, WV", values: [CLLocationDegrees(39.2890), CLLocationDegrees(-77.8597)]),
                 (name: "Wilmington, DE", values: [CLLocationDegrees(39.7447), CLLocationDegrees(-75.5484)]),
                 (name: "Mount Vernon", values: [CLLocationDegrees(38.7293), CLLocationDegrees(-77.1074)])
                ]
    }
    
    /* ################################################################## */
    /**
     */
    override func getObjects() {
        self.clearResults()
        if let sdkInstance = self.mySDKTester?.sdkInstance {
            self.activityScreen?.isHidden = false
            let row = self.objectListPicker.selectedRow(inComponent: 0)
            if let objectLocation = self.presets[row].values as? [CLLocationDegrees] {
                var autoRadiusThreshold = 0
                
                switch self.autoRadiusSegmentedSwitch.selectedSegmentIndex {
                case 1:
                    autoRadiusThreshold = 1
                case 2:
                    autoRadiusThreshold = 5
                case 3:
                    autoRadiusThreshold = 10
                case 4:
                    autoRadiusThreshold = 20
                case 5:
                    autoRadiusThreshold = 100
                default:
                    autoRadiusThreshold = 0
                }
                
                var radiusInKm: CLLocationDistance = 0
                
                switch self.fixedRadiusSegmentedSwitch.selectedSegmentIndex {
                case 0:
                    radiusInKm = 0.25
                case 1:
                    radiusInKm = 0.5
                case 2:
                    radiusInKm = 2
                case 3:
                    radiusInKm = 10
                case 4:
                    radiusInKm = 20
                case 5:
                    radiusInKm = 100
                default:
                    radiusInKm = 0
                }
                
                let location = RVP_Cocoa_SDK.LocationSpecification( coords: CLLocationCoordinate2D(latitude: objectLocation[0], longitude: objectLocation[1]),
                                                                    radiusInKm: radiusInKm,
                                                                    autoRadiusThreshold: autoRadiusThreshold)
                sdkInstance.fetchObjectsUsingCriteria(andLocation: location)
            }
        }
    }
}
