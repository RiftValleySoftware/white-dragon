//
//  ViewController.swift
//  WhiteDragonTestHarness
//
//  Created by Chris Marshall on 9/7/18.
//  Copyright © 2018 Little Green Viper Software Development LLC. All rights reserved.
//

import UIKit
import WhiteDragon

class ViewController: UIViewController, RVP_IOS_SDK_Delegate {
    var mySDKTester: WhiteDragonSDKTester?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mySDKTester = WhiteDragonSDKTester(dbPrefix: "sdk1", loginID: "MainAdmin", password: "CoreysGoryStory")
        self.mySDKTester!.delegate = self
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
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, loginValid inLoginValid: Bool) {
        #if DEBUG
        print("Instance is" + (inLoginValid ? "" : " not") + " logged in!")
        #endif
        self.logout()
    }
    
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, sessionDisconnectedBecause inReason: RVP_IOS_SDK.DisconnectionReason) {
        #if DEBUG
        print("Instance disconnected because \(inReason)!")
        #endif
    }
    
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, sessionError inError: Error) {
        #if DEBUG
        print("Instance Error: \(inError)!")
        #endif
    }
}
