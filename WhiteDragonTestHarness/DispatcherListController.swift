//
//  DispatcherListController.swift
//  WhiteDragonTestHarness
//
//  Created by Chris Marshall on 9/17/18.
//  Copyright © 2018 Little Green Viper Software Development LLC. All rights reserved.
//

import UIKit

class DispatcherListController: UIViewController {
    /* ################################################################## */
    /**
     */
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
}
