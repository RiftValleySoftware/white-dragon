//
//  ViewController.swift
//  WhiteDragonTestHarness
//
//  Created by Chris Marshall on 9/7/18.
//  Copyright © 2018 Little Green Viper Software Development LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = WhiteDragonSDKTester(loginID: "admin", password: "CoreysGoryStory")
    }
}

