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

class WhiteDragonSDKTester: RVP_IOS_SDK_Delegate {
    let uri: String = "https://littlegreenviper.com/fuggedaboudit/baobab/index.php"
    let secret: String = "Supercalifragilisticexpialidocious"
    
    let adminLogin: String = "admin"
    let normalTimeout: TimeInterval = 3600
    let adminTimeout: TimeInterval = 600
    var sdkInstance: RVP_IOS_SDK?
    var loginID: String?
    var password: String?

    /* ################################################################## */
    /**
     */
    private func _setupDBComplete() {
        if nil != self.loginID && nil != self.password {
            self.login(loginID: self.loginID!, password: self.password!)
        }
    }

    /* ################################################################## */
    /**
     */
    private func _setDBUp(_ inDBPrefix: String) {
        if let db = inDBPrefix.urlEncodedString {
            let url = "https://littlegreenviper.com/fuggedaboudit/set-db/index.php??l=2&s=Rambunkchous&d=" + db
            if let url_object = URL(string: url) {
                let configuration = URLSessionConfiguration.ephemeral
                configuration.waitsForConnectivity = true
                let connectionSession = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
                let loginInfoTask = connectionSession.dataTask(with: url_object) { _, _, _ in
                    self._setupDBComplete()
                }
                
                loginInfoTask.resume()
            }
        }
    }
    
    /* ################################################################## */
    // MARK: - Public Instance Methods
    /* ################################################################## */
    /**
     */
    public init(dbPrefix inDBPrefix: String, loginID inLoginID: String? = nil, password inPassword: String? = nil) {
        self.loginID = inLoginID
        self.password = inPassword
        self.sdkInstance = RVP_IOS_SDK(serverURI: self.uri, serverSecret: self.secret, delegate: self)
        self._setDBUp(inDBPrefix)
    }
    
    /* ################################################################## */
    /**
     */
    func login(loginID inLoginId: String, password inPassword: String) {
        if let sdkInstance = self.sdkInstance {
            let timeout = (self.adminLogin == inLoginId ? self.adminTimeout : self.normalTimeout)
            _ = sdkInstance.login(loginID: inLoginId, password: inPassword, timeout: timeout)
        }
    }
    
    /* ################################################################## */
    // MARK: - RVP_IOS_SDK_Delegate Methods
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, loginValid: Bool) {
    }

    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, sessionDisconnectedBecause: RVP_IOS_SDK.DisconnectionReason) {
    }
        
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, sessionError: Error) {
    }
}
