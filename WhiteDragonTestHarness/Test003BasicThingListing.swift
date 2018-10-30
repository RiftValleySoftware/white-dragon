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
class Test003BasicThingListing: TestBaseViewController {
    /* ################################################################## */
    /**
     */
    override var presets: [(name: String, values: [Any])] {
        return [(name: "Single Image (Int)", values: [1732]),
                (name: "Multiple Images (Int)", values: [1732, 1733, 1734, 1736, 1739, 1742, 1755]),
                (name: "Single Image (String)", values: ["basalt-test-0171: Worth Enough"]),
                (name: "Multiple Images (String)", values: ["basalt-test-0171: Worth Enough", "basalt-test-0171: Another World", "basalt-test-0171: Top Shot", "basalt-test-0171: Yosemite", "basalt-test-0171: Winnie The Pooh", "basalt-test-0171: Spinning Earth", "basalt-test-0171: Common Sense"]),
                (name: "Single MP4 Video (Int)", values: [1737]),
                (name: "Single MP4 Video (String)", values: ["basalt-test-0171: Tom And Jerry"]),
                (name: "Multiple MP4 Videos (Int)", values: [1737, 1741]),
                (name: "Multiple MP4 Videos (String)", values: ["basalt-test-0171: Tom And Jerry", "basalt-test-0171: Singing Pete"]),
                (name: "Single MP3 Audio (Int)", values: [1738]),
                (name: "Single MP3 Audio (String)", values: ["basalt-test-0171: Brown And Williamson Phone Message"]),
                (name: "Multiple Audio (Int)", values: [1738, 1740]),
                (name: "Multiple Audio (String)", values: ["basalt-test-0171: Brown And Williamson Phone Message", "basalt-test-0171: Crickets"]),
                (name: "Single Text (Int)", values: [1743]),
                (name: "Single Text (String)", values: ["basalt-test-0171: The Three Musketeers In Dutch"]),
                (name: "Single EPUB (Int)", values: [1744]),
                (name: "Single EPUB (String)", values: ["basalt-test-0171: The Divine Comedy Illustrated."]),
                (name: "Single PDF (Int)", values: [1756]),
                (name: "Single PDF (String)", values: ["basalt-test-0171: Multiplicative Idiocy"])

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
            if let objectIDList = self.presets[row].values as? [Int] {
                sdkInstance.fetchThings(objectIDList)
            } else if let objectIDList = self.presets[row].values as? [String] {
                sdkInstance.fetchThings(objectIDList)
            }
        }
    }

    /* ################################################################## */
    /**
     */
    override func checkButtonVisibility() {
        super.checkButtonVisibility()
    }

    /* ################################################################## */
    /**
     */
    @IBAction override func createNewButtonPressed(_ sender: UIButton) {
    }
}
