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
@IBDesignable
class RVP_EditElementViewController: UITableViewController {
    var editableObject: A_RVP_Cocoa_SDK_Object!
    var sdkInstance: RVP_Cocoa_SDK!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func saveButtonHit(_ sender: UIBarButtonItem) {
        if let name = self.nameTextField?.text, name != self.editableObject.name {
            self.editableObject.name = name
            self.editableObject.sendToServer()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonHit(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        if !(self.editableObject?.isWriteable ?? false) {
            self.navigationController?.popViewController(animated: true)
        }
        self.nameTextField.text = self.editableObject.name
        super.viewDidLoad()
    }
}
