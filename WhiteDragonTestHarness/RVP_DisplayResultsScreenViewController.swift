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
    var sdkInstance: RVP_IOS_SDK!

    /* ################################################################## */
    /**
     */
    @objc func fetchLoginForUser(_ inButton: RVP_LoginButton) {
        inButton.sdkInstance.fetchLogins([inButton.loginID])
    }
    
    /* ################################################################## */
    /**
     */
    @objc func fetchUserForLogin(_ inButton: RVP_LoginButton) {
        inButton.sdkInstance.fetchUsers([inButton.loginID])
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func getMapForLocation(_ sender: RVP_LocationButton) {
        if let urlName = sender.locationName.urlEncodedString {
            let dstLL = String(format: "ll=%f,%f&q=%@", sender.location.latitude, sender.location.longitude, urlName)
            let baselineURI = "?" + dstLL
            let uri = "https://maps.apple.com/" + baselineURI
            if let openLink = URL(string: uri) {
                UIApplication.shared.open(openLink, options: [:], completionHandler: nil)
            }
        }
    }

    /* ################################################################## */
    /**
     */
    @IBAction func doneButtonHit(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /* ################################################################## */
    /**
     */
    override func viewWillAppear(_ animated: Bool) {
        self.resultsScrollView.results = self.resultsArray
        self.resultsScrollView.sdkInstance = self.sdkInstance
        
        super.viewWillAppear(animated)
    }
    
    /* ################################################################## */
    /**
     */
    func addNewItems(_ fetchedDataItems: [A_RVP_IOS_SDK_Object]) {
        var toBeAdded: [A_RVP_IOS_SDK_Object] = []
        
        for item in fetchedDataItems {
            if !self.resultsArray.contains { [item] element in
                return element.id == item.id && type(of: element) == type(of: item)
                } {
                toBeAdded.append(item)
            }
        }

        if !toBeAdded.isEmpty {
            self.resultsArray.append(contentsOf: toBeAdded)
        }
        
        self.resultsScrollView.results = self.resultsArray.sorted {
            var ret = $0.id < $1.id
            
            if !ret {   // Security objects get listed before data objects
                ret = $0 is A_RVP_IOS_SDK_Security_Object && $1 is A_RVP_IOS_SDK_Data_Object
            }
            
            return ret
        }
    }
}
