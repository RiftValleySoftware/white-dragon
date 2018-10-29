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
class Test001BasicUserListing: TestBaseViewController {
    /* ################################################################## */
    /**
     */
    override var presets: [(name: String, values: [Any])] {
        return [(name: "MDAdmin", values: [1725]),
                (name: "CEO", values: [1751]),
                (name: "DC Area Admins", values: [1725, 1726, 1727, 1728, 1729, 1730]),
                (name: "Restricted Admins", values: [1730, 1731]),
                (name: "DilbertCo", values: [1745, 1746, 1747, 1748, 1749, 1750, 1751, 1752, 1753, 1754])
                ]
    }

    /* ################################################################## */
    /**
     */
    override func getObjects() {
        self.clearResults()
        if let sdkInstance = self.mySDKTester?.sdkInstance {
            let row = self.objectListPicker.selectedRow(inComponent: 0)
            if let userIDList = self.presets[row].values as? [Int] {
                self.activityScreen?.isHidden = false
                sdkInstance.fetchUsers(userIDList)
            }
        }
    }

    /* ################################################################## */
    /**
     */
    @IBAction override func createNewButtonPressed(_ sender: UIButton) {
    }

    /* ################################################################## */
    /**
     */
    @IBAction func createNewUserButtonPressed(_ sender: UIButton) {
    }

    /* ################################################################## */
    /**
     */
    @IBAction func createNewLoginButtonPressed(_ sender: UIButton) {
    }
}
