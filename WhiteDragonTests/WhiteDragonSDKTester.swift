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

import Foundation
import WhiteDragon

class WhiteDragonSDKTester {
    private var _connectionSession: URLSession?
    private weak var _delegate: RVP_Cocoa_SDK_Delegate?
    private var _newSession: Bool = false
    
    let uri: String = "https://littlegreenviper.com/fuggedaboudit/baobab/index.php"
    let secret: String = "Supercalifragilisticexpialidocious"
    let adminLogin: String = "admin"
    let normalTimeout: TimeInterval = 3600
    let adminTimeout: TimeInterval = 600
    
    var sdkInstance: RVP_Cocoa_SDK?
    var loginID: String?
    var password: String?

    /* ################################################################## */
    /**
     */
    private func _setupDBComplete() {
        if let delegate = self._delegate, nil != self._connectionSession {
            self.sdkInstance = RVP_Cocoa_SDK(serverURI: self.uri, serverSecret: self.secret, delegate: delegate, session: self._connectionSession)
        }
    }
    
    /* ################################################################## */
    /**
     */
    private func _setDBUp(_ inDBPrefix: String) {
        if let db = inDBPrefix.urlEncodedString {
            let url = "https://littlegreenviper.com/fuggedaboudit/set-db/index.php?l=2&s=Rambunkchous&d=" + db
            if let url_object = URL(string: url) {
                if let setuBDTask = (self._connectionSession?.dataTask(with: url_object) { [unowned self] _, response, error in
                            if let error = error {
                                #if DEBUG
                                print("DB Setup Error: \(error)!")
                                #endif
                                return
                            }
                            guard let httpResponse = response as? HTTPURLResponse,
                                (200...299).contains(httpResponse.statusCode) else {
                                    #if DEBUG
                                    print("DB Setup Response Issue: \(String(describing: response))!")
                                    #endif
                                    return
                            }
                            self._setupDBComplete()
                    }) {
                    setuBDTask.resume()
                }
            }
        }
    }
    
    /* ################################################################## */
    // MARK: - Public Calculated Properties
    /* ################################################################## */
    /**
     */
    var isLoggedIn: Bool {
        if let sdkInstance = self.sdkInstance {
            if sdkInstance.isLoggedIn {
                return true
            }
        }
        
        return false
    }
    
    /* ################################################################## */
    // MARK: - Public Instance Methods
    /* ################################################################## */
    /**
     */
    public init(dbPrefix inDBPrefix: String, loginID inLoginID: String? = nil, password inPassword: String? = nil, delegate inDelegate: RVP_Cocoa_SDK_Delegate, session inSession: URLSession? = nil) {
        self._delegate = inDelegate
        self.loginID = inLoginID
        self.password = inPassword
        if nil != inSession {
            self._newSession = false
            self._connectionSession = inSession
        } else {
            self._newSession = true
            self._connectionSession = URLSession(configuration: URLSessionConfiguration.ephemeral, delegate: nil, delegateQueue: nil)
        }
        self._setDBUp(inDBPrefix)
    }
    
    /* ################################################################## */
    /**
     */
    deinit {
        if nil != self._connectionSession, self._newSession {
            self._connectionSession!.finishTasksAndInvalidate()
        }
        self._connectionSession = nil
        self.sdkInstance = nil
    }
    
    /* ################################################################## */
    /**
     */
    func login(loginID inLoginID: String! = nil, password inPassword: String! = nil) {
        if let sdkInstance = self.sdkInstance {
            if sdkInstance.isLoggedIn {
                sdkInstance.logout()
            }
            
            if nil != inLoginID && nil != inPassword {
                self.loginID = inLoginID
                self.password = inPassword
            }
            
            if let loginID = self.loginID, let password = self.password {
                let timeout = (self.adminLogin == self.loginID ? self.adminTimeout : self.normalTimeout)
                _ = sdkInstance.login(loginID: loginID, password: password, timeout: timeout)
            }
        }
    }
    
    /* ################################################################## */
    /**
     */
    func logout() {
        if let sdkInstance = self.sdkInstance {
            sdkInstance.logout()
        }
    }
}
