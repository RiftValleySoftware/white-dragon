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

class RVP_DisplayDocumentViewController: UIViewController, UIDocumentInteractionControllerDelegate {
    var documentDisplayController: UIDocumentInteractionController?

    /* ################################################################## */
    /**
     */
    @IBAction func doneButtonHit(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /* ################################################################## */
    /**
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.documentDisplayController?.presentPreview(animated: true)
    }
    
    /* ################################################################## */
    /**
     */
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    /* ################################################################## */
    /**
     */
    func setDocumentFromData(_ inData: Data) {
        do {
            // We create a path to a unique temporary file to grab the media.
            let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
            // Store the media in the temp file.
            try inData.write(to: url, options: .atomic)
            self.documentDisplayController = UIDocumentInteractionController(url: url)
            self.documentDisplayController?.delegate = self
        } catch let error {
            #if DEBUG
            print("Error Encoding AV Media!: \(error)!")
            #endif
            NSLog("Error Encoding AV Media: %@", error._domain)
        }
    }
}
