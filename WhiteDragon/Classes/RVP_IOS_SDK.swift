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
     This is called when the server has completed its login sequence, and all is considered OK.
     The server should not be considered "usable" until after this method has been called with true.
     */
    func sdkInstance(_: RVP_IOS_SDK, loginValid: Bool)
    
    /* ################################################################## */
    /**
     */
    func sdkInstance(_: RVP_IOS_SDK, sessionDisconnectedBecause: RVP_IOS_SDK.Disconnection_Reason)
    
    /* ################################################################## */
    /**
     */
    func sdkInstance(_: RVP_IOS_SDK, sessionError: Error)
}

/* ###################################################################################################################################### */
// MARK: - Main Library Interface Class -
/* ###################################################################################################################################### */
/**
 This class represents the public interface to the White Dragon Greate Rift Valley Platform BAOBAB Server iOS SDK framework.
 
 The SDK is a Swift-only shared framework for use by Swift applications, targeting iOS 10 or above.
 
 This system works by caching retrieved objects in the main SDK instance, and referencing them. This is different from the PHP SDK, where each object
 is an independent instance and state.
 */
public class RVP_IOS_SDK: NSObject, URLSessionTaskDelegate, Sequence {
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
    // MARK: Sequence Types
    /* ################################################################## */
    public typealias Element = A_RVP_IOS_SDK_Object
    
    /* ################################################################## */
    // MARK: Sequence Iterator Struct
    /* ################################################################## */
    /**
     We set this class up as a Sequence, so we can iterate over the saved data.
     */
    //: This is the iterator we'll use.
    public struct Iterator: IteratorProtocol {
        /** This is the captured list that we're iterating. */
        private let _iteratorList: [Element]
        /** This is the current item in that list. */
        private var _index: Int
        
        /* ############################################################## */
        /**
         The default initializer.
         
         - parameter _: The current list of instances at the time the iterator is created.
         */
        init(_ inCurrentState: [Element]) {
            self._iteratorList = inCurrentState
            self._index = 0
        }
        
        /* ############################################################## */
        /**
         Simple "next" iterator method.
         */
        mutating public func next() -> Element? {
            if self._index < self._iteratorList.count {
                let ret = self._iteratorList[self._index]
                
                self._index += 1
                
                return ret
            } else {
                return nil
            }
        }
    }

    /* ################################################################## */
    // MARK: Private Properties
    /* ################################################################## */
    /** This is an index used for iterating.. */
    private var _index: Int = 0
    
    /** This is an array of data instances. They are cached here. */
    private var _dataItems: [A_RVP_IOS_SDK_Object] = []
    
    /** This is the delegate object. This instance is pretty much useless without a delegate. */
    private var _delegate: RVP_IOS_SDK_Delegate?
    
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
    
    /** This is any login info we may have (if logged in). */
    private var _myLoginInfo: RVP_IOS_SDK_Login? = nil
    
    /** This is any user info we may have (if logged in). */
    private var _myUserInfo: RVP_IOS_SDK_User? = nil
    
    /** This is our login info. If we are logged in, this should always have something. */
    private var _loginInfo: RVP_IOS_SDK_Login? = nil
    
    /** This is our user info. If we are logged in, we might have something. */
    private var _userInfo: RVP_IOS_SDK_User? = nil

    /* ################################################################## */
    // MARK: Public Properties and Calculated Properties
    /* ################################################################## */
    /**
     This is a computed property that will return true if the login is valid.
     
     Logins only last so long, at which time a new API key should be fetched.
     
     - returns: true, if we are logged in, and the time interval has not passed.
    */
    var isLoggedIn: Bool {
        let logged_in_time = Date().timeIntervalSince(self._loginTime)
        return (nil != self._apiKey) && (nil != self._loginTimeout) && (self._loginTimeout! >= logged_in_time)
    }
    
    /* ################################################################## */
    /**
     - returns the number of data items in our cache.
     */
    var count: Int {
        return self._dataItems.count
    }
    
    /* ################################################################## */
    /**
     This allows the instance to be treated like a smple Array.
     
     - parameter _: The 0-based index we are addressing.
     
     - returns the indexed item. Nil, if the index is out of range.
     */
    subscript(_ inIndex: Int) -> Element? {
        if (0 <= inIndex) && (inIndex < self.count) {
            return self._dataItems[inIndex]
        }
        
        return nil
    }
    
    /* ################################################################## */
    // MARK: Private Instance Methods
    /* ################################################################## */
    /**
     This is a factory method for creating instances of data items.
     
     The goal of this function is to parse the returned data stream (JSON objects), and return one or more instances of
     concrete A_RVP_IOS_SDK_Object subclasses.
     
     I wanted to keep all the parsing in one big, ugly method, instead of delegating it, because I find that it is
     difficult to properly debug heavily-nested delegated parsers (the BMLTiOSLib uses delegated parsers, and tracing
     a parse is a brass-knuckled bitch).
     
     - parameter: data The Data item returned from the server.
     
     - returns: An array of new instances of concrete subclasses of A_RVP_IOS_SDK_Object.
     */
    private func _makeInstance (data inData: Data) -> [A_RVP_IOS_SDK_Object?] {
        var ret: [A_RVP_IOS_SDK_Object?] = []
        
        do {    // Extract a usable object from the given JSON data.
            let temp = try JSONSerialization.jsonObject(with: inData, options: [])
            
            if let main_object = temp as? NSDictionary {
                ret = self._makeInstancesFromDictionary(main_object)
            } else if let main_object = temp as? NSArray {
                ret = self._makeInstancesFromArray(main_object)
            }
        } catch {   // We end up here if the response is not a proper JSON object.
        }

        return ret
    }
    
    /* ################################################################## */
    /**
     */
    private func _parseBaselineDictionary (_ inDictionary: [String: Any]) -> [A_RVP_IOS_SDK_Object?] {
        let ret: [A_RVP_IOS_SDK_Object?] = []
        
        print(inDictionary)

        for (key, value) in inDictionary {
            switch key {
            case "plugins":
                break
                
            case "tokens":
                break
                
            case "people":
                break
                
            case "places":
                break
                
            case "things":
                break
                
            case "search_location":
                break
                
            case "serverinfo":
                break
                
            case "token":
                break
                
            case "id":
                break
                
            case "bulk_upload":
                break
                
            default:
                break
            }
        }

        return ret
    }

    /* ################################################################## */
    /**
     */
    private func _makeNewInstanceFromDictionary (_ inDictionary: [String: Any], parent inParent: String) -> A_RVP_IOS_SDK_Object? {
        var ret: A_RVP_IOS_SDK_Object? = nil
        
        if nil != inDictionary["login_id"] {    // We can easily determine whether or not this is a login. If so, we create a login object.
            ret = RVP_IOS_SDK_Login(sdkInstance: self, objectInfoData: inDictionary)
        } else {    // The login was low-hanging fruit. For the rest, we need to depend on the "parent" passed in.
            switch inParent {
            case "my_info", "people":
                ret = RVP_IOS_SDK_User(sdkInstance: self, objectInfoData: inDictionary)
                break
                
            case "places":
                ret = RVP_IOS_SDK_Place(sdkInstance: self, objectInfoData: inDictionary)
                break
                
            case "things":
                ret = RVP_IOS_SDK_Thing(sdkInstance: self, objectInfoData: inDictionary)
                break
                
            default:
                break
            }
        }
        
        if let print_run = ret {
            print(print_run.id)
            print(print_run.name)
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     */
    private func _makeInstancesFromDictionary (_ inDictionary: NSDictionary, parent inParent: String! = nil) -> [A_RVP_IOS_SDK_Object?] {
        var ret: [A_RVP_IOS_SDK_Object?] = []
        // First, see if we have a data item. If so, we simply go right to the factory.
        if nil != inParent, let _ = inDictionary.object(forKey: "id"), let _ = inDictionary.object(forKey: "name"), let _ = inDictionary.object(forKey: "lang"), let object_data = inDictionary as? [String: Any] {
            ret = [self._makeNewInstanceFromDictionary(object_data, parent: inParent)]
        } else if let baseline_value = inDictionary.object(forKey: "baseline") { // Baseline plugin has some different rules.
            if let cast_value = baseline_value as? [String: Any] {  // We cast into a simple Dictionary, then hand off to our parser function.
                ret = self._parseBaselineDictionary(cast_value)
            }
        } else { // Otherwise, we simply go down the rabbit-hole.
            for (key, value) in inDictionary {
                if let forced_key = key as? String {
                    if value is NSDictionary {
                        ret = [ret, self._makeInstancesFromDictionary(value as! NSDictionary, parent: forced_key)].flatMap { $0 }
                    } else if value is NSArray {
                        ret = [ret, self._makeInstancesFromArray(value as! NSArray, parent: forced_key)].flatMap { $0 }
                    }
                }
            }
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     */
    private func _makeInstancesFromArray (_ inArray: NSArray, parent inParent: String! = nil) -> [A_RVP_IOS_SDK_Object?] {
        var ret: [A_RVP_IOS_SDK_Object?] = []
        // With Arrays, we don't have pernt keys, so we use the one that was originally passed in.
        for value in inArray {
            if value is NSDictionary {
                ret = [ret, self._makeInstancesFromDictionary(value as! NSDictionary, parent: inParent)].flatMap { $0 }
            } else if value is NSArray {
                ret = [ret, self._makeInstancesFromArray(value as! NSArray, parent: inParent)].flatMap { $0 }
            }
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     */
    private func _handleError (_ inError: Error) {
        if nil != self._delegate {
            self._delegate!.sdkInstance(self, sessionError: inError)
        }
    }
    
    /* ################################################################## */
    /**
     */
    private func _handleHTTPError (_ inResponse: URLResponse?) {
        if nil != self._delegate {
            #if DEBUG
            print(inResponse ?? "ERROR")
            #endif
        }
    }

    /* ################################################################## */
    /**
     */
    private func _callDelegateServerValid (_ inIsValid: Bool) {
        #if DEBUG
        print("Server is" + (inIsValid ? "" : " not") + " valid.")
        #endif
        
        if let delegate = self._delegate {
            delegate.sdkInstance(self, loginValid: inIsValid)
        }
    }

    /* ################################################################## */
    /**
     */
    private func _getMyLoginInfo() {
        if self.isLoggedIn {
            if let secret = self._server_secret.urlEncodedString {
                if let apiKey = self._apiKey.urlEncodedString {
                    let url = self._server_uri + "/json/people/logins/my_info?login_server_secret=" + secret + "&login_api_key=" + apiKey
                    if let url_object = URL(string: url) {
                        let loginInfoTask = self._connectionSession.dataTask(with: url_object) { data, response, error in
                            if let error = error {
                                self._handleError(error)
                                return
                            }
                            guard let httpResponse = response as? HTTPURLResponse,
                                (200...299).contains(httpResponse.statusCode) else {
                                    self._handleHTTPError(response)
                                    return
                            }
                            if let mimeType = httpResponse.mimeType, mimeType == "application/json",
                                let data = data  {
                                if let object = self._makeInstance(data: data) as? [RVP_IOS_SDK_Login] {
                                    if 0 < object.count {
                                        self._loginInfo = object[0]
                                    }
                                }
                                self._getMyUserInfo()
                            }
                        }
                        
                        loginInfoTask.resume()
                    }
                }
            }
        }
    }

    /* ################################################################## */
    /**
     */
    private func _getMyUserInfo() {
        if self.isLoggedIn {
            if let secret = self._server_secret.urlEncodedString {
                if let apiKey = self._apiKey.urlEncodedString {
                    let url = self._server_uri + "/json/people/people/my_info?login_server_secret=" + secret + "&login_api_key=" + apiKey
                    if let url_object = URL(string: url) {
                        let userInfoTask = self._connectionSession.dataTask(with: url_object) { data, response, error in
                            if let error = error {
                                self._handleError(error)
                                return
                            }
                            guard let httpResponse = response as? HTTPURLResponse,
                                (200...299).contains(httpResponse.statusCode) || (400 == httpResponse.statusCode) else {
                                    self._handleHTTPError(response)
                                    return
                            }
                            if 400 == httpResponse.statusCode { // If we get nothing but a 400, we assume there is no user info, and go straight to completion.
                                self._callDelegateServerValid(true)
                            } else if let mimeType = httpResponse.mimeType, mimeType == "application/json",
                                let data = data {
                                if let object = self._makeInstance(data: data) as? [RVP_IOS_SDK_User] {
                                    if 0 < object.count {
                                        self._userInfo = object[0]
                                    }
                                }
                                self._callDelegateServerValid(true)
                            }
                        }
                        
                        userInfoTask.resume()
                    }
                }
            }
        }
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
            _ = self.login(loginID: inLoginId, password: inPassword, timeout: inLoginTimeout)
        }
    }
    
    /* ################################################################## */
    /**
     */
    deinit {
        if self.isLoggedIn {
            self.logout()
        }
    }
    
    /* ################################################################## */
    /**
     This is the standard login method.
     
     - parameter loginID: (REQUIRED) A String, with a login ID.
     - parameter password: (REQUIRED) A String, with a login password.
     - parameter timeout: (REQUIRED) A Floating-point value, with the number of seconds the login has to be active.
     
     - returns: true, if the login request was successful (NOTE: This is not a successful login. It merely indicates that the login was dispatched successfully).
     */
    public func login(loginID inLoginID: String, password inPassword: String, timeout inLoginTimeout: TimeInterval) -> Bool {
        var ret: Bool = false
        
        self._loginTimeout = inLoginTimeout // This is how long we'll have to be logged in, before the server kicks us out.
        self._loginTime = Date()    // Starting now.
        
        // The login is a simple GET task, so we can just use a straight-up task for this.
        if let login_id_object = inLoginID.urlEncodedString {
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
                            self._getMyLoginInfo()
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
    public func logout() {
        if let secret = self._server_secret.urlEncodedString {
            if let apiKey = self._apiKey.urlEncodedString {
                let url = self._server_uri + "/logout?login_server_secret=" + secret + "&login_api_key=" + apiKey
                if let url_object = URL(string: url) {
                    let logoutTask = self._connectionSession.dataTask(with: url_object) { data, response, error in
                        self._callDelegateServerValid(false)
                    }
                    
                    logoutTask.resume()
                }
            }
        }
    }

    /* ################################################################## */
    /**
     */
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        #if DEBUG
        print(task.taskDescription ?? "ERROR")
        #endif
    }
    
    /* ################################################################## */
    // MARK: Sequence Methods
    /* ################################################################## */
    /**
     */
    public func makeIterator() -> RVP_IOS_SDK.Iterator {
        return Iterator(self._dataItems)
    }
}
