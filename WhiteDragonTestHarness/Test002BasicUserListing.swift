//
//  Test002BasicUserListing.swift
//  WhiteDragonTestHarness
//
//  Created by Chris Marshall on 9/18/18.
//  Copyright © 2018 Little Green Viper Software Development LLC. All rights reserved.
//

import UIKit
import MapKit

class Test002BasicUserListing: UIViewController, RVP_IOS_SDK_Delegate, UIPickerViewDataSource, UIPickerViewDelegate {
    private let _presets: [(name: String, values: [Int])] = [(name: "MDAdmin", values: [1725]),
                                                             (name: "CEO", values: [1751]),
                                                             (name: "DC Area Admins", values: [1725, 1726, 1727, 1728, 1729, 1730]),
                                                             (name: "Restricted Admins", values: [1730, 1731]),
                                                             (name: "DilbertCo", values: [1745, 1746, 1747, 1748, 1749, 1750, 1751, 1752, 1753, 1754])
                                                            ]
    private let _buttonStrings = ["LOGIN", "LOGOUT"]
    private var _userList: [RVP_IOS_SDK_User] = []
    
    var mySDKTester: WhiteDragonSDKTester?
    @IBOutlet weak var activityScreen: UIView!
    @IBOutlet weak var fetchDataButton: UIButton!
    @IBOutlet weak var userListPicker: UIPickerView!
    @IBOutlet weak var specificationItemsView: UIView!
    @IBOutlet weak var resultsTextView: UITextView!
    @IBOutlet weak var loginMainAdminButton: UIButton!
    
    /* ################################################################## */
    /**
     */
    @IBAction func loginMainAdminButtonPressed(_ sender: UIButton) {
        if let tester = self.mySDKTester {
            if let sdkInstance = tester.sdkInstance {
                self.resultsTextView.text = ""
                self.activityScreen?.isHidden = false
                if sdkInstance.isLoggedIn {
                    tester.logout()
                } else {
                    tester.login(loginID: "admin", password: "CoreysGoryStory")
                }
            }
        }
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func fetchDataButtonPressed(_ sender: UIButton) {
        self.getUsers()
    }
    
    /* ################################################################## */
    /**
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mySDKTester = WhiteDragonSDKTester(dbPrefix: "sdk_1", delegate: self, session: TestHarnessAppDelegate.testHarnessDelegate.connectionSession)
        self.loginMainAdminButton.setTitle(self._buttonStrings[0], for: .normal)
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
    func getUsers() {
        self._userList = []
        self.resultsTextView.text = ""
        if let sdkInstance = self.mySDKTester?.sdkInstance {
            let row = self.userListPicker.selectedRow(inComponent: 0)
            let userIDList = self._presets[row].values
            self.activityScreen?.isHidden = false
            sdkInstance.fetchUsers(userIDList)
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
            self.loginMainAdminButton.setTitle(inLoginValid ? self._buttonStrings[1] : self._buttonStrings[0], for: .normal)
            self.activityScreen?.isHidden = true
            self.loginMainAdminButton?.isHidden = false
            self.specificationItemsView?.isHidden = false
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
        }
    }
    
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, fetchedDataItems: [A_RVP_IOS_SDK_Object]) {
        #if DEBUG
        print("Fetched \(fetchedDataItems.count) Items!")
        #endif
        
        if let dataItems = fetchedDataItems as? [RVP_IOS_SDK_User] {
            self._userList.append(contentsOf: dataItems)
        }
        
        DispatchQueue.main.async {
            self.activityScreen?.isHidden = true
            utilPopulateTextView(self.resultsTextView, objectArray: self._userList)
        }
    }
    
    /* ################################################################## */
    /**
     */
    func databasesLoadedAndCaseysOnFirst(_ inTesterObject: WhiteDragonSDKTester) {
        #if DEBUG
        print("Databases Loaded!")
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
        return self._presets.count
    }
    
    /* ################################################################## */
    /**
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self._presets[row].name
    }
}