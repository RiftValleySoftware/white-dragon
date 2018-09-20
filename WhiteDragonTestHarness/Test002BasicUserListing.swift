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

class Test002BasicUserListing: UIViewController, RVP_IOS_SDK_Delegate, UIPickerViewDataSource, UIPickerViewDelegate {
    private let _presets: [(name: String, values: [Int])] = [(name: "MDAdmin", values: [1725]),
                                                             (name: "CEO", values: [1751]),
                                                             (name: "DC Area Admins", values: [1725, 1726, 1727, 1728, 1729, 1730]),
                                                             (name: "Restricted Admins", values: [1730, 1731]),
                                                             (name: "DilbertCo", values: [1745, 1746, 1747, 1748, 1749, 1750, 1751, 1752, 1753, 1754])
                                                            ]
    private let _buttonStrings = ["LOGIN", "LOGOUT"]
    private var _userList: [RVP_IOS_SDK_User] = []
    
    var mySDKTester: WhiteDragonSDKTester?
    @IBOutlet weak var activityScreen: UIView!
    @IBOutlet weak var fetchDataButton: UIButton!
    @IBOutlet weak var userListPicker: UIPickerView!
    @IBOutlet weak var specificationItemsView: UIView!
    @IBOutlet weak var loginMainAdminButton: UIButton!
    @IBOutlet weak var displayResultsView: UIView!
    @IBOutlet weak var displayResultsScrollView: UIScrollView!
    
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
        self.getUsers()
    }
    
    /* ################################################################## */
    /**
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearResults()
        self.mySDKTester = WhiteDragonSDKTester(dbPrefix: "sdk_1", delegate: self, session: TestHarnessAppDelegate.testHarnessDelegate.connectionSession)
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
        if let tester = self.mySDKTester {
            if tester.isLoggedIn {
                tester.logout()
            }
        }
    }
    
    /* ################################################################## */
    /**
     */
    func clearResults() {
        self.displayResultsView.subviews.forEach({ $0.removeFromSuperview() })
        self.displayResultsView.frame.size.height = 0
        self.displayResultsScrollView.contentSize.height = 0
    }
    
    /* ################################################################## */
    /**
     */
    func addOneItemToTheResults(_ inItem: A_RVP_IOS_SDK_Object) {
        let height: CGFloat = 30
        
        self.displayResultsScrollView.contentSize.height += height
        self.displayResultsView.heightAnchor.constraint(equalToConstant: self.displayResultsScrollView.contentSize.height).isActive = true

        self.displayResultsScrollView.contentOffset = CGPoint.zero
        
        var anchor: NSLayoutAnchor = self.displayResultsView.topAnchor
        var constant: CGFloat = 0
        
        if !self.displayResultsView.subviews.isEmpty, let lastSubView = self.displayResultsView.subviews.last {
            anchor = lastSubView.bottomAnchor
            constant = 8
        }

        let newItem = RVP_DisplayElementView(frame: CGRect.zero)
        newItem.displayedElement = inItem
        
        self.displayResultsView.addSubview(newItem)
        
        newItem.translatesAutoresizingMaskIntoConstraints = false
        newItem.topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        newItem.heightAnchor.constraint(equalToConstant: height).isActive = true
        newItem.leadingAnchor.constraint(equalTo: self.displayResultsView.leadingAnchor).isActive = true
        newItem.trailingAnchor.constraint(equalTo: self.displayResultsView.trailingAnchor).isActive = true
    }

    /* ################################################################## */
    /**
     */
    func getUsers() {
        self._userList = []
        self.clearResults()
        if let sdkInstance = self.mySDKTester?.sdkInstance {
            let row = self.userListPicker.selectedRow(inComponent: 0)
            let userIDList = self._presets[row].values
            self.activityScreen?.isHidden = false
            sdkInstance.fetchUsers(userIDList)
        }
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
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, sessionDisconnectedBecause inReason: RVP_IOS_SDK.DisconnectionReason) {
        #if DEBUG
        print("Instance disconnected because \(inReason)!")
        #endif
        DispatchQueue.main.async {
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
        }
    }
    
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, fetchedDataItems: [A_RVP_IOS_SDK_Object]) {
        #if DEBUG
        print("Fetched \(fetchedDataItems.count) Items!")
        #endif
        
        if let dataItems = fetchedDataItems as? [RVP_IOS_SDK_User] {
            self._userList.append(contentsOf: dataItems)
            for item in dataItems {
                DispatchQueue.main.async {
                    self.addOneItemToTheResults(item)
                }
            }
        }
        
        DispatchQueue.main.async {
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
}
