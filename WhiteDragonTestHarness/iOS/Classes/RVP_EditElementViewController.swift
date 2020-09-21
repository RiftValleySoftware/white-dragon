/* ###################################################################################################################################### */
/**
    © Copyright 2018, The Great Rift Valley Software Company.
    
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
    
    The Great Rift Valley Software Company: https://riftvalleysoftware.com
*/

import UIKit
import AVKit
import PDFKit
import MapKit
import WhiteDragon

/* ###################################################################################################################################### */
// MARK: - Media Selector Class -
/* ###################################################################################################################################### */
/**
 */
class RVP_MediaChoiceViewController: UITableViewController {
    var controller: RVP_EditElementViewController!
    
    /* ################################################################## */
    /**
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fileList: [String] = ["",
            "IMAGE.jpg",
            "TEXT.txt",
            "PDF.pdf",
            "VIDEO.mp4",
            "EPUB.epub",
            "AUDIO.mp3"
        ]
        DispatchQueue.main.async {
            self.controller.setMediaChoice(fileList[indexPath.row])
            self.dismiss(animated: true, completion: nil)
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - Main Class -
/* ###################################################################################################################################### */
/**
 */
@IBDesignable
class RVP_EditElementViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, RVP_DisplayResultsHasSDK {
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
    var sdkInstance: RVP_Cocoa_SDK!
    var documentDisplayController: UIDocumentInteractionController?
    var cachedPayloadHeight: CGFloat = 0
    var payloadDisplayView: RVP_DisplayPayloadView!

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var readTokenPickerView: UIPickerView!
    @IBOutlet weak var writeTokenPickerView: UIPickerView!
    @IBOutlet weak var languageTextField: UITextField!
    @IBOutlet weak var locationButton: UIButton!

    /* ################################################################## */
    /**
     */
    var payloadHeight: CGFloat {
        var ret: CGFloat = self.cachedPayloadHeight
        if 0 == ret {
            var aspect: CGFloat = 0
            var buttonSpace: CGFloat = 0
            
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
                } else if payload is String {
                    aspect = 1.0
                } else if payload is Data {
                    buttonSpace = 30
                }
            }
            
            ret = (aspect * self.view.bounds.size.width) + buttonSpace
            
            self.cachedPayloadHeight = ret
        }
        
        return ret + 51
    }

    /* ################################################################## */
    /**
     */
    var keyList: [String] {
        var ret: [String] = ["name", "lang", "read_token", "write_token"]
        
        if self.editableObject is RVP_Cocoa_SDK_Login {
            ret.append("login_id")
            ret.append("password")
        } else if self.editableObject is RVP_Cocoa_SDK_User {
            ret.append("longitude")
            ret.append("latitude")
            ret.append("raw_longitude")
            ret.append("raw_latitude")
            ret.append("fuzz_factor")
            ret.append("associated_login_id")
            ret.append("surname")
            ret.append("middle_name")
            ret.append("given_name")
            ret.append("nickname")
            ret.append("prefix")
            ret.append("suffix")
            ret.append("tag7")
            ret.append("tag8")
            ret.append("tag9")
            ret.append("children")
        } else if self.editableObject is RVP_Cocoa_SDK_Place {
            ret.append("longitude")
            ret.append("latitude")
            ret.append("raw_longitude")
            ret.append("raw_latitude")
            ret.append("fuzz_factor")
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
            ret.append("children")
        } else if self.editableObject is RVP_Cocoa_SDK_Thing {
            ret.append("longitude")
            ret.append("latitude")
            ret.append("raw_longitude")
            ret.append("raw_latitude")
            ret.append("fuzz_factor")
            ret.append("description")
            ret.append("tag2")
            ret.append("tag3")
            ret.append("tag4")
            ret.append("tag5")
            ret.append("tag6")
            ret.append("tag7")
            ret.append("tag8")
            ret.append("tag9")
            ret.append("children")
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     */
    func setMediaChoice(_ inFileName: String) {
        if inFileName.isEmpty {
            self.editableObject?.myData.removeValue(forKey: "payload")
            self.editableObject?.myData.removeValue(forKey: "payload_type")
        } else {
            let nameType = inFileName.components(separatedBy: ".")
            if let mediaFileURL = Bundle.main.url(forResource: nameType[0], withExtension: nameType[1]) {
                do {
                    let dataItem = try Data(contentsOf: mediaFileURL)
                    let base64String = dataItem.base64EncodedString()
                    self.editableObject?.myData["payload"] = base64String
                    switch nameType[1] {
                    case "txt":
                        self.editableObject?.myData["payload_type"] = "text/plain;base64"
                    case "jpg":
                        self.editableObject?.myData["payload_type"] = "image/jpeg;base64"
                    case "pdf":
                        self.editableObject?.myData["payload_type"] = "application/pdf;base64"
                    case "epub":
                        self.editableObject?.myData["payload_type"] = "application/epub+zip;base64"
                    case "mp4":
                        self.editableObject?.myData["payload_type"] = "video/mp4;base64"
                    case "mp3":
                        self.editableObject?.myData["payload_type"] = "audio/mp3;base64"
                    default:
                        break
                    }
                } catch {
                    
                }
            }
        }
        
        let payloadIndexPath = IndexPath(row: 0, section: 2)
        self.determineSaveStatus()
        self.tableView.reloadRows(at: [payloadIndexPath], with: UITableView.RowAnimation.none)
    }
    
    /* ################################################################## */
    /**
     */
    func generateValuesAndLabels() {
        let stringMap: [String: String] = [
            "login_id": "Numerical Login ID:",
            "associated_login_id": "Numerical Login ID:",
            "new_login_id_string": "New String Login ID:",
            "password": "Password:",
            "latitude": "Latitude:",
            "longitude": "Longitude:",
            "fuzz_factor": "Fuzz Factor:",
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
            "description": "Description:",
            "children": "Children:"
        ]
        
        if var currentData = self.editableObject?.myData {
            if nil != currentData["raw_latitude"] {
                currentData["latitude"] = currentData["raw_latitude"]
            }
            if nil != currentData["raw_longitude"] {
                currentData["longitude"] = currentData["raw_longitude"]
            }
            currentData.removeValue(forKey: "coords")
            currentData.removeValue(forKey: "raw_latitude")
            currentData.removeValue(forKey: "raw_longitude")
            for oneValue in self.keyList {
                var currentVal = currentData[oneValue] as? String ?? ""
                if currentVal.isEmpty, let cVal = currentData[oneValue] as? Int {
                    currentVal = String(cVal)
                }
                if currentVal.isEmpty, let cVal = currentData[oneValue] as? Float {
                    currentVal = String(cVal)
                }
                if currentVal.isEmpty, let cVal = currentData[oneValue] as? Double {
                    currentVal = String(cVal)
                }
                if currentVal.isEmpty, let cVal = currentData[oneValue] as? [String: [Int]] {
                    currentVal = String(describing: cVal)
                }
                if let label = stringMap[oneValue] {
                    if !label.isEmpty {
                        let isMainAdmin = self.editableObject.sdkInstance?.isMainAdmin ?? false
                        if "associated_login_id" != oneValue || isMainAdmin {
                            generatedValuesAndLabels.append(GeneratedValuesAndLabels(label: label, dataKey: oneValue, stringValue: currentVal))
                        }
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
    @IBAction func displayEPUBButtonHit(_ sender: UIButton) {
        if !(self.documentDisplayController?.presentPreview(animated: true))! {
            UIApplication.displayAlert("Unable to Display EPUB Document", inMessage: "You need to have iBooks installed.", presentedBy: self)
        }
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func displayGenericButtonHit(_ sender: UIButton) {
        if !(self.documentDisplayController?.presentPreview(animated: true))! {
            UIApplication.displayAlert("Unable to Display the Document", inMessage: "", presentedBy: self)
        }
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func changePayloadButtonHit(_ sender: UIButton) {
        self.performSegue(withIdentifier: "show-payload-choices", sender: nil)
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

        if var tokenList = self.editableObject.sdkInstance?.securityTokens {
            if let selectedRow = tokenList.firstIndex(of: self.editableObject.writeToken) {
                self.writeTokenPickerView.selectRow(selectedRow, inComponent: 0, animated: true)
            }
            tokenList.insert(0, at: 0)
            if let selectedRow = tokenList.firstIndex(of: self.editableObject.readToken) {
                self.readTokenPickerView.selectRow(selectedRow, inComponent: 0, animated: true)
            }
        }
        
        self.generateValuesAndLabels()
        
        super.viewDidLoad()
    }
    
    /* ################################################################## */
    /**
     */
    override func viewWillAppear(_ animated: Bool) {
        self.saveButton.isEnabled = self.editableObject.isDirty
        super.viewWillAppear(animated)
    }
    
    /* ################################################################## */
    /**
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RVP_MediaChoiceViewController {
            destination.controller = self
        }
    }

    /* ################################################################## */
    /**
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.editableObject is RVP_Cocoa_SDK_Login {
            return super.numberOfSections(in: tableView) - 1
        }
        
        return super.numberOfSections(in: tableView)
    }
    
    /* ################################################################## */
    /**
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if 1 == section {
            return self.generatedValuesAndLabels.count
        } else if 2 == section {
            return 1
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    /* ################################################################## */
    /**
     */
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return super.tableView(tableView, indentationLevelForRowAt: IndexPath(row: 0, section: 0))
    }

    /* ################################################################## */
    /**
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if 1 == indexPath.section {
            return super.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 0))
        } else if 2 == indexPath.section {
            return self.payloadHeight
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
            var labelText: String = ""
            var fieldText: String = ""

            labelText = self.generatedValuesAndLabels[indexPath.row].label
            fieldText = self.generatedValuesAndLabels[indexPath.row].stringValue ?? ""
            
            let testLabel = UILabel()
            testLabel.backgroundColor = UIColor.clear
            testLabel.textColor = UIColor.white
            testLabel.font = UIFont.systemFont(ofSize: 17)
            testLabel.textAlignment = .left
            testLabel.text = labelText
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
            
            testTextItem.text = fieldText
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
            self.payloadDisplayView?.removeFromSuperview()
            self.payloadDisplayView = nil
            
            let ret = UITableViewCell()
            ret.backgroundColor = UIColor.clear
            
            let testLabel = UILabel()
            testLabel.backgroundColor = UIColor.clear
            testLabel.textColor = UIColor.white
            testLabel.font = UIFont.systemFont(ofSize: 17)
            testLabel.textAlignment = .left
            testLabel.text = "Payload:"
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
            
            let buttonObject = UIButton()
            buttonObject.setTitle("CHANGE PAYLOAD", for: .normal)
            buttonObject.addTarget(self, action: #selector(type(of: self).changePayloadButtonHit(_:)), for: .touchUpInside)
            ret.addSubview(buttonObject)
            buttonObject.titleLabel?.font = self.nameTextField.font
            buttonObject.setTitleColor(self.nameTextField.textColor, for: .normal)

            buttonObject.translatesAutoresizingMaskIntoConstraints = false

            ret.addConstraints([
                NSLayoutConstraint(item: buttonObject,
                                   attribute: .top,
                                   relatedBy: .equal,
                                   toItem: testLabel,
                                   attribute: .bottom,
                                   multiplier: 1.0,
                                   constant: 0),
                NSLayoutConstraint(item: buttonObject,
                                   attribute: .left,
                                   relatedBy: .equal,
                                   toItem: ret,
                                   attribute: .leftMargin,
                                   multiplier: 1.0,
                                   constant: 0),
                NSLayoutConstraint(item: buttonObject,
                                   attribute: .height,
                                   relatedBy: .equal,
                                   toItem: nil,
                                   attribute: .notAnAttribute,
                                   multiplier: 1.0,
                                   constant: 30),
                NSLayoutConstraint(item: buttonObject,
                                   attribute: .right,
                                   relatedBy: .equal,
                                   toItem: ret,
                                   attribute: .right,
                                   multiplier: 1.0,
                                   constant: 0)
                ])

            let dictionary = self.editableObject.asDictionary
            if let payload = dictionary["payload"] as? RVP_Cocoa_SDK_Payload {
                let newFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.bounds.size.width, height: self.payloadHeight - 51))
                
                let payloadContainer = UIView()
                
                self.payloadDisplayView = RVP_DisplayPayloadView(payload, controller: self)
                self.payloadDisplayView.frame = newFrame
                payloadContainer.addSubview(self.payloadDisplayView)

                ret.addSubview(payloadContainer)

                payloadContainer.translatesAutoresizingMaskIntoConstraints = false
                
                ret.addConstraints([
                    NSLayoutConstraint(item: payloadContainer,
                                       attribute: .top,
                                       relatedBy: .equal,
                                       toItem: buttonObject,
                                       attribute: .bottom,
                                       multiplier: 1.0,
                                       constant: 0),
                    NSLayoutConstraint(item: payloadContainer,
                                       attribute: .left,
                                       relatedBy: .equal,
                                       toItem: ret,
                                       attribute: .left,
                                       multiplier: 1.0,
                                       constant: 0),
                    NSLayoutConstraint(item: payloadContainer,
                                       attribute: .bottom,
                                       relatedBy: .equal,
                                       toItem: ret,
                                       attribute: .bottom,
                                       multiplier: 1.0,
                                       constant: 0),
                    NSLayoutConstraint(item: payloadContainer,
                                       attribute: .right,
                                       relatedBy: .equal,
                                       toItem: ret,
                                       attribute: .right,
                                       multiplier: 1.0,
                                       constant: 0)
                    ])
            }
            
            if let lastView = ret.subviews.last {
                ret.addConstraints([
                    NSLayoutConstraint(item: lastView,
                                       attribute: .bottom,
                                       relatedBy: .equal,
                                       toItem: ret,
                                       attribute: .bottom,
                                       multiplier: 1.0,
                                       constant: -10)])
            }
           return ret
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
                self.editableObject.myData[element.dataKey] = newValue
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
            if let tokenList = self.editableObject.sdkInstance?.securityTokens {
                return tokenList.count + 1
            }
        } else if self.writeTokenPickerView == pickerView {
            if let tokenList = self.editableObject.sdkInstance?.securityTokens {
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
            if var tokenList = self.editableObject.sdkInstance?.securityTokens {
                tokenList.insert(0, at: 0)
                return String(tokenList[row])
            }
        } else if self.writeTokenPickerView == pickerView {
            if let tokenList = self.editableObject.sdkInstance?.securityTokens {
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
            if var tokenList = self.editableObject.sdkInstance?.securityTokens {
                tokenList.insert(0, at: 0)
                self.editableObject.readToken = tokenList[row]
            }
        } else if self.writeTokenPickerView == pickerView {
            if let tokenList = self.editableObject.sdkInstance?.securityTokens {
                self.editableObject.writeToken = tokenList[row]
            }
        }
        self.syncObject()
        self.determineSaveStatus()
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
}
