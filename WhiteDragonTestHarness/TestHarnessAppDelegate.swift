//
//  AppDelegate.swift
//  WhiteDragonTestHarness
//
//  Created by Chris Marshall on 9/7/18.
//  Copyright © 2018 Little Green Viper Software Development LLC. All rights reserved.
//

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
    
    static var testHarnessDelegate: TestHarnessAppDelegate {
        return (UIApplication.shared.delegate as? TestHarnessAppDelegate)!
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.connectionSession = URLSession(configuration: URLSessionConfiguration.ephemeral, delegate: nil, delegateQueue: nil)
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        if nil != self.connectionSession {
            self.connectionSession!.finishTasksAndInvalidate()   // Take off and nuke the site from orbit. It's the only way to be sure.
        }
    }
}
