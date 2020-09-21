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

@UIApplicationMain
/* ###################################################################################################################################### */
// MARK: - Main Class -
/* ###################################################################################################################################### */
/**
 */
class TestHarnessAppDelegate: UIResponder, UIApplicationDelegate {
    var connectionSession: URLSession?
    var window: UIWindow?
    
    /* ################################################################## */
    /**
     */
    static var testHarnessDelegate: TestHarnessAppDelegate {
        return (UIApplication.shared.delegate as? TestHarnessAppDelegate)!
    }

    /* ################################################################## */
    /**
     */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.connectionSession = URLSession(configuration: URLSessionConfiguration.ephemeral, delegate: nil, delegateQueue: nil)
        return true
    }

    /* ################################################################## */
    /**
     */
    func applicationWillTerminate(_ application: UIApplication) {
        if nil != self.connectionSession {
            self.connectionSession!.finishTasksAndInvalidate()   // Take off and nuke the site from orbit. It's the only way to be sure.
        }
    }    
}

/* ###################################################################################################################################### */
// MARK: - Main NavController Class -
/* ###################################################################################################################################### */
/**
 */
class MainDispatchNavController: UINavigationController {
}

/* ###################################################################################################################################### */
// MARK: - Main Class -
/* ###################################################################################################################################### */
/**
 */
class DispatcherListController: UITableViewController {
    /* ################################################################## */
    /**
     */
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    /* ################################################################## */
    /**
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
