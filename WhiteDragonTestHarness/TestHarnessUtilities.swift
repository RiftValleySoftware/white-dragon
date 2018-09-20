/***************************************************************************************************************************/
/**
 © Copyright 2018, Little Green Viper Software Development LLC.
 
 MIT License
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
 modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 Little Green Viper Software Development: https://littlegreenviper.com
 */

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
