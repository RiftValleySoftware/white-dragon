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

class Test005BaselineSearches: UIViewController, RVP_Cocoa_SDK_Delegate, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource {
    private let _presets: [(name: String, values: [Any])] = [(name: "Single Image", values: [1732]),
                                                             (name: "Single Image and Single Place", values: [2, 1732]),
                                                             (name: "Single Image, Single Place, and Single User", values: [2, 1725, 1732])
    ]
    private let _buttonStrings = ["LOGIN", "LOGOUT"]
    private var _objectList: [A_RVP_Cocoa_SDK_Object] = []
    
    var mySDKTester: WhiteDragonSDKTester?
    @IBOutlet weak var activityScreen: UIView!
    @IBOutlet weak var fetchDataButton: UIButton!
    @IBOutlet weak var objectListPicker: UIPickerView!
    @IBOutlet weak var specificationItemsView: UIView!
    @IBOutlet weak var loginMainAdminButton: UIButton!
    @IBOutlet weak var resultsTableView: UITableView!
    
    /* ################################################################## */
    /**
     */
    private func _showObjectDetails(_ inObject: A_RVP_Cocoa_SDK_Object) {
        self.performSegue(withIdentifier: "show-search-details", sender: inObject)
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func loginMainAdminButtonPressed(_ sender: UIButton) {
        if let tester = self.mySDKTester {
            if let sdkInstance = tester.sdkInstance {
                self.activityScreen?.isHidden = false
                self.clearResults()
                if sdkInstance.isLoggedIn {
                    tester.logout()
                } else {
                    tester.login(loginID: "admin", password: "CoreysGoryStory")
                }
            }
        }
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func fetchDataButtonPressed(_ sender: UIButton) {
        self.getObjects()
    }
    
    /* ################################################################## */
    /**
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearResults()
        self.mySDKTester = WhiteDragonSDKTester(dbPrefix: "sdk_4", delegate: self, session: TestHarnessAppDelegate.testHarnessDelegate.connectionSession)
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
    func sortList() {
        self._objectList = self._objectList.sorted(by: { $0.id < $1.id })
    }
    
    /* ################################################################## */
    /**
     */
    func clearResults() {
        self._objectList = []
        DispatchQueue.main.async {
            self.resultsTableView.reloadData()
        }
    }
    
    /* ################################################################## */
    /**
     */
    func getObjects() {
        self._objectList = []
        self.clearResults()
        if let sdkInstance = self.mySDKTester?.sdkInstance {
            self.activityScreen?.isHidden = false
            let row = self.objectListPicker.selectedRow(inComponent: 0)
            if let iDList = self._presets[row].values as? [Int] {
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RVP_DisplayResultsScreenViewController {
            if let node = sender as? A_RVP_Cocoa_SDK_Object {
                destination.resultsArray = [node]
                destination.sdkInstance = self.mySDKTester?.sdkInstance
            }
        }
        super.prepare(for: segue, sender: nil)
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
            self.loginMainAdminButton.setTitle(inLoginValid ? self._buttonStrings[1] : self._buttonStrings[0], for: .normal)
            self.activityScreen?.isHidden = true
            self.loginMainAdminButton?.isHidden = false
            self.specificationItemsView?.isHidden = false
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
        
        if self._objectList.isEmpty {
            self._objectList.append(contentsOf: fetchedDataItems)
        } else {
            var toBeAdded: [A_RVP_Cocoa_SDK_Object] = []
            
            for item in fetchedDataItems {
                if !self._objectList.contains { [item] element in
                    return element.id == item.id && type(of: element) == type(of: item)
                    } {
                    toBeAdded.append(item)
                }
            }
            
            if !toBeAdded.isEmpty {
                self._objectList.append(contentsOf: toBeAdded)
            }
        }
        
        self.sortList()
        
        DispatchQueue.main.async {
            self.resultsTableView.reloadData()
            
            if let topper = UIApplication.getTopmostViewController() as? RVP_DisplayResultsScreenViewController {
                topper.addNewItems(fetchedDataItems)
            }
            
            self.activityScreen?.isHidden = true
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
        return self._presets.count
    }
    
    /* ################################################################## */
    /**
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self._presets[row].name
    }
    
    /* ################################################################## */
    /**
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._objectList.count
    }
    
    /* ################################################################## */
    /**
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var ret: UITableViewCell!   // If we don't have anything, then this will cause the method to crash; which is what we want. It shouldn't be called if we have nothing.
        
        if 0 < self._objectList.count, indexPath.row < self._objectList.count {
            let rowObject = self._objectList[indexPath.row]
            var nameString = String(rowObject.id)
            if !rowObject.name.isEmpty {
                nameString = rowObject.name + " (" + nameString + ")"
            }
            
            let topLabel = UILabel()
            
            topLabel.text = nameString
            topLabel.font = UIFont.boldSystemFont(ofSize: 20)
            topLabel.textAlignment = .center
            let height: CGFloat = topLabel.oneLineHeight
            var frame = tableView.bounds
            frame.size.height = height
            ret = UITableViewCell(frame: frame)
            ret.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: ((0 == indexPath.row % 2) ? 0 : 0.05))
            self.applyConstraints(thisElement: topLabel, height: height, container: ret)
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if 0 < self._objectList.count, indexPath.row < self._objectList.count {
            tableView.deselectRow(at: indexPath, animated: true)
            let rowObject = self._objectList[indexPath.row]
            self._showObjectDetails(rowObject)
        }
    }
}
