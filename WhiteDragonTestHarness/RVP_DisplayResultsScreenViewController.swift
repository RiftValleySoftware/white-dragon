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
class RVP_DisplayResultsScreenViewController: UIViewController, UIDocumentInteractionControllerDelegate {
    @IBOutlet weak var resultsScrollView: RVP_DisplayResultsScrollView!
    var resultsArray: [A_RVP_Cocoa_SDK_Object] = []
    var sdkInstance: RVP_Cocoa_SDK!
    var documentDisplayController: UIDocumentInteractionController?

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
        if let scroller = self.resultsScrollView {
            scroller.nukem()
        }
        self.dismiss(animated: true, completion: nil)
    }

    /* ################################################################## */
    /**
     */
    @IBAction func displayEPUBButtonHit(_ sender: UIButton) {
        if !(self.documentDisplayController?.presentPreview(animated: true))! {
            print("Unable to Display EPUB")
        }
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
    func setEPUBDocumentFromData(_ inData: Data) {
        do {
            // We create a path to a unique temporary file to grab the media.
            let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString + ".epub")
            // Store the media in the temp file.
            try inData.write(to: url, options: .atomic)
            self.documentDisplayController = UIDocumentInteractionController(url: url)
            self.documentDisplayController?.delegate = self
            self.documentDisplayController?.name = "EPUB DOCUMENT"
        } catch let error {
            #if DEBUG
            print("Error Encoding AV Media!: \(error)!")
            #endif
            NSLog("Error Encoding AV Media: %@", error._domain)
        }
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
    
    /* ################################################################## */
    /**
     */
    func documentInteractionControllerRectForPreview(_ controller: UIDocumentInteractionController) -> CGRect {
        return self.view.bounds
    }
    
    /* ################################################################## */
    /**
     */
    func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIView? {
        return self.view
    }
    
    /* ################################################################## */
    /**
     */
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
