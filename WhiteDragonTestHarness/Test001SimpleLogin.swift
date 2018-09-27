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
class Test001SimpleLogin: UIViewController, RVP_IOS_SDK_Delegate, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource {
    private let _logins: [String] = ["admin", "MDAdmin", "VAAdmin", "DCAdmin", "WVAdmin", "DEAdmin", "MainAdmin", "Dilbert", "Wally", "Ted", "Alice", "Tina", "PHB", "MeLeet"]
    private var _objects: [A_RVP_IOS_SDK_Object] = []
    
    var mySDKTester: WhiteDragonSDKTester?
    @IBOutlet weak var loginButton: LucyButton!
    @IBOutlet weak var activityScreen: UIView!
    @IBOutlet weak var selectionDisplayView: UIView!
    @IBOutlet weak var loginPickerView: UIPickerView!
    @IBOutlet weak var displayTableView: UITableView!
    
    /* ################################################################## */
    /**
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mySDKTester =  WhiteDragonSDKTester(dbPrefix: "sdk_1", delegate: self, session: TestHarnessAppDelegate.testHarnessDelegate.connectionSession)
        self.logout()
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
        if let destination = segue.destination as? RVP_DisplayResultsScreenViewController {
            if let node = sender as? A_RVP_IOS_SDK_Object {
                destination.resultsArray = [node]
                destination.sdkInstance = self.mySDKTester?.sdkInstance
            }
        }
        super.prepare(for: segue, sender: nil)
    }

    /* ################################################################## */
    /**
     */
    @IBAction func lucyButtonHit(_ sender: LucyButton) {
        if let tester = self.mySDKTester {
            self.clearResults()
            self.activityScreen.isHidden = false
            if tester.isLoggedIn {
                tester.logout()
            } else {
                let row = self.loginPickerView.selectedRow(inComponent: 0)
                tester.login(loginID: self._logins[row], password: "CoreysGoryStory")
            }
        }
    }
    
    /* ################################################################## */
    /**
     */
    func logout() {
        self.clearResults()
        if let sdkTester = self.mySDKTester, let sdkInstance = sdkTester.sdkInstance, sdkInstance.isLoggedIn {
            sdkInstance.logout()
        } else {
            self.activityScreen.isHidden = true
            self.displayTableView.isHidden = true
            self.loginPickerView.isHidden = false
            self.loginButton.theDoctorIsIn = false
        }
    }
    
    /* ################################################################## */
    /**
     */
    func clearResults() {
        self._objects = []
        self.displayTableView.reloadData()
    }
    
    /* ################################################################## */
    /**
     */
    private func _showLoginDetails(_ inLoginObject: A_RVP_IOS_SDK_Object) {
        self.performSegue(withIdentifier: "show-object-details", sender: inLoginObject)
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
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, sessionConnectionIsValid inConnectionIsValid: Bool) {
        #if DEBUG
        print("Connection is" + (inConnectionIsValid ? "" : " not") + " valid!")
        #endif
    }

    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, loginValid inLoginValid: Bool) {
        #if DEBUG
        if inLoginValid {
            if let loginID = inSDKInstance.myLoginInfo?.loginID {
                print("Instance is logged in as " + loginID + "!")
                
                DispatchQueue.main.async {
                    if let loginInfo = inSDKInstance.myLoginInfo {
                        self.sdkInstance(inSDKInstance, fetchedDataItems: [loginInfo])
                    }
                    if let userInfo = inSDKInstance.myUserInfo {
                        self.sdkInstance(inSDKInstance, fetchedDataItems: [userInfo])
                    }
                }
            } else {
                print("ERROR!")
            }
        } else {
            print("Instance is logged out!")
        }
        #endif
        DispatchQueue.main.async {
            self.activityScreen.isHidden = true
            self.displayTableView.isHidden = !inLoginValid
            self.loginPickerView.isHidden = inLoginValid
            self.loginButton.theDoctorIsIn = inLoginValid
        }
    }
    
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, sessionDisconnectedBecause inReason: RVP_IOS_SDK.DisconnectionReason) {
        #if DEBUG
        print("Instance disconnected because \(inReason)!")
        #endif
        DispatchQueue.main.async {
            self.activityScreen.isHidden = true
        }
    }
    
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, sessionError inError: Error) {
        #if DEBUG
        print("Instance Error: \(inError)!")
        #endif
        DispatchQueue.main.async {
            self.activityScreen.isHidden = true
        }
    }
    
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, fetchedDataItems: [A_RVP_IOS_SDK_Object]) {
        #if DEBUG
        print("Fetched \(fetchedDataItems.count) Items!")
        #endif
        
        if self._objects.isEmpty {
            self._objects.append(contentsOf: fetchedDataItems)
        } else {
            var toBeAdded: [A_RVP_IOS_SDK_Object] = []
            
            for item in fetchedDataItems {
                if !self._objects.contains { [item] element in
                    return element.id == item.id && type(of: element) == type(of: item)
                    } {
                    toBeAdded.append(item)
                }
            }
            
            if !toBeAdded.isEmpty {
                self._objects.append(contentsOf: toBeAdded)
            }
        }
        
        self._objects = self._objects.sorted(by: { $0.id < $1.id })

        DispatchQueue.main.async {
            self.displayTableView.reloadData()
            
            if let topper = UIApplication.getTopmostViewController() as? RVP_DisplayResultsScreenViewController {
                topper.addNewItems(fetchedDataItems)
            }
            
            self.activityScreen?.isHidden = true
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
        return self._logins.count
    }
    
    /* ################################################################## */
    /**
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self._logins[row]
    }

    /* ################################################################## */
    /**
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._objects.count
    }
    
    /* ################################################################## */
    /**
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var ret: UITableViewCell!   // If we don't have anything, then this will cause the method to crash; which is what we want. It shouldn't be called if we have nothing.
        
        if 0 < self._objects.count, indexPath.row < self._objects.count {
            let rowObject = self._objects[indexPath.row]
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
        if 0 < self._objects.count, indexPath.row < self._objects.count {
            tableView.deselectRow(at: indexPath, animated: true)
            let rowObject = self._objects[indexPath.row]
            self._showLoginDetails(rowObject)
        }
    }
}
