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
class Test007MixedSearches: Test006BaselineLocationSearches {
    @IBOutlet weak var tagSegmentedControl1: UISegmentedControl!
    @IBOutlet weak var tagSegmentedControl2: UISegmentedControl!
    @IBOutlet weak var tagTextValue1: UITextField!
    @IBOutlet weak var tagTextValue2: UITextField!
    @IBOutlet weak var nameTextValue: UITextField!
    @IBOutlet weak var pluginSegmentedSwitch: UISegmentedControl!
    
    /* ################################################################## */
    /**
     */
    @IBAction func pluginSegmentedSwitchHit(_ sender: UISegmentedControl) {
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func tagSegmentedControl1Hit(_ sender: Any) {
        let mySelectedIndex = tagSegmentedControl1.selectedSegmentIndex
        
        if 0 <= mySelectedIndex {
            self.tagTextValue1.isEnabled = true
            tagSegmentedControl2.isEnabled = true
            
            for segment in 0..<10 {
                tagSegmentedControl2.setEnabled(segment != mySelectedIndex, forSegmentAt: segment)
            }
            
            self.tagTextValue1.becomeFirstResponder()
        }
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func tagSegmentedControl2Hit(_ sender: Any) {
        let mySelectedIndex = tagSegmentedControl2.selectedSegmentIndex
        
        if 0 <= mySelectedIndex {
            self.tagTextValue2.isEnabled = true

            for segment in 0..<10 {
                tagSegmentedControl1.setEnabled(segment != mySelectedIndex, forSegmentAt: segment)
           }
            
            self.tagTextValue2.becomeFirstResponder()
        }
    }

    /* ################################################################## */
    /**
     */
    override func getObjects() {
        self.clearResults()
        self.activityScreen?.isHidden = false
        let row = self.objectListPicker.selectedRow(inComponent: 0)
        if let objectLocation = self.presets[row].values as? [CLLocationDegrees] {
            var autoRadiusThreshold: Int
            
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
            
            var radiusInKm: CLLocationDistance
            
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
            
            var location: RVP_Cocoa_SDK.LocationSpecification!
            
            if 0 < autoRadiusThreshold && 0 < radiusInKm {
                location = RVP_Cocoa_SDK.LocationSpecification( coords: CLLocationCoordinate2D(latitude: objectLocation[0], longitude: objectLocation[1]),
                                                                radiusInKm: radiusInKm,
                                                                autoRadiusThreshold: autoRadiusThreshold)
            }
            
            self.getObjectsPartDeux(location: location)
        }
    }
    
    /* ################################################################## */
    /**
     */
    func getObjectsPartDeux(location inLocation: RVP_Cocoa_SDK.LocationSpecification!) {
        if let sdkInstance = self.mySDKTester?.sdkInstance {
            var tags: [String: String] = [:]
            
            if let text = self.tagTextValue1.text, !text.isEmpty {
                let selectedTag = String(self.tagSegmentedControl1.selectedSegmentIndex)
                tags["tag\(selectedTag)"] = text
            }
            
            if let text = self.tagTextValue2.text, !text.isEmpty {
                let selectedTag = String(self.tagSegmentedControl2.selectedSegmentIndex)
                tags["tag\(selectedTag)"] = text
            }
            
            if let text = self.nameTextValue.text, !text.isEmpty {
                tags["name"] = text
            }
            
            var usePlugin: String = ""
            
            if let plugin = self.pluginSegmentedSwitch.titleForSegment(at: self.pluginSegmentedSwitch.selectedSegmentIndex)?.lowercased() {
                usePlugin = plugin
            }
            
            sdkInstance.fetchObjectsUsingCriteria(tags, andLocation: inLocation, withPlugin: usePlugin)
        }
    }
}
