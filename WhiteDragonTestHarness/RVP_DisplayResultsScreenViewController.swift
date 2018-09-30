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

/* ###################################################################################################################################### */
// MARK: - Main Class -
/* ###################################################################################################################################### */
/**
 */
class RVP_DisplayResultsScreenViewController: UIViewController {
    private let _presentGenericPayloadSegueID: String = "show-generic-document"
    
    @IBOutlet weak var resultsScrollView: RVP_DisplayResultsScrollView!
    var resultsArray: [A_RVP_Cocoa_SDK_Object] = []
    var sdkInstance: RVP_Cocoa_SDK!
    
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
    @objc func showGenericPayload(_ inButton: RVP_PayloadButton) {
        self.performSegue(withIdentifier: self._presentGenericPayloadSegueID, sender: inButton.payload)
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
        if let scroller = self.resultsScrollView {
            scroller.nukem()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    /* ################################################################## */
    /**
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RVP_DisplayDocumentViewController {
            if let node = sender as? Data {
                destination.setDocumentFromData(node)
            }
        }
        
        super.prepare(for: segue, sender: nil)
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
    func addNewItems(_ fetchedDataItems: [A_RVP_Cocoa_SDK_Object]) {
        var toBeAdded: [A_RVP_Cocoa_SDK_Object] = []
        
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
                ret = $0 is A_RVP_Cocoa_SDK_Security_Object && $1 is A_RVP_Cocoa_SDK_Data_Object
            }
            
            return ret
        }
    }
}
