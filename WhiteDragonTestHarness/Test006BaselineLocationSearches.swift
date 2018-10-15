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

class Test006BaselineLocationSearches: TestBaseViewController {
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
                let locationCoords = CLLocationCoordinate2D(latitude: objectLocation[0], longitude: objectLocation[1])
            }
        }
    }
}