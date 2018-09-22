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
    var resultsArray: [A_RVP_IOS_SDK_Object] = []
    
    @IBAction func doneButtonHit(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.resultsScrollView.results = self.resultsArray
        super.viewWillAppear(animated)
    }
}
