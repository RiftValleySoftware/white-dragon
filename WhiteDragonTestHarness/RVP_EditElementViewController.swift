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
// MARK: - Dynamic Cell Class -
/* ###################################################################################################################################### */
/**
 */
class RVP_EditElementViewTableViewCell: UITableViewCell {
    
}

/* ###################################################################################################################################### */
// MARK: - Main Class -
/* ###################################################################################################################################### */
/**
 */
@IBDesignable
class RVP_EditElementViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var editableObject: A_RVP_Cocoa_SDK_Object!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var readTokenPickerView: UIPickerView!
    @IBOutlet weak var writeTokenPickerView: UIPickerView!

    var sdkInstance: RVP_Cocoa_SDK! {
        return self.editableObject.sdkInstance
    }

    @IBAction func determineSaveStatus(_ sender: AnyObject? = nil) {
        self.syncObject()
        self.saveButton.isEnabled = self.editableObject.isDirty
    }
    
    @IBAction func saveButtonHit(_ sender: UIBarButtonItem) {
        self.syncObject()
        if self.editableObject.isDirty {
            self.editableObject.sendToServer()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonHit(_ sender: Any) {
        if self.editableObject.isDirty {
            let alertController = UIAlertController(title: "Changes Have Been Made", message: "Do you want to lose the changes?", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: NSLocalizedString("NO, DON'T CANCEL", comment: ""), style: UIAlertAction.Style.default, handler: nil)
            
            alertController.addAction(okAction)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("LOSE THE CHANGES", comment: ""), style: UIAlertAction.Style.destructive) { [unowned self] (_ inAlertAction: UIAlertAction) -> Void in
                self.editableObject.revert()
                self.navigationController?.popViewController(animated: true)
            }
            
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        self.tableView.register(UINib(nibName: "EditTableCell", bundle: nil), forCellReuseIdentifier: "EditTableCell")
        
        if !(self.editableObject?.isWriteable ?? false) {
            self.navigationController?.popViewController(animated: true)
        }
        self.nameTextField.text = self.editableObject.name
        if var tokenList = self.sdkInstance?.securityTokens {
            if let tokenValue = self.editableObject.writeToken, let selectedRow = tokenList.firstIndex(of: tokenValue) {
                self.writeTokenPickerView.selectRow(selectedRow, inComponent: 0, animated: true)
            }
            tokenList.insert(0, at: 0)
            if let tokenValue = self.editableObject.readToken, let selectedRow = tokenList.firstIndex(of: tokenValue) {
                self.readTokenPickerView.selectRow(selectedRow, inComponent: 0, animated: true)
            }
        }
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let ret = UITableViewCell()
            ret.backgroundColor = UIColor.clear
            let testLabel = UILabel()
            testLabel.backgroundColor = UIColor.clear
            testLabel.textColor = UIColor.white
            testLabel.font = UIFont.boldSystemFont(ofSize: 20)
            testLabel.textAlignment = .center
            testLabel.text = "TEST"
            ret.addSubview(testLabel)
            testLabel.translatesAutoresizingMaskIntoConstraints = false

            ret.addConstraints([
                NSLayoutConstraint(item: testLabel,
                                   attribute: .top,
                                   relatedBy: .equal,
                                   toItem: ret,
                                   attribute: .top,
                                   multiplier: 1.0,
                                   constant: 0),
                NSLayoutConstraint(item: testLabel,
                                   attribute: .left,
                                   relatedBy: .equal,
                                   toItem: ret,
                                   attribute: .left,
                                   multiplier: 1.0,
                                   constant: 0),
                NSLayoutConstraint(item: testLabel,
                                   attribute: .bottom,
                                   relatedBy: .equal,
                                   toItem: ret,
                                   attribute: .bottom,
                                   multiplier: 1.0,
                                   constant: 0),
                NSLayoutConstraint(item: testLabel,
                                   attribute: .right,
                                   relatedBy: .equal,
                                   toItem: ret,
                                   attribute: .right,
                                   multiplier: 1.0,
                                   constant: 0)
                ])
            return ret
        }
        
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 44
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func syncObject() {
        if let name = self.nameTextField?.text, name != self.editableObject.name {
            self.editableObject.name = name
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.readTokenPickerView == pickerView {
            if let tokenList = self.sdkInstance?.securityTokens {
                return tokenList.count + 1
            }
        } else if self.writeTokenPickerView == pickerView {
            if let tokenList = self.sdkInstance?.securityTokens {
                return tokenList.count
            }
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.readTokenPickerView == pickerView {
            if var tokenList = self.sdkInstance?.securityTokens {
                tokenList.insert(0, at: 0)
                return String(tokenList[row])
            }
        } else if self.writeTokenPickerView == pickerView {
            if var tokenList = self.sdkInstance?.securityTokens {
                return String(tokenList[row])
            }
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.readTokenPickerView == pickerView {
            if var tokenList = self.sdkInstance?.securityTokens {
                tokenList.insert(0, at: 0)
                self.editableObject.readToken = tokenList[row]
            }
        } else if self.writeTokenPickerView == pickerView {
            if var tokenList = self.sdkInstance?.securityTokens {
                self.editableObject.writeToken = tokenList[row]
            }
        }
        self.syncObject()
        self.determineSaveStatus()
    }
}
