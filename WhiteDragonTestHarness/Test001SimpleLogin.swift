//
//  ViewController.swift
//  WhiteDragonTestHarness
//
//  Created by Chris Marshall on 9/7/18.
//  Copyright © 2018 Little Green Viper Software Development LLC. All rights reserved.
//

import UIKit
import MapKit

/* ###################################################################################################################################### */
// MARK: - Main Class -
/* ###################################################################################################################################### */
/**
 */
class Test001SimpleLogin: UIViewController, WhiteDragonSDKTester_Delegate, UIPickerViewDataSource, UIPickerViewDelegate {
    private let _logins: [String] = ["admin", "MDAdmin", "VAAdmin", "DCAdmin", "WVAdmin", "DEAdmin", "MainAdmin", "Dilbert", "Wally", "Ted", "Alice", "Tina", "PHB", "MeLeet"]
    
    var mySDKTester: WhiteDragonSDKTester?
    @IBOutlet weak var loginButton: LucyButton!
    @IBOutlet weak var activityScreen: UIView!
    @IBOutlet weak var selectionDisplayView: UIView!
    @IBOutlet weak var resultsTextView: UITextView!
    @IBOutlet weak var loginPickerView: UIPickerView!
    
    /* ################################################################## */
    /**
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        let tester = WhiteDragonSDKTester(dbPrefix: "sdk_1")
        tester.delegate = self
    }
    
    /* ################################################################## */
    /**
     */
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
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
            self.activityScreen.isHidden = false
            if tester.isLoggedIn {
                tester.logout()
            } else {
                let row = self.loginPickerView.selectedRow(inComponent: 0)
                self.resultsTextView.text = ""
                tester.login(loginID: self._logins[row], password: "CoreysGoryStory")
            }
        }
    }
    
    /* ################################################################## */
    /**
     */
    func logout() {
        if let sdkTester = self.mySDKTester, let sdkInstance = sdkTester.sdkInstance {
            sdkInstance.logout()
        }
    }
    
    /* ################################################################## */
    /**
     */
    func populateTextView() {
        if let sdkTester = self.mySDKTester, let sdkInstance = sdkTester.sdkInstance, sdkInstance.isLoggedIn {
            let row = self.loginPickerView.selectedRow(inComponent: 0)
            self.resultsTextView.text = "Row: " + String(row) + "\n"
            
            if let loginInfo = sdkTester.sdkInstance?.myLoginInfo {
                self.resultsTextView.text += "\nLOGIN INFO:\n"
                
                for tup in loginInfo.asDictionary {
                    if let value = tup.value {
                        self.resultsTextView.text += "\t" + tup.key + ": " + String(describing: value) + "\n"
                    }
                }
            }
            
            if let userInfo = sdkTester.sdkInstance?.myUserInfo {
                self.resultsTextView.text += "\nUSER INFO:\n"
                
                for tup in userInfo.asDictionary {
                    if let value = tup.value {
                        if "location" == tup.key {
                            if let val = value as? CLLocationCoordinate2D {
                                self.resultsTextView.text += "\t" + tup.key + ": " + "(" + String(val.latitude) + "," + String(val.longitude) + ")\n"
                            }
                        } else {
                            self.resultsTextView.text += "\t" + tup.key + ": " + String(describing: value) + "\n"
                        }
                    }
                }
            }
        } else {
            self.resultsTextView.text = ""
        }
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
            } else {
                print("ERROR!")
            }
        } else {
            print("Instance is logged out!")
        }
        #endif
        DispatchQueue.main.async {
            self.populateTextView()
            self.activityScreen.isHidden = true
            self.loginPickerView.isHidden = inLoginValid
            self.resultsTextView.isHidden = !inLoginValid
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
    func databasesLoadedAndCaseysOnFirst(_ inTesterObject: WhiteDragonSDKTester) {
        #if DEBUG
        print("Databases Loaded!")
        #endif
        self.mySDKTester = inTesterObject
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
