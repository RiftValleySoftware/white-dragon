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
import AVKit
import PDFKit
import WhiteDragon

/* ###################################################################################################################################### */
// MARK: - Main Class -
/* ###################################################################################################################################### */
/**
 */
@IBDesignable
class RVP_EditElementViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    /* ################################################################## */
    /**
     */
    struct GeneratedValuesAndLabels {
        var label: String = ""
        var dataKey: String = ""
        var stringValue: String?
        var textItem: UITextField!
        
        init(label inLabel: String, dataKey inDataKey: String, stringValue inStringValue: String?) {
            self.label = inLabel
            self.dataKey = inDataKey
            self.stringValue = inStringValue
            self.textItem = nil
        }
    }
    
    var generatedValuesAndLabels: [GeneratedValuesAndLabels] = []
    var editableObject: A_RVP_Cocoa_SDK_Object!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var readTokenPickerView: UIPickerView!
    @IBOutlet weak var writeTokenPickerView: UIPickerView!
    @IBOutlet weak var languageTextField: UITextField!
    
    /* ################################################################## */
    /**
     */
    var sdkInstance: RVP_Cocoa_SDK! {
        return self.editableObject.sdkInstance
    }

    /* ################################################################## */
    /**
     */
    var payloadHeight: CGFloat {
        var aspect: CGFloat = 0
        var buttonSpace: CGFloat = 0
        var ret: CGFloat = 0
        
        if let payloadedObject = self.editableObject as? A_RVP_Cocoa_SDK_Data_Object, let payload = payloadedObject.payload?.payloadResolved {
            if let payloadAsImage = payload as? UIImage {
                aspect = payloadAsImage.size.height / payloadAsImage.size.width
            } else if let payloadAsMedia = payload as? AVAsset {
                let videoTracks = payloadAsMedia.tracks(withMediaType: AVMediaType.video)
                if let track = videoTracks.first {
                    let size = track.naturalSize.applying(track.preferredTransform)
                    aspect = size.height / size.width
                }
                buttonSpace = 30
            } else if nil != payload as? Data {
                buttonSpace = 30
            }
        }
        
        if 0 < aspect {
            ret = aspect * self.view.bounds.size.width
        }
        
        ret += buttonSpace
        
        return ret
    }

    /* ################################################################## */
    /**
     */
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
    
    /* ################################################################## */
    /**
     */
    func generateValuesAndLabels() {
        let stringMap: [String: String] = [
        "login_id": "Login ID:",
        "tag0": "Tag 0:",
        "tag1": "Tag 1:",
        "tag2": "Tag 2:",
        "tag3": "Tag 3:",
        "tag4": "Tag 4:",
        "tag5": "Tag 5:",
        "tag6": "Tag 6:",
        "tag7": "Tag 7:",
        "tag8": "Tag 8:",
        "tag9": "Tag 9:",
        "surname": "Surname:",
        "middle_name": "Middle Name:",
        "given_name": "First Name:",
        "nickname": "Nickname:",
        "prefix": "Prefix:",
        "suffix": "Suffix:",
        "venue": "Venue Name:",
        "street_address": "Street Address:",
        "extra_information": "Extra Information:",
        "town": "Town:",
        "county": "County:",
        "state": "State:",
        "postal_code": "Zip Code:",
        "nation": "Nation:",
        "description": "Description:"
        ]
        
        if let currentData = self.editableObject?.myData {
            for oneValue in self.keyList {
                let currentVal = currentData[oneValue] as? String ?? ""
                if let label = stringMap[oneValue] {
                    if !label.isEmpty {
                        generatedValuesAndLabels.append(GeneratedValuesAndLabels(label: label, dataKey: oneValue, stringValue: currentVal))
                    }
                }
            }
        }
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func determineSaveStatus(_ sender: AnyObject? = nil) {
        self.syncObject()
        self.saveButton.isEnabled = self.editableObject.isDirty
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func saveButtonHit(_ sender: UIBarButtonItem) {
        self.syncObject()
        if self.editableObject.isDirty {
            self.editableObject.sendToServer()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    /* ################################################################## */
    /**
     */
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

    /* ################################################################## */
    /**
     */
    override func viewDidLoad() {
        if !(self.editableObject?.isWriteable ?? false) {
            self.navigationController?.popViewController(animated: true)
        }
        
        self.nameTextField.text = self.editableObject.name
        self.languageTextField.text = self.editableObject.lang

        if var tokenList = self.sdkInstance?.securityTokens {
            if let tokenValue = self.editableObject.writeToken, let selectedRow = tokenList.firstIndex(of: tokenValue) {
                self.writeTokenPickerView.selectRow(selectedRow, inComponent: 0, animated: true)
            }
            tokenList.insert(0, at: 0)
            if let tokenValue = self.editableObject.readToken, let selectedRow = tokenList.firstIndex(of: tokenValue) {
                self.readTokenPickerView.selectRow(selectedRow, inComponent: 0, animated: true)
            }
        }
        
        self.generateValuesAndLabels()
        
        super.viewDidLoad()
    }

    /* ################################################################## */
    /**
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if 1 == section {
            return self.generatedValuesAndLabels.count
        } else if 2 == section {
            return nil != self.editableObject?.myData["payload"] ? 1 : 0
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return super.tableView(tableView, indentationLevelForRowAt: IndexPath(row: 0, section: 0))
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if 1 == indexPath.section {
            return 44
        } else if 2 == indexPath.section {
            
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    /* ################################################################## */
    /**
     */
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
            
            testTextItem.text = self.generatedValuesAndLabels[indexPath.row].stringValue
            testTextItem.font = self.nameTextField.font
            testTextItem.textColor = self.nameTextField.textColor
            testTextItem.addTarget(self, action: #selector(type(of: self).determineSaveStatus(_:)), for: .editingDidEnd)
            testTextItem.addTarget(self, action: #selector(type(of: self).determineSaveStatus(_:)), for: .editingChanged)
            testTextItem.addTarget(self, action: #selector(type(of: self).determineSaveStatus(_:)), for: .editingDidEndOnExit)
            self.generatedValuesAndLabels[indexPath.row].textItem = testTextItem
            ret.addSubview(testTextItem)
            testTextItem.translatesAutoresizingMaskIntoConstraints = false
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
        } else if 2 == indexPath.section {
        }
        
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    /* ################################################################## */
    /**
     */
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
        
        for element in self.generatedValuesAndLabels {
            if let newValue = element.textItem.text {
                if let oldValue = self.editableObject.myData[element.dataKey] as? String {
                    if !oldValue.isEmpty || !newValue.isEmpty, oldValue != newValue {
                        self.editableObject.myData[element.dataKey] = newValue
                    }
                }
            }
        }
    }
    
    /* ################################################################## */
    /**
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /* ################################################################## */
    /**
     */
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
    
    /* ################################################################## */
    /**
     */
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
    
    /* ################################################################## */
    /**
     */
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
