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
class RVP_EditElementViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    struct GeneratedValuesAndLabels {
        var label: String = ""
        var dataKey: String = ""
        var stringValue: String?
        
        init(label inLabel: String, dataKey inDataKey: String, stringValue inStringValue: String?) {
            self.label = inLabel
            self.dataKey = inDataKey
            self.stringValue = inStringValue
        }
    }
    
    var editableObject: A_RVP_Cocoa_SDK_Object!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var readTokenPickerView: UIPickerView!
    @IBOutlet weak var writeTokenPickerView: UIPickerView!
    @IBOutlet weak var languageTextField: UITextField!
    
    var sdkInstance: RVP_Cocoa_SDK! {
        return self.editableObject.sdkInstance
    }

    var keyList: [String] {
        var ret: [String] = ["name", "lang", "read_token", "write_token"]
        
        if self.editableObject is RVP_Cocoa_SDK_Login {
            ret.append("login_id")
        } else if self.editableObject is RVP_Cocoa_SDK_User {
            ret.append("surname")
            ret.append("middle_name")
            ret.append("given_name")
            ret.append("nickname")
            ret.append("prefix")
            ret.append("suffix")
            ret.append("tag7")
            ret.append("tag8")
            ret.append("tag9")
        } else if self.editableObject is RVP_Cocoa_SDK_Place {
            ret.append("venue")
            ret.append("street_address")
            ret.append("extra_information")
            ret.append("town")
            ret.append("county")
            ret.append("state")
            ret.append("postal_code")
            ret.append("nation")
            ret.append("tag8")
            ret.append("tag9")
        } else if self.editableObject is RVP_Cocoa_SDK_Thing {
            ret.append("description")
            ret.append("tag2")
            ret.append("tag3")
            ret.append("tag4")
            ret.append("tag5")
            ret.append("tag6")
            ret.append("tag7")
            ret.append("tag8")
            ret.append("tag9")
        }
        
        return ret
    }
    
    var generatedValuesAndLabels: [GeneratedValuesAndLabels] {
        var ret: [GeneratedValuesAndLabels] = []
        if let currentData = self.editableObject?.myData {
            for oneValue in self.keyList {
                var label = ""
                let currentVal = currentData[oneValue] as? String ?? ""
                
                switch oneValue {
                case "login_id":
                    label = "Login ID:"
                case "tag0":
                    label = "Tag 0:"
                case "tag1":
                    label = "Tag 1:"
                case "tag2":
                    label = "Tag 2:"
                case "tag3":
                    label = "Tag 3:"
                case "tag4":
                    label = "Tag 4:"
                case "tag5":
                    label = "Tag 5:"
                case "tag6":
                    label = "Tag 6:"
                case "tag7":
                    label = "Tag 7:"
                case "tag8":
                    label = "Tag 8:"
                case "tag9":
                    label = "Tag 9:"
                case "surname":
                    label = "Surname:"
                case "middle_name":
                    label = "Middle Name:"
                case "given_name":
                    label = "First Name:"
                case "nickname":
                    label = "Nickname:"
                case "prefix":
                    label = "Prefix:"
                case "suffix":
                    label = "Suffix:"
                case "venue":
                    label = "Venue Name:"
                case "street_address":
                    label = "Street Address:"
                case "extra_information":
                    label = "Extra Information:"
                case "town":
                    label = "Town:"
                case "county":
                    label = "County:"
                case "state":
                    label = "State:"
                case "postal_code":
                    label = "Zip Code:"
                case "nation":
                    label = "Nation:"
                case "description":
                    label = "Description:"
                default:
                    break
                }
                
                if !label.isEmpty {
                    ret.append(GeneratedValuesAndLabels(label: label, dataKey: oneValue, stringValue: currentVal))
                }
            }
        }
        
        return ret
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return self.generatedValuesAndLabels.count
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return super.tableView(tableView, indentationLevelForRowAt: IndexPath(row: 0, section: 0))
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 44
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let ret = UITableViewCell()
            ret.backgroundColor = UIColor.clear
            let testLabel = UILabel()
            testLabel.backgroundColor = UIColor.clear
            testLabel.textColor = UIColor.white
            testLabel.font = UIFont.systemFont(ofSize: 17)
            testLabel.textAlignment = .left
            testLabel.text = self.generatedValuesAndLabels[indexPath.row].label
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
                                   attribute: .leftMargin,
                                   multiplier: 1.0,
                                   constant: 0),
                NSLayoutConstraint(item: testLabel,
                                   attribute: .height,
                                   relatedBy: .equal,
                                   toItem: nil,
                                   attribute: .notAnAttribute,
                                   multiplier: 1.0,
                                   constant: 21),
                NSLayoutConstraint(item: testLabel,
                                   attribute: .right,
                                   relatedBy: .equal,
                                   toItem: ret,
                                   attribute: .right,
                                   multiplier: 1.0,
                                   constant: 0)
                ])
            
            let testTextItem = UITextField()
            
            ret.addSubview(testTextItem)
            testTextItem.translatesAutoresizingMaskIntoConstraints = false
            if let value = self.editableObject?.myData[self.generatedValuesAndLabels[indexPath.row].dataKey] as? String {
                testTextItem.text = value
            }
            ret.addConstraints([
                NSLayoutConstraint(item: testTextItem,
                                   attribute: .bottom,
                                   relatedBy: .equal,
                                   toItem: ret,
                                   attribute: .bottom,
                                   multiplier: 1.0,
                                   constant: 0),
                NSLayoutConstraint(item: testTextItem,
                                   attribute: .top,
                                   relatedBy: .equal,
                                   toItem: testLabel,
                                   attribute: .bottom,
                                   multiplier: 1.0,
                                   constant: 0),
                NSLayoutConstraint(item: testTextItem,
                                   attribute: .left,
                                   relatedBy: .equal,
                                   toItem: ret,
                                   attribute: .left,
                                   multiplier: 1.0,
                                   constant: 0),
                NSLayoutConstraint(item: testTextItem,
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
    
    func syncObject() {
        if let name = self.nameTextField?.text, nil != self.editableObject?.name || name.isEmpty {
            if !name.isEmpty || ((nil != self.editableObject?.name) && (name != self.editableObject?.name)) {
                self.editableObject.name = name
            }
        }
        
        if let lang = self.languageTextField?.text, nil != self.editableObject?.lang || lang.isEmpty {
            if !lang.isEmpty || ((nil != self.editableObject?.lang) && (lang != self.editableObject?.lang)) {
                self.editableObject.lang = lang
            }
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
