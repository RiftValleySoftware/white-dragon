//
//  ViewController.swift
//  WhiteDragonTestHarness
//
//  Created by Chris Marshall on 9/7/18.
//  Copyright © 2018 Little Green Viper Software Development LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WhiteDragonSDKTester_Delegate {
    var mySDKTester: WhiteDragonSDKTester?
    @IBOutlet weak var loginButton: LucyButton!
    @IBOutlet weak var activityScreen: UIView!
    
    /* ################################################################## */
    /**
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        let tester = WhiteDragonSDKTester(dbPrefix: "sdk1", loginID: "MainAdmin", password: "CoreysGoryStory")
        tester.delegate = self
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
                tester.login()
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
        print("Instance is" + (inLoginValid ? "" : " not") + " logged in!")
        #endif
        DispatchQueue.main.async {
            self.activityScreen.isHidden = true
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
}
