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
import WhiteDragon

/* ###################################################################### */
/**
 This adds various functionality to the String class.
 */
extension String {
    /* ################################################################## */
    /**
     This tests a string to see if a given substring is present at the start.
     
     - parameter inSubstring: The substring to test.
     
     - returns: true, if the string begins with the given substring.
     */
    func beginsWith (_ inSubstring: String) -> Bool {
        var ret: Bool = false
        if let range = self.range(of: inSubstring) {
            ret = (range.lowerBound == self.startIndex)
        }
        return ret
    }
    
    /* ################################################################## */
    /**
     The following calculated property comes from this: http://stackoverflow.com/a/27736118/879365
     
     This extension function cleans up a URI string.
     
     - returns: a string, cleaned for URI.
     */
    var urlEncodedString: String? {
        let customAllowedSet =  CharacterSet.urlQueryAllowed
        if let ret = self.addingPercentEncoding(withAllowedCharacters: customAllowedSet) {
            return ret
        } else {
            return ""
        }
    }
    
    /* ################################################################## */
    /**
     This was cribbed from here: https://stackoverflow.com/a/48867619/879365
     
     This is a quick "classmaker" from a String. You assume the String is the name of
     a class that you want to instantiate, so you use this to return a metatype that
     can be used to create a class.
     
     - returns: a metatype for a class, or nil, if the class cannot be instantiated.
     */
    var asClass: AnyClass? {
        // The first thing we do, is get the main app bundle. Failure retuend nil.
        guard
            let dict = Bundle.main.infoDictionary,
            var appName = dict["CFBundleName"] as? String
            else {
                return nil
        }
        
        // The app name will not tolerate spaces, so they are replaced with underscores.
        appName = appName.replacingOccurrences(of: " ", with: "_")
        
        // The class name is simply a namespace-focused string.
        let className = appName + "." + self
        
        // This looks through the app for the class being loaded. If it finds it, it returns the metatype for that class.
        return NSClassFromString(className)
    }
    
    /* ################################################################## */
    /**
     The following function comes from this: http://stackoverflow.com/a/27736118/879365
     
     This extension function creates a URI query string from given parameters.
     
     - parameter parameters: a dictionary containing query parameters and their values.
     
     - returns: a String, with the parameter list.
     */
    static func queryStringFromParameters(_ parameters: [String: String]) -> String? {
        if parameters.isEmpty {
            return nil
        }
        
        var queryString: String?
        
        for (key, value) in parameters {
            if let encodedKey = key.urlEncodedString {
                if let encodedValue = value.urlEncodedString {
                    if queryString == nil {
                        queryString = "?"
                    } else {
                        queryString! += "&"
                    }
                    queryString! += encodedKey + "=" + encodedValue
                }
            }
        }
        return queryString
    }
    
    /* ################################################################## */
    /**
     "Cleans" a URI
     
     - returns: an implicitly unwrapped optional String. This is the given URI, "cleaned up" ("http[s]://" may be prefixed).
     */
    func cleanURI() -> String! {
        return self.cleanURI(sslRequired: false)
    }
    
    /* ################################################################## */
    /**
     "Cleans" a URI, allowing SSL requirement to be specified.
     
     - parameter sslRequired: If true, then we insist on SSL.
     
     - returns: an implicitly unwrapped optional String. This is the given URI, "cleaned up" ("http[s]://" may be prefixed)
     */
    func cleanURI(sslRequired: Bool) -> String! {
        var ret: String! = self.urlEncodedString
        
        // Very kludgy way of checking for an HTTPS URI.
        let wasHTTP: Bool = ret.lowercased().beginsWith("http://")
        let wasHTTPS: Bool = ret.lowercased().beginsWith("https://")
        
        // Yeah, this is pathetic, but it's quick, simple, and works a charm.
        ret = ret.replacingOccurrences(of: "^http[s]{0,1}://", with: "", options: NSString.CompareOptions.regularExpression)
        
        if wasHTTPS || (sslRequired && !wasHTTP && !wasHTTPS) {
            ret = "https://" + ret
        } else {
            ret = "http://" + ret
        }
        
        return ret
    }
}

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
    @IBOutlet weak var createNewButton: UIButton!
    
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
    @IBAction func createNewButtonPressed(_ sender: UIButton) {}
    
    /* ################################################################## */
    /**
     */
    func checkButtonVisibility() {
        if let button = self.createNewButton, let sdkObject = self.mySDKTester?.sdkInstance {
            button.isHidden = !sdkObject.isLoggedIn
        }
        
        self.activityScreen?.isHidden = true
        self.loginMainAdminButton?.isHidden = false
        self.displayResultsButton?.isHidden = self.objectList.isEmpty
    }
    
    /* ################################################################## */
    /**
     */
    func callCreateNewEditor(_ inEditElement: A_RVP_Cocoa_SDK_Object) {
        self.performSegue(withIdentifier: "create-new-edit", sender: inEditElement)
    }
    
    /* ################################################################## */
    /**
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearResults()
        self.mySDKTester = WhiteDragonSDKTester(dbPrefix: self.dbPrefix, delegate: self, session: TestHarnessAppDelegate.testHarnessDelegate.connectionSession)
        self.loginMainAdminButton.setTitle(self._buttonStrings[0], for: .normal)
        self.checkButtonVisibility()
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
        } else if "create-new-edit" == segue.identifier, let destination = segue.destination as? RVP_EditElementViewController, let sender = sender as? A_RVP_Cocoa_SDK_Object {
            destination.editableObject = sender
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
            self.checkButtonVisibility()
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
            self.checkButtonVisibility()
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
            self.checkButtonVisibility()
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
    func sdkInstance(_: RVP_Cocoa_SDK, baselineAutoRadiusIDs: [Int], isFinal: Bool) {
        #if DEBUG
        print("Baseline IDs (\(baselineAutoRadiusIDs.count)): \(String(describing: baselineAutoRadiusIDs))" + (isFinal ? " Final Call" : ""))
        #endif
    }
    
    /* ################################################################## */
    /**
     */
    func sdkInstanceFinalAutoRadiusCall(_: RVP_Cocoa_SDK) {
        #if DEBUG
        print("Final Call")
        #endif
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
