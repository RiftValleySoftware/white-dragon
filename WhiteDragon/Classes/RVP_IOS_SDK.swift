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

/* ###################################################################################################################################### */
// MARK: - Delegate Protocol -
/* ###################################################################################################################################### */
/**
 */
public protocol RVP_IOS_SDK_Delegate: class {
    /* ################################################################## */
    // MARK: - REQUIRED METHODS -
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, loginValid: Bool)
    
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, sessionDisconnectedBecause: RVP_IOS_SDK.Disconnection_Reason)
    
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, sessionError: Error)
}

/* ###################################################################################################################################### */
// MARK: - Main Library Interface Class -
/* ###################################################################################################################################### */
/**
 This class represents the public interface to the White Dragon Greate Rift Valley Platform BAOBAB Server iOS SDK framework.
 
 The SDK is a Swift-only shared framework for use by Swift applications, targeting iOS 10 or above.
 */
public class RVP_IOS_SDK: NSObject, URLSessionTaskDelegate {
    /* ################################################################## */
    // MARK: Public Enums
    /* ################################################################## */
    /**
     This enum lists the various reasons that the server connection may be disconnected.
     
     These are supplied in the delegate method.
    */
    public enum Disconnection_Reason: Int {
        /** Unkown reason. */
        case Unknown = 0
        /** The connection period has completed. */
        case Timeout = 1
        /** The server initiated the disconnection. */
        case ServerDisconnected = 2
        /** The client initiated the disconnection. */
        case ClientDisconnected = 3
    }
    
    /* ################################################################## */
    // MARK: Private Properties
    /* ################################################################## */
    /** This is the delegate object. This instance is pretty much useless without a delegate. */
    private weak var _delegate: RVP_IOS_SDK_Delegate?
    
    /** This is the URI to the server. */
    private var _server_uri: String = ""
    
    /** This is the server's sectret. */
    private var _server_secret: String = ""
    
    /** If _loggedIn is true, then this must be non-nil, and is the time at which the login was made. */
    private var _loginTime: Date! = nil
    
    /** If _loggedIn is true, then this must be non-nil, and is the period of time the login is valid. */
    private var _loginTimeout: TimeInterval! = nil

    /** This is the connection session with the server. It is initiated at the time the class is instantiated, and destroyed when the class is torn down. */
    private var _connectionSession: URLSession! = nil
    
    /** This Dictionary will contain our session tasks while they are running. This will use the call URI - Method as a key. */
    private var _connectionTasks: [String: URLSessionTask] = [:]
    
    /** This is the API Key (if logged in). */
    private var _apiKey: String! = nil
    
    /* ################################################################## */
    // MARK: Public Properties
    /* ################################################################## */
    /**
     This is a computed property that will return true if the login is valid.
     
     Logins only last so long, at which time a new API key should be fetched.
     
     - returns: true, if we are logged in, and the time interval has not passed.
    */
    var isLoggedIn: Bool {
        let logged_in_time = Date().timeIntervalSince(self._loginTime)
        return (nil != self._apiKey) && (nil != self._loginTimeout) && (self._loginTimeout! <= logged_in_time)
    }
    
    /* ################################################################## */
    // MARK: Internal Instance Methods
    /* ################################################################## */
    /**
     */
    private func _handleError (_ inError: Error) {
    }
    
    /* ################################################################## */
    /**
     */
    private func _handleHTTPError (_ inResponse: URLResponse?) {
    }

    /* ################################################################## */
    // MARK: Public Instance Methods
    /* ################################################################## */
    /**
     This is the default initializer. This is required.
     
     - parameter serverURI: (REQUIRED) A String, with the URI to a valid BAOBAB Server
     - parameter serverSecret: (REQUIRED) A String, with the Server secret for the target server.
     - parameter delegate: (REQUIRED) A RVP_IOS_SDK_Delegate that will receive updates from the SDK instance.
     - parameter loginId: (OPTIONAL) A String, with a login ID. If provided, then you must also provide inPassword and inLoginTimeout.
     - parameter password: (OPTIONAL) A String, with a login password. If provided, then you must also provide inLoginId and inLoginTimeout.
     - parameter timeout: (OPTIONAL) A Floating-point value, with the number of seconds the login has to be active. If provided, then you must also provide inLoginId and inPassword.
     */
    public init(serverURI inServerURI: String, serverSecret inServerSecret: String, delegate inDelegate: RVP_IOS_SDK_Delegate, loginID inLoginId: String! = nil, password inPassword: String! = nil, timeout inLoginTimeout: TimeInterval! = nil) {
        super.init()
        
        self._delegate = inDelegate
        
        // Store the items we hang onto.
        self._server_uri = inServerURI
        self._server_secret = inServerSecret
        
        // Set up our URL session.
        let configuration = URLSessionConfiguration.ephemeral
        configuration.waitsForConnectivity = true
        configuration.allowsCellularAccess = true
        self._connectionSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        // If any one of the optionals is provided, then they must ALL be provided.
        if nil != inLoginId || nil != inPassword || nil != inLoginTimeout {
            if nil == inLoginId || nil == inPassword || nil == inLoginTimeout {
                return
            }
            
            // If a login was provided, we attempt a login.
            _ = self.login(loginId: inLoginId, password: inPassword, timeout: inLoginTimeout)
        }
    }
    
    /* ################################################################## */
    /**
     */
    deinit {
    }
    
    /* ################################################################## */
    /**
     This is the standard login method.
     
     - parameter loginId: (REQUIRED) A String, with a login ID.
     - parameter password: (REQUIRED) A String, with a login password.
     - parameter timeout: (REQUIRED) A Floating-point value, with the number of seconds the login has to be active.
     
     - returns: true, if the login request was successful (NOTE: This is not a successful login. It merely indicates that the login was dispatched successfully).
     */
    public func login(loginId inLoginId: String, password inPassword: String, timeout inLoginTimeout: TimeInterval) -> Bool {
        var ret: Bool = false
        
        self._loginTimeout = inLoginTimeout // This is how long we'll have to be logged in, before the server kicks us out.
        self._loginTime = Date()    // Starting now.
        
        // The login is a simple GET task, so we can just use a straight-up task for this.
        if let login_id_object = inLoginId.urlEncodedString {
            if let password_object = inPassword.urlEncodedString {
                let url = self._server_uri + "/login?login_id=" + login_id_object + "&password=" + password_object
                if let url_object = URL(string: url) {
                    let loginTask = self._connectionSession.dataTask(with: url_object) { data, response, error in
                        if let error = error {
                            self._handleError(error)
                            return
                        }
                        guard let httpResponse = response as? HTTPURLResponse,
                            (200...299).contains(httpResponse.statusCode) else {
                                self._handleHTTPError(response)
                                return
                        }
                        if let mimeType = httpResponse.mimeType, mimeType == "text/html",
                            let data = data,
                            let apiKey = String(data: data, encoding: .utf8) {
                            self._apiKey = apiKey
                            
                            if nil != self._delegate {
                                self._delegate!.sdkInstance(self, loginValid: true)
                            }
                        }
                    }
                    
                    ret = true
                    
                    loginTask.resume()
                }
            }
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     */
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        #if DEBUG
        print(task.taskDescription ?? "ERROR")
        #endif
    }
}
