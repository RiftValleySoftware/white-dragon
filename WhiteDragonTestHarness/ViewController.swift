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

    override func viewDidLoad() {
        super.viewDidLoad()
        let sdkTester = WhiteDragonSDKTester(dbPrefix: "sdk1", loginID: "MainAdmin", password: "CoreysGoryStory")
    }
    
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, loginValid inLoginValid: Bool) {
        #if DEBUG
        print("Login is" + (inLoginValid ? "" : " not") + " valid!")
        #endif
    }
    
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, sessionDisconnectedBecause inReason: RVP_IOS_SDK.Disconnection_Reason) {
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
