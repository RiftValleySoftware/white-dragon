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
// MARK: - Main Class -
/* ###################################################################################################################################### */
/**
 */
class TestBaseViewController: UIViewController, RVP_Cocoa_SDK_Delegate, UIPickerViewDataSource, UIPickerViewDelegate {
    private var _spacing: [CGFloat] = [0, 100]
    private let _buttonStrings = ["LOGIN AS:", "LOGOUT"]
    
    var objectList: [A_RVP_Cocoa_SDK_Object] = []
    var mySDKTester: WhiteDragonSDKTester?
    
    @IBInspectable var dbPrefix: String = ""
    
    @IBOutlet weak var displayResultsButton: UIButton!
    @IBOutlet weak var activityScreen: UIView!
    @IBOutlet weak var fetchDataButton: UIButton!
    @IBOutlet weak var objectListPicker: UIPickerView!
    @IBOutlet weak var specificationItemsView: UIView!
    @IBOutlet weak var loginMainAdminButton: UIButton!
    @IBOutlet weak var loginPickerView: UIPickerView!
    @IBOutlet weak var specificationItemsConstraint: NSLayoutConstraint!
    
    /* ################################################################## */
    /**
     */
    var logins: [String] {
        if "sdk_1" == self.dbPrefix || "sdk_4" == self.dbPrefix {
            return ["admin", "MDAdmin", "VAAdmin", "DCAdmin", "WVAdmin", "DEAdmin", "MainAdmin", "Dilbert", "Wally", "Ted", "Alice", "Tina", "PHB", "MeLeet"]
        }
        
        return ["admin"]
    }
    
    /* ################################################################## */
    /**
     */
    var presets: [(name: String, values: [Any])] {
        return []
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func loginMainAdminButtonPressed(_ sender: UIButton) {
        if let tester = self.mySDKTester {
            self.clearResults()
            self.activityScreen.isHidden = false
            if tester.isLoggedIn {
                tester.logout()
            } else {
                let row = self.loginPickerView.selectedRow(inComponent: 0)
                tester.login(loginID: self.logins[row], password: "CoreysGoryStory")
            }
        }
    }

    /* ################################################################## */
    /**
     */
    @IBAction func fetchDataButtonPressed(_ sender: UIButton) {
        self.activityScreen?.isHidden = false
        if let sdkInstance = self.mySDKTester?.sdkInstance {
            sdkInstance.flushCache()
        }
        
        self.getObjects()
    }
    
    /* ################################################################## */
    /**
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearResults()
        self.mySDKTester = WhiteDragonSDKTester(dbPrefix: self.dbPrefix, delegate: self, session: TestHarnessAppDelegate.testHarnessDelegate.connectionSession)
        self.loginMainAdminButton.setTitle(self._buttonStrings[0], for: .normal)
    }
    
    /* ################################################################## */
    /**
     */
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    /* ################################################################## */
    /**
     */
    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingFromParent, let tester = self.mySDKTester {
            if tester.isLoggedIn {
                tester.logout()
            }
        }
    }
    
    /* ################################################################## */
    /**
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RVP_ResultListNavController {
            destination.resultObjectList = self.objectList
        }
        super.prepare(for: segue, sender: nil)
    }
    
    /* ################################################################## */
    /**
     */
    func clearResults() {
        self.objectList = []
        DispatchQueue.main.async {
            self.displayResultsButton?.isHidden = true
        }
    }

    /* ################################################################## */
    /**
     */
    func getObjects() {
        self.clearResults()
        if let sdkInstance = self.mySDKTester?.sdkInstance {
            let row = self.objectListPicker.selectedRow(inComponent: 0)
            if let iDList = self.presets[row].values as? [Int] {
                self.activityScreen.isHidden = false
                sdkInstance.fetchBaselineObjectsByID(iDList)
            }
        }
    }

    /* ################################################################## */
    /**
     */
    func applyConstraints(thisElement inThisElement: UIView, height inHeight: CGFloat, container inContainerElement: UITableViewCell) {
        inContainerElement.addSubview(inThisElement)
        inThisElement.translatesAutoresizingMaskIntoConstraints = false
        
        inContainerElement.addConstraints([
            NSLayoutConstraint(item: inThisElement,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: inContainerElement,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: 3),
            NSLayoutConstraint(item: inThisElement,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: inContainerElement,
                               attribute: .centerX,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: inThisElement,
                               attribute: .width,
                               relatedBy: .equal,
                               toItem: inContainerElement,
                               attribute: .width,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: inThisElement,
                               attribute: .height,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1.0,
                               constant: inHeight)
            ])
    }
    
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_Cocoa_SDK, sessionConnectionIsValid inConnectionIsValid: Bool) {
        #if DEBUG
        print("Connection is" + (inConnectionIsValid ? "" : " not") + " valid!")
        #endif
    }
    
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_Cocoa_SDK, loginValid inLoginValid: Bool) {
        #if DEBUG
        if inLoginValid {
            if let loginID = inSDKInstance.myLoginInfo?.loginID {
                print("Instance is logged in as " + loginID + "!")
            } else {
                print("ERROR!")
            }
        } else {
            print("Instance is logged out!")
        }
        #endif
        DispatchQueue.main.async {
            var loginID = self._buttonStrings[0]
            if inLoginValid {
                self.specificationItemsConstraint.constant = self._spacing[0]
                self.loginPickerView?.isHidden = true
                if let loginIDVal = inSDKInstance.myLoginInfo?.loginID {
                    loginID = self._buttonStrings[1] + " (" + loginIDVal + ")"
                }
            } else {
                self.specificationItemsConstraint.constant = self._spacing[1]
                self.loginPickerView?.isHidden = false
            }
            
            self.loginMainAdminButton.setTitle(loginID, for: .normal)
            self.activityScreen?.isHidden = true
            self.loginMainAdminButton?.isHidden = false
            self.displayResultsButton?.isHidden = self.objectList.isEmpty
        }
    }
    
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_Cocoa_SDK, sessionDisconnectedBecause inReason: RVP_Cocoa_SDK.DisconnectionReason) {
        #if DEBUG
        print("Instance disconnected because \(inReason)!")
        #endif
        DispatchQueue.main.async {
        }
    }
    
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_Cocoa_SDK, sessionError inError: Error) {
        #if DEBUG
        print("Instance Error: \(inError)!")
        #endif
        DispatchQueue.main.async {
        }
    }
    
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_Cocoa_SDK, fetchedDataItems: [A_RVP_Cocoa_SDK_Object]) {
        #if DEBUG
        print("Fetched \(fetchedDataItems.count) Items!")
        #endif
        
        DispatchQueue.main.async {
            if let topperTemp = UIApplication.getTopmostViewController() as? RVP_DisplayResultsScreenViewController {
                topperTemp.addNewItems(fetchedDataItems)
                return
            }
            
            var objectList = self.objectList
            
            if objectList.isEmpty {
                objectList.append(contentsOf: fetchedDataItems)
            } else {
                var toBeAdded: [A_RVP_Cocoa_SDK_Object] = []
                
                for item in fetchedDataItems {
                    if !objectList.contains { [item] element in
                        return element.id == item.id && type(of: element) == type(of: item)
                        } {
                        toBeAdded.append(item)
                    }
                }
                
                if !toBeAdded.isEmpty {
                    objectList.append(contentsOf: toBeAdded)
                }
            }
            
            objectList = objectList.sorted {
                var ret = $0.id < $1.id
                
                if !ret {   // Security objects get listed before data objects
                    ret = $0 is A_RVP_Cocoa_SDK_Security_Object && $1 is A_RVP_Cocoa_SDK_Data_Object
                }
                
                return ret
            }

            self.objectList = objectList

            self.displayResultsButton?.isHidden = self.objectList.isEmpty
        }
    }
    
    /* ################################################################## */
    /**
     */
    func sdkInstanceOperationComplete(_ inSDKInstance: RVP_Cocoa_SDK) {
        DispatchQueue.main.async {
            self.activityScreen?.isHidden = true
            self.displayResultsButton?.isHidden = self.objectList.isEmpty
            if let topper = UIApplication.getTopmostViewController() as? RVP_DisplayResultsScreenViewController {
                topper.done()
            }
        }
    }
    
    /* ################################################################## */
    /**
     */
    func databasesLoadedAndCaseysOnFirst(_ inTesterObject: WhiteDragonSDKTester) {
        #if DEBUG
        print("Databases Loaded!")
        #endif
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
        return pickerView == self.loginPickerView ? self.logins.count : self.presets.count
    }
    
    /* ################################################################## */
    /**
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView == self.loginPickerView ? self.logins[row] : self.presets[row].name
    }
    
    /* ################################################################## */
    /**
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.objectListPicker {
            self.clearResults()
        }
    }
}
