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
import WhiteDragon

/* ###################################################################################################################################### */
// MARK: - Main Class -
/* ###################################################################################################################################### */
/**
 */
protocol RVP_DisplayResultsHasSDK: UIDocumentInteractionControllerDelegate {
    var sdkInstance: RVP_Cocoa_SDK! {get set}
    var documentDisplayController: UIDocumentInteractionController? {get set}
    func setEPUBDocumentFromData(_ inData: Data)
}

/* ###################################################################################################################################### */
// MARK: - Main Class -
/* ###################################################################################################################################### */
/**
 */
class RVP_DisplayResultsBaseScreenViewController: UIViewController, RVP_DisplayResultsHasSDK, UIDocumentInteractionControllerDelegate {
    var sdkInstance: RVP_Cocoa_SDK!
    var documentDisplayController: UIDocumentInteractionController?
    @IBOutlet weak var activityView: UIView!

    /* ################################################################## */
    /**
     */
    @IBAction func displayEPUBButtonHit(_ sender: UIButton) {
        self.start()
        if !(self.documentDisplayController?.presentPreview(animated: true))! {
            UIApplication.displayAlert("Unable to Display EPUB Document", inMessage: "You need to have iBooks installed.", presentedBy: self)
            self.done()
        }
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func displayGenericButtonHit(_ sender: UIButton) {
        self.start()
        if !(self.documentDisplayController?.presentPreview(animated: true))! {
            UIApplication.displayAlert("Unable to Display the Document", inMessage: "", presentedBy: self)
            self.done()
        }
    }
    
    /* ################################################################## */
    /**
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.done()
    }

    /* ################################################################## */
    /**
     */
    func start() {
        self.activityView.isHidden = false
    }
    
    /* ################################################################## */
    /**
     */
    func done() {
        DispatchQueue.main.async {
            self.activityView.isHidden = true
        }
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
