//
//  RVP_DisplayResultsScreenViewController.swift
//  WhiteDragonTestHarness
//
//  Created by Chris Marshall on 9/22/18.
//  Copyright © 2018 Little Green Viper Software Development LLC. All rights reserved.
//

import UIKit

class RVP_DisplayResultsScreenViewController: UIViewController {
    @IBOutlet weak var resultsScrollView: RVP_DisplayResultsScrollView!
    var resultsArray: [A_RVP_IOS_SDK_Object] {
        get {
            var ret: [A_RVP_IOS_SDK_Object] = []
            
            if let resultsView = self.resultsScrollView, !resultsView.results.isEmpty {
                ret = resultsView.results
            }
            
            return ret
        }
        
        set {
            if let resultsView = self.resultsScrollView {
                resultsView.results = newValue
            }
        }
    }
}
