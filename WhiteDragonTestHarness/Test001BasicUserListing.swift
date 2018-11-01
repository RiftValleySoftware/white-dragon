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
// MARK: - Select New Login Stuff Class -
/* ###################################################################################################################################### */
/**
 */
class SelectNewUserLoginViewController: UIViewController {
    var sdkInstance: RVP_Cocoa_SDK!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var chooseLoginIDTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!

    @IBAction func loginIDChanged(_ sender: UITextField) {
        self.saveButton.isEnabled = !(self.chooseLoginIDTextField.text?.isEmpty ?? false && self.nameTextField.text?.isEmpty ?? false)
    }

    @IBAction func nameChanged(_ sender: UITextField) {
        self.saveButton.isEnabled = !(self.chooseLoginIDTextField.text?.isEmpty ?? false && self.nameTextField.text?.isEmpty ?? false)
    }

    @IBAction func saveButtonHit(_ sender: Any) {
        self.sdkInstance?.createUserLoginPair(loginString: self.chooseLoginIDTextField.text!, name: self.nameTextField.text!)
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelButtonHit(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

/* ###################################################################################################################################### */
// MARK: - Test Class -
/* ###################################################################################################################################### */
/**
 */
class Test001BasicUserListing: TestBaseViewController {
    @IBOutlet weak var createNewLoginButton: UIButton!
    @IBOutlet weak var createNewUserButton: UIButton!
    @IBOutlet weak var fetchAllLoginsButton: UIButton!
    
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
    override func checkButtonVisibility() {
        DispatchQueue.main.async {
            if let button = self.createNewLoginButton, let sdkObject = self.mySDKTester?.sdkInstance {
                button.isHidden = !sdkObject.isManager
            }
            if let button = self.createNewUserButton, let sdkObject = self.mySDKTester?.sdkInstance {
                button.isHidden = !sdkObject.isManager
            }
            if let button = self.createNewButton, let sdkObject = self.mySDKTester?.sdkInstance {
                button.isHidden = !sdkObject.isManager
            }
            if let button = self.fetchAllLoginsButton, let sdkObject = self.mySDKTester?.sdkInstance {
                button.isHidden = !sdkObject.isManager
            }

            self.activityScreen?.isHidden = true
            self.loginMainAdminButton?.isHidden = false
            self.displayResultsButton?.isHidden = self.objectList.isEmpty
        }
    }
    
    /* ################################################################## */
    /**
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SelectNewUserLoginViewController, let sdkInstance = sender as? RVP_Cocoa_SDK {
            destination.sdkInstance = sdkInstance
        }
        
        super.prepare(for: segue, sender: sender)
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func fetchAllLoginsButtonHit(_ sender: UIButton) {
        self.clearResults()
        if let sdkInstance = self.mySDKTester?.sdkInstance {
            self.activityScreen?.isHidden = false
            sdkInstance.fetchLogins([2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25])
        }
    }

    /* ################################################################## */
    /**
     */
    @IBAction func createNewLoginButtonPressed(_ sender: UIButton) {
        let newLogin = RVP_Cocoa_SDK_Login(sdkInstance: self.mySDKTester?.sdkInstance, objectInfoData: [:])
        self.callCreateNewEditor(newLogin)
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func createNewUserButtonPressed(_ sender: UIButton) {
        let newUser = RVP_Cocoa_SDK_User(sdkInstance: self.mySDKTester?.sdkInstance, objectInfoData: [:])
        self.callCreateNewEditor(newUser)
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction override func createNewButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "select-login-id", sender: self.mySDKTester?.sdkInstance)
    }
}
