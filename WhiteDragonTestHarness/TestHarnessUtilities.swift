//
//  TestHarnessUtilities.swift
//  WhiteDragonTestHarness
//
//  Created by Chris Marshall on 9/19/18.
//  Copyright © 2018 Little Green Viper Software Development LLC. All rights reserved.
//

import UIKit
import MapKit

/* ###################################################################################################################################### */
/**
 This is used to get the app name from the bundle.
 */
extension Bundle {
    /* ################################################################## */
    /**
     - returns: the bundle app name.
     */
    var appName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}

/* ################################################################## */
/**
 */
func utilPopulateTextView(_ inTextView: UITextView, objectArray inObjectList: [A_RVP_IOS_SDK_Object]) {
    inTextView.text = ""
    
    for objectInfo in inObjectList {
        let name = objectInfo.name
        let id = objectInfo.id
        inTextView.text += "\(name) (\(id))"
        if objectInfo.isDirty {
            inTextView.text += "*"
        }
        inTextView.text += "\n"
        for tup in objectInfo.asDictionary {
            if let value = tup.value, "id" != tup.key, "name" != tup.key, "isDirty" != tup.key {
                if "location" == tup.key || "raw_location" == tup.key {
                    if let val = value as? CLLocationCoordinate2D {
                        inTextView.text += "\t" + tup.key + ": " + "(" + String(val.latitude) + "," + String(val.longitude) + ")\n"
                    }
                } else {
                    inTextView.text += "\t" + tup.key + ": " + String(describing: value) + "\n"
                }
            }
        }
        
        if objectInfo.isDirty {
            inTextView.text += "\n\t*WASH ME\n"
        }
    }
}
