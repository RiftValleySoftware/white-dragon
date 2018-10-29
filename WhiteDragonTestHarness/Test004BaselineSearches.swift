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
class Test004BaselineSearches: TestBaseViewController {
    /* ################################################################## */
    /**
     */
    override var presets: [(name: String, values: [Any])] {
        return  [(name: "Single Image", values: [1732]),
                 (name: "Single Image and Single Place", values: [2, 1732]),
                 (name: "Single Image, Single Place, and Single User", values: [2, 1725, 1732]),
                 (name: "Multiple Images", values: [1732, 1733, 1734, 1736, 1739, 1742, 1755]),
                 (name: "Multiple Places", values: [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 875, 876, 877, 879, 880, 881, 882, 883, 884, 885, 886, 1640, 1641, 1642, 1643, 1644, 1645, 1646, 1647, 1648, 1700, 1701, 1702, 1703]),
                 (name: "DC Area Admins", values: [1725, 1726, 1727, 1728, 1729, 1730]),
                 (name: "DilbertCo Restricted People", values: [1745, 1746, 1747, 1748, 1749, 1750, 1751, 1752, 1753, 1754]),
                 (name: "DC Area Admins, Images and Places", values: [1725, 1726, 1727, 1728, 1729, 1730, 1732, 1733, 1734, 1736, 1739, 1742, 1755, 885, 886, 1640, 1641, 1642, 1643])
                ]
    }

    /* ################################################################## */
    /**
     */
    override func getObjects() {
        self.clearResults()
        if let sdkInstance = self.mySDKTester?.sdkInstance {
            let row = self.objectListPicker.selectedRow(inComponent: 0)
            if let iDList = self.presets[row].values as? [Int] {
                self.activityScreen.isHidden = false
                sdkInstance.fetchBaselineObjectsByID(iDList)
            }
        }
    }
}
