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
public protocol RVP_IOS_SDK_Delegate {

    /** The following methods are required */
    
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, loginValid inLoginValid: Bool)
    
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, sessionDisconnectedBecause inReason: RVP_IOS_SDK.Disconnection_Reason)
    
    /* ################################################################## */
    /**
     */
    func sdkInstance(_ inSDKInstance: RVP_IOS_SDK, sessionError inError: Error)
}

/* ###################################################################################################################################### */
// MARK: - Main Library Interface Class -
/* ###################################################################################################################################### */
/**
 This class represents the public interface to the White Dragon Greate Rift Valley Platform BAOBAB Server iOS SDK framework.
 
 The SDK is a Swift-only shared framework for use by Swift applications, targeting iOS 10 or above.
 */
public class RVP_IOS_SDK: NSObject {
    /* ################################################################## */
    // MARK: Public Enums
    /* ################################################################## */
    /**
     This enum lists the various reasons that the server connection may be disconnected.
     
     These are supplied in the delegate method.
    */
    public enum Disconnection_Reason : Int {
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
    /** This is the URI to the server. */
    private var _server_uri: String = ""
    
    /** This is the server's sectret. */
    private var _server_secret: String = ""
    
    /** This is a simple Boolean operator that is set to true, if the instance is currently logged in. */
    private var _loggedIn: Bool = false
    
    /** If _loggedIn is true, then this must be non-nil, and is the time at which the login was made. */
    private var _loginTime: Date! = nil
    
    /** If _loggedIn is true, then this must be non-nil, and is the period of time the login is valid. */
    private var _loginTimeout: TimeInterval! = nil

    /** This is the connection session with the server. It is initiated at the time the class is instantiated, and destroyed when the class is torn down. */
    private var _connectionSession: URLSession! = nil
    
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
        return self._loggedIn && (nil != self._loginTimeout) && (self._loginTimeout! <= logged_in_time)
    }
    
    /* ################################################################## */
    // MARK: Internal Instance Methods
    /* ################################################################## */

    /* ################################################################## */
    // MARK: Public Instance Methods
    /* ################################################################## */
    /**
     This is the default initializer. This is required.
     
     - parameter serverURI: (REQUIRED) A String, with the URI to a valid BAOBAB Server
     - parameter serverSecret: (REQUIRED) A String, with the Server secret for the target server.
     - parameter loginId: (OPTIONAL) A String, with a login ID. If provided, then you must also provide inPassword and inLoginTimeout.
     - parameter password: (OPTIONAL) A String, with a login password. If provided, then you must also provide inLoginId and inLoginTimeout.
     - parameter timeout: (OPTIONAL) A Floating-point value, with the number of seconds the login has to be active. If provided, then you must also provide inLoginId and inPassword.
     */
    public init(serverURI inServerURI: String, serverSecret inServerSecret: String, loginID inLoginId: String! = nil, password inPassword: String! = nil, timeout inLoginTimeout: TimeInterval! = nil) {
        super.init()
        self._server_uri = inServerURI
        self._server_secret = inServerSecret
        
        // If any one of the optionals is provided, then they must ALL be provided.
        if ((nil != inLoginId) || (nil != inPassword) || (nil != inLoginTimeout)) {
            if ((nil == inLoginId) || (nil == inPassword) || (nil == inLoginTimeout)) {
                return
            }
            
            // Unsuccessful login is not good.
            if (!self.login(inLoginId: inLoginId, inPassword: inPassword, inLoginTimeout: inLoginTimeout)) {
                return
            }
        }
        
        // If we made it here, we either didn't login, or we sucessfully logged in.
    }
    
    /* ########################################################## */
    /**
     */
    deinit {
    }
    
    /* ########################################################## */
    /**
     This is the standard login method.
     
     - parameter inLoginId: (REQUIRED) A String, with a login ID.
     - parameter inPassword: (REQUIRED) A String, with a login password.
     - parameter inLoginTimeout: (REQUIRED) A Floating-point value, with the number of seconds the login has to be active.
     
     - returns: true, if the login was successful.
     */
    public func login(inLoginId: String, inPassword: String, inLoginTimeout: TimeInterval) -> Bool {
        var ret: Bool
        
        self._loginTimeout = inLoginTimeout
        self._loginTime = Date()
        
        ret = false
        
        return ret
    }
}
