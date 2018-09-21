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
// MARK: - Main Class -
/* ###################################################################################################################################### */
/**
 */
class Test001SimpleLogin: UIViewController, RVP_IOS_SDK_Delegate, UIPickerViewDataSource, UIPickerViewDelegate {
    private let _logins: [String] = ["admin", "MDAdmin", "VAAdmin", "DCAdmin", "WVAdmin", "DEAdmin", "MainAdmin", "Dilbert", "Wally", "Ted", "Alice", "Tina", "PHB", "MeLeet"]
    
    var mySDKTester: WhiteDragonSDKTester?
    @IBOutlet weak var loginButton: LucyButton!
    @IBOutlet weak var activityScreen: UIView!
    @IBOutlet weak var selectionDisplayView: UIView!
    @IBOutlet weak var loginPickerView: UIPickerView!
    @IBOutlet weak var displayResultsScrollView: RVP_DisplayResultsScrollView!
    
    /* ################################################################## */
    /**
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mySDKTester =  WhiteDragonSDKTester(dbPrefix: "sdk_1", delegate: self, session: TestHarnessAppDelegate.testHarnessDelegate.connectionSession)
    }
    
    /* ################################################################## */
    /**
     */
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.clearResults()
    }
    
    /* ################################################################## */
    /**
     */
    override func viewWillDisappear(_ animated: Bool) {
        if let tester = self.mySDKTester {
            if tester.isLoggedIn {
                tester.logout()
            }
        }
    }

    /* ################################################################## */
    /**
     */
    @IBAction func lucyButtonHit(_ sender: LucyButton) {
        if let tester = self.mySDKTester {
            self.clearResults()
            self.activityScreen.isHidden = false
            if tester.isLoggedIn {
                tester.logout()
            } else {
                let row = self.loginPickerView.selectedRow(inComponent: 0)
                tester.login(loginID: self._logins[row], password: "CoreysGoryStory")
            }
        }
    }
    
    /* ################################################################## */
    /**
     */
    func logout() {
        if let sdkTester = self.mySDKTester, let sdkInstance = sdkTester.sdkInstance {
            self.clearResults()
            sdkInstance.logout()
        }
    }
    
    /* ################################################################## */
    /**
     */
    func clearResults() {
        self.displayResultsScrollView.subviews.forEach({ $0.removeFromSuperview() })
        self.displayResultsScrollView.contentView = nil
        self.displayResultsScrollView.results = []
    }

    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, sessionConnectionIsValid inConnectionIsValid: Bool) {
        #if DEBUG
        print("Connection is" + (inConnectionIsValid ? "" : " not") + " valid!")
        #endif
    }

    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, loginValid inLoginValid: Bool) {
        #if DEBUG
        if inLoginValid {
            if let loginID = inSDKInstance.myLoginInfo?.loginID {
                print("Instance is logged in as " + loginID + "!")
                
                DispatchQueue.main.async {
                    if let loginInfo = inSDKInstance.myLoginInfo {
                        self.displayResultsScrollView.results.append(loginInfo)
                    }
                    if let userInfo = inSDKInstance.myUserInfo {
                        self.displayResultsScrollView.results.append(userInfo)
                    }
                    self.displayResultsScrollView.setNeedsLayout()
                }
            } else {
                print("ERROR!")
            }
        } else {
            print("Instance is logged out!")
        }
        #endif
        DispatchQueue.main.async {
            self.activityScreen.isHidden = true
            self.displayResultsScrollView.isHidden = !inLoginValid
            self.loginPickerView.isHidden = inLoginValid
            self.loginButton.theDoctorIsIn = inLoginValid
        }
    }
    
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, sessionDisconnectedBecause inReason: RVP_IOS_SDK.DisconnectionReason) {
        #if DEBUG
        print("Instance disconnected because \(inReason)!")
        #endif
        DispatchQueue.main.async {
            self.activityScreen.isHidden = true
        }
    }
    
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, sessionError inError: Error) {
        #if DEBUG
        print("Instance Error: \(inError)!")
        #endif
        DispatchQueue.main.async {
            self.activityScreen.isHidden = true
        }
    }
    
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, fetchedDataItems: [A_RVP_IOS_SDK_Object]) {
        #if DEBUG
        print("Fetched \(fetchedDataItems.count) Items!")
        #endif
    }
    
    /* ################################################################## */
    /**
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /* ################################################################## */
    /**
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self._logins.count
    }
    
    /* ################################################################## */
    /**
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self._logins[row]
    }
}
