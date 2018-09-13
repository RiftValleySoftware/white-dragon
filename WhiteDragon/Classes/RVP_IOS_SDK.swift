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
    // MARK: - REQUIRED METHODS
    /* ################################################################## */
    /**
     This is called when the server has completed its login sequence, and all is considered OK.
     The server should not be considered "usable" until after this method has been called with true.
     
     - parameter sdkInstance: This is the SDK instance making the call.
     - parameter liginValid: A Bool, true, if the SDK is currently logged in.
     */
    func sdkInstance(_: RVP_IOS_SDK, loginValid: Bool)
    
    /* ################################################################## */
    /**
     This is called when the SDK instance disconnects from the server.
     
     - parameter sdkInstance: This is the SDK instance making the call.
     - parameter sessionDisconnectedBecause: The reason for the disconnection.
     */
    func sdkInstance(_: RVP_IOS_SDK, sessionDisconnectedBecause: RVP_IOS_SDK.DisconnectionReason)
    
    /* ################################################################## */
    /**
     This is called when there is an error in the SDK instance.
     
     - parameter sdkInstance: This is the SDK instance making the call.
     - parameter sessionError: The error in question.
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
 
 This class follows the Sequence protocol, so it can be treated like an Array of data or security database instances. These instances are sorted by ID.
 */
public class RVP_IOS_SDK: NSObject, Sequence {
    /* ################################################################## */
    // MARK: - Private Properties
    /* ################################################################## */
    /** This is an array of data instances. They are cached here. */
    private var _dataItems: [A_RVP_IOS_SDK_Object] = []
    
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
    
    /** This is our login info. If we are logged in, this should always have something. */
    private var _loginInfo: RVP_IOS_SDK_Login?
    
    /** This is our user info. If we are logged in, we might have something, but not always. */
    private var _userInfo: RVP_IOS_SDK_User?

    /** This is our list of available plugins. It will be filled, regardless of login status. */
    private var _plugins: [String] = []
    
    /* ################################################################## */
    // MARK: - Private Instance Methods and Calculated Properties
    /* ################################################################## */
    /**
     Returns a String, with the server secret and API Key alreay in URI form.
     This should be appended to the URI, but be aware that it is not preceded by an ampersand (&).
     */
    private var _loginParameters: String {
        if let secret = self._server_secret.urlEncodedString {
            if let apiKey = self._apiKey.urlEncodedString {
                return "login_server_secret=" + secret + "&login_api_key=" + apiKey
            }
        }
        
        return ""
    }

    /* ################################################################## */
    /**
     This sorts our instance Array by ID.
     */
    private func _sortDataItems() {
        if !self.isEmpty {  // Nothing to do, if we have no items.
            self._dataItems = self._dataItems.sorted {
                var ret = $0.id < $1.id
                
                if !ret {   // Security objects get listed before data objects
                    ret = $0 is A_RVP_IOS_SDK_Security_Object && $1 is A_RVP_IOS_SDK_Data_Object
                }

                return ret
            }
        }
    }
    
    /* ################################################################## */
    /**
     This checks our Array of instances, looking for an item with the given database and ID.
     
     This is used to prevent multiple instances representing the same object in the server.
     
     - parameter inCompInstance: An instance of a subclass of A_RVP_IOS_SDK_Object, to be compared.
     
     - returns: The instance, if found. nil, otherwise.
     */
    private func _findDataItem(compInstance inCompInstance: A_RVP_IOS_SDK_Object) -> A_RVP_IOS_SDK_Object? {
        if !self.isEmpty {  // Nothing to do, if we have no items.
            for item in self where item.id == inCompInstance.id {
                // OK. The ID is unique in each database, so we check to see if an existing object and the given object are in the same database.
                if (item is A_RVP_IOS_SDK_Security_Object && inCompInstance is A_RVP_IOS_SDK_Security_Object) || (item is A_RVP_IOS_SDK_Data_Object && inCompInstance is A_RVP_IOS_SDK_Data_Object) {
                    return item // If so, we return the cached object.
                }
            }
        }
        
        return nil
    }
    
    /* ################################################################## */
    /**
     This is a factory method for creating instances of data items.
     
     The goal of this function is to parse the returned data stream (JSON objects), and return one or more instances of
     concrete A_RVP_IOS_SDK_Object subclasses.
     
     The standard plugins all return data that can be handled with a common hierarchy, so we sort out the data,
     and instantiate the appropriate subclass for the data.
     
     I wanted to keep all the parsing in a few big, ugly methods in one file, instead of delegating it, because I find that it is
     difficult to properly debug heavily-nested delegated parsers.
     
     - parameter data: The Data item returned from the server.
     
     - returns: An array of new instances of concrete subclasses of A_RVP_IOS_SDK_Object.
     */
    private func _makeInstance(data inData: Data) -> [A_RVP_IOS_SDK_Object?] {
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
     This is a factory method for creating baseline objects.
     
     The baseline plugin can produce a variety of objects, so it needs to be handled differently. These will not be cached.
     
     - parameter data: A Data object, with the JSON data (which will be parsed) returned from the server.
     
     - returns: A Dictionary ([String: Any]), with the resulting data.
     */
    private func _parseBaselineResponse(data inData: Data) -> [String: Any] {
        var ret: [String: Any] = [:]
        
        do {    // Extract a usable object from the given JSON data.
            let temp = try JSONSerialization.jsonObject(with: inData, options: [])
            
            // We will return different Dictionaries, dependent on which response we got.
            if let main_object = temp as? [String: Any] {
                if let baseline_response = main_object["baseline"] as? [String: Any] {
                    for (key, value) in baseline_response {
                        switch key {
                        case "people", "places", "things":
                            if let plugin_response = value as? [Int] {
                                ret = [key: plugin_response]
                            }
                            
                        case "plugins":
                            if let plugin_response = value as? [String] {
                                ret = [key: plugin_response]
                            }
                            
                        case "serverinfo", "search_location", "tokens", "bulk_upload", "token", "id":
                            if let plugin_response = value as? [String: Any] {
                                ret = [key: plugin_response]
                            }
                            
                        default:
                            break
                        }
                    }
                }
            }
        } catch {   // We end up here if the response is not a proper JSON object.
        }

        return ret
    }

    /* ################################################################## */
    /**
     This is a factory method that creates a new "leaf" instance (data item) from
     a given Dictionary.
     
     It is assumed that the given Dictionary contains the fields necessary to describe a
     standard data database or security database item. The Dictionary is first examined to
     see if it is a security database item. If not, then the passed-in "parent" string is
     required to determine the appropriate subclass.
     
     - parameter inDictionary: The Dictionary object with the item data.
     - parameter parent: A String, with the key for the "parent" container.
     
     - returns: A new subclass instance of A_RVP_IOS_SDK_Object, or nil.
     */
    private func _makeNewInstanceFromDictionary(_ inDictionary: [String: Any], parent inParent: String) -> A_RVP_IOS_SDK_Object? {
        var ret: A_RVP_IOS_SDK_Object?
        var instance: A_RVP_IOS_SDK_Object?

        if nil != inDictionary["login_id"] {    // We can easily determine whether or not this is a login. If so, we create a login object. This will be the only security database item.
            instance = RVP_IOS_SDK_Login(sdkInstance: self, objectInfoData: inDictionary)
        } else {    // The login was low-hanging fruit. For the rest, we need to depend on the "parent" passed in.
            switch inParent {
            case "my_info", "people":
                instance = RVP_IOS_SDK_User(sdkInstance: self, objectInfoData: inDictionary)
                
            case "places":
                instance = RVP_IOS_SDK_Place(sdkInstance: self, objectInfoData: inDictionary)
                
            case "things":
                instance = RVP_IOS_SDK_Thing(sdkInstance: self, objectInfoData: inDictionary)
                
            default:
                break
            }
        }
        
        // Assuming we got something, we compare the temporary allocation with what we have in our cache.
        if nil != instance {
            // If we already have this object, we return our cached instance, instead of the one we just allocated.
            if let existingInstance = self._findDataItem(compInstance: instance!) {
                ret = existingInstance
            } else {    // Otherwise, we add our new instance to the cache, sort the cache, and return the instance.
                self._dataItems.append(instance!)
                self._sortDataItems()
                ret = instance
            }
        }

        return ret
    }
    
    /* ################################################################## */
    /**
     This is a second-level "factory" method for creating subclasses of data
     returned from the JSON parser. It does a "quick triage" to determine
     whether or not to generate a "leaf" instance, or to recursively
     follow the Dictionary (which may have an Array).
     
     This "follows the breadcrumb trail" into the returned JSON, parsing Dictionaries
     or Arrays, as necessary. It will instantiate data items, and store them in an Array.
     
     - parameter inDictionary: The Dictionary object with the item data.
     - parameter parent: A String, with the key for the "parent" container.
     
     - returns: An Array of new subclass instances of A_RVP_IOS_SDK_Object.
     */
    private func _makeInstancesFromDictionary(_ inDictionary: NSDictionary, parent inParent: String! = nil) -> [A_RVP_IOS_SDK_Object?] {
        var ret: [A_RVP_IOS_SDK_Object?] = []
        // First, see if we have a data item. If so, we simply go right to the factory.
        if nil != inParent, nil != inDictionary.object(forKey: "id"), nil != inDictionary.object(forKey: "name"), nil != inDictionary.object(forKey: "lang"), let object_data = inDictionary as? [String: Any] {
            ret = [self._makeNewInstanceFromDictionary(object_data, parent: inParent)]
        } else { // Otherwise, we simply go down the rabbit-hole.
            for (key, value) in inDictionary {
                if let forced_key = key as? String {    // This will be the "parent" key for the next level down.
                    if let forced_value = value as? NSDictionary {  // See whether we go Dictionary or Array.
                        ret = [ret, self._makeInstancesFromDictionary(forced_value, parent: forced_key)].flatMap { $0 }   // The flatmap() method ensures that we merge the arrays "flat."
                    } else if let forced_value = value as? NSArray {
                        ret = [ret, self._makeInstancesFromArray(forced_value, parent: forced_key)].flatMap { $0 }
                    }
                }
            }
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     This is a factory method, much like _makeInstancesFromDictionary, but for
     Arrays, not Dictionaries.
     
     - parameter inArray: The Array object with the items' data.
     - parameter parent: A String, with the key for the "parent" container.
     
     - returns: An Array of new subclass instances of A_RVP_IOS_SDK_Object.
     */
    private func _makeInstancesFromArray(_ inArray: NSArray, parent inParent: String! = nil) -> [A_RVP_IOS_SDK_Object?] {
        var ret: [A_RVP_IOS_SDK_Object?] = []
        // With Arrays, we don't have parent keys, so we use the one that was originally passed in.
        for value in inArray {
            if let forced_value = value as? NSDictionary {
                ret = [ret, self._makeInstancesFromDictionary(forced_value, parent: inParent)].flatMap { $0 }
            } else if let forced_value = value as? NSArray {
                ret = [ret, self._makeInstancesFromArray(forced_value, parent: inParent)].flatMap { $0 }
            }
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     This is called to send any errors back to the delegate.
     
     - parameter inError: The error being handled.
     */
    private func _handleError(_ inError: Error) {
        #if DEBUG
        print(inError)
        #endif
        if nil != self._delegate {
            self._delegate!.sdkInstance(self, sessionError: inError)
        }
    }

    /* ################################################################## */
    /**
     This is called to handle an HTTP Status error. It will call the _handleError() method.
     
     - parameter inResponse: The HTTP Response object being handled.
     */
    private func _handleHTTPError(_ inResponse: HTTPURLResponse?) {
        #if DEBUG
        print("HTTP Error: \(String(describing: inResponse))")
        #endif
        
        if let response = inResponse {
            let error = HTTPError(code: response.statusCode, description: "")
            self._handleError(error)
        }
    }

    /* ################################################################## */
    /**
     This is called if we determine the server connection to be invalid.
     
     If the delegate is valid, we call it with a notice that the session disconnected because of an invalid server connection.
     */
    private func _handleInvalidServer() {
        #if DEBUG
        print("Invalid Server!")
        #endif
        if nil != self._delegate {
            self._delegate!.sdkInstance(self, sessionDisconnectedBecause: RVP_IOS_SDK.DisconnectionReason.ServerConnectionInvalid)
        }
    }

    /* ################################################################## */
    /**
     This is called after the server responds to a login or logout (in the case of a login, a lot of other stuff happens, as well).
     
     If the delegate is valid, we call it with a report of the current SDK instance login status.
     
     - parameter isLoggedIn: This is true, if the instance is currently logged into the server.
     */
    private func _callDelegateLoginValid(_ inIsLoggedIn: Bool) {
        #if DEBUG
        print("Server is" + (inIsLoggedIn ? "" : " not") + " logged in.")
        #endif
        
        if let delegate = self._delegate {
            delegate.sdkInstance(self, loginValid: inIsLoggedIn)
        }
    }

    /* ################################################################## */
    /**
     This is to be called after a successful API Key fetch (login).
     
     We ask the server to send us our login object information.
     
     When we get the information, we parse it, create a new instance of the handler class
     and cache that instance.
     */
    private func _getMyLoginInfo() {
        if self.isLoggedIn {
            let url = self._server_uri + "/json/people/logins/my_info?" + self._loginParameters
            if let url_object = URL(string: url) {
                // We handle the response in the closure.
                let loginInfoTask = self._connectionSession.dataTask(with: url_object) { data, response, error in
                    if let error = error {
                        self._handleError(error)
                        return
                    }
                    guard let httpResponse = response as? HTTPURLResponse,
                        (200...299).contains(httpResponse.statusCode) else {
                            self._handleHTTPError(response as? HTTPURLResponse ?? nil)
                            return
                    }
                    if let mimeType = httpResponse.mimeType, mimeType == "application/json",
                        let data = data {
                        if let object = self._makeInstance(data: data) as? [RVP_IOS_SDK_Login] {
                            if 1 == object.count {
                                self._loginInfo = object[0]
                                // Assuming all went well, we ask for any user information.
                                self._getMyUserInfo()
                            } else {
                                
                            }
                        }
                    }
                }
                
                loginInfoTask.resume()
            }
        }
    }

    /* ################################################################## */
    /**
     This is to be called after a successful API Key fetch (login) and a successful login info fetch.
     
     We ask the server to send us our user (data database) object information.
     
     When we get the information, we parse it, create a new instance of the handler class
     and cache that instance.
     */
    private func _getMyUserInfo() {
        if self.isLoggedIn {
            let url = self._server_uri + "/json/people/people/my_info?" + self._loginParameters
            if let url_object = URL(string: url) {
                let userInfoTask = self._connectionSession.dataTask(with: url_object) { data, response, error in
                    if let error = error {
                        self._handleError(error)
                        return
                    }
                    guard let httpResponse = response as? HTTPURLResponse,
                        (200...299).contains(httpResponse.statusCode) || (400 == httpResponse.statusCode) else {
                            self._handleHTTPError(response as? HTTPURLResponse ?? nil)
                            return
                    }
                    if 400 == httpResponse.statusCode { // If we get nothing but a 400, we assume there is no user info, and go straight to completion.
                        self._getBaselinePlugins()
                    } else if let mimeType = httpResponse.mimeType, mimeType == "application/json",
                        let data = data {
                        if let object = self._makeInstance(data: data) as? [RVP_IOS_SDK_User] {
                            if 1 == object.count {
                                self._userInfo = object[0]
                                self._getBaselinePlugins()
                            } else {
                                self._getBaselinePlugins()
                            }
                        }
                    }
                }
                
                userInfoTask.resume()
            }
        }
    }
    
    /* ################################################################## */
    /**
     This method fetches the plugin array from the server. This is used as a "validity" test. A valid server will always return this list.
     */
    private func _getBaselinePlugins() {
        let url = self._server_uri + "/json/baseline"
        if let url_object = URL(string: url) {
            let baselineTask = self._connectionSession.dataTask(with: url_object) { data, response, error in
                if let error = error {
                    self._handleError(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                        self._handleHTTPError(response as? HTTPURLResponse ?? nil)
                        return
                }
                if let mimeType = httpResponse.mimeType, mimeType == "application/json",
                    let data = data {
                    if let plugins = self._parseBaselineResponse(data: data) as? [String: [String]] {
                        if let plugin_array = plugins["plugins"] {
                            self._plugins = plugin_array
                            self._callDelegateLoginValid(self.isLoggedIn)   // OK. We're done. Tell the delegate whether or not we are logged in.
                        }
                    }
                }
            }
            
            baselineTask.resume()
        }
    }
    
    /* ################################################################## */
    // MARK: - Public Sequence Types
    /* ################################################################## */
    /** This is the element type for the Sequence protocol. */
    public typealias Element = A_RVP_IOS_SDK_Object
    
    /* ################################################################## */
    // MARK: - Public Enums
    /* ################################################################## */
    /**
     This enum lists the various reasons that the server connection may be disconnected.
     
     These are supplied in the delegate method.
     */
    public enum DisconnectionReason: Int {
        /** Unkown reason. */
        case Unknown = 0
        /** The connection period has completed. */
        case Timeout = 1
        /** The server initiated the disconnection. */
        case ServerDisconnected = 2
        /** The client initiated the disconnection. */
        case ClientDisconnected = 3
        /** The server connection cannot be established. */
        case ServerConnectionInvalid = 4
    }
    
    /* ################################################################## */
    // MARK: - Public Properties and Calculated Properties
    /* ################################################################## */
    /**
     This is a computed property that will return true if the login is valid.
     
     Logins only last so long, at which time a new API key should be fetched.
     
     Returns true, if we are logged in, and the time interval has not passed.
     */
    var isLoggedIn: Bool {
        if nil != self._loginTime && nil != self._apiKey && nil != self._loginTimeout { // If we don't have a login time or API Key, then we're def not logged in.
            let logged_in_time: TimeInterval = Date().timeIntervalSince(self._loginTime)    // See if we are still in the login window.
            return self._loginTimeout! >= logged_in_time
        }
        
        return false
    }
    
    /* ################################################################## */
    /**
     This is a computed property that will return true if the server connection is valid (regardless of login status).
     
     NOTE: This will not be valid until after the preliminary communications have completed (the delegate has been called with sdkInstance(_:,loginValid:)).
     
     Returns true, if we have a list of plugins, which means that we were able to communicate with the server.
     */
    var isValid: Bool {
        return !self._plugins.isEmpty
    }
    
    /* ################################################################## */
    /**
     Returns the number of data items in our cache.
     */
    var count: Int {
        return self._dataItems.count
    }
    
    /* ################################################################## */
    /**
     Returns true, if we have no items in our cache.
     */
    var isEmpty: Bool {
        return self._dataItems.isEmpty
    }
    
    /* ################################################################## */
    /**
     This allows the instance to be treated like a simple Array.
     
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
    // MARK: - Public Class Structs
    /* ################################################################## */
    /**
     This is a quick resolver for the basic HTTP status.
     */
    public struct HTTPError: Error {
        /** This is the HTTP response code for this error. */
        var code: Int
        /** This is an optional description string that can be added when instantiated. If it is given, then it will be returned in the response. */
        var description: String?
        
        /* ############################################################## */
        /**
         - returns: A localized description for the instance HTTP code.
         */
        var localizedDescription: String {
            if let desc = self.description {    // An explicitly-defined string has precedence.
                return String(self.code) + ", " + desc
            } else {    // Otherwise, use the system-localized version.
                return String(self.code) + ", " + HTTPURLResponse.localizedString(forStatusCode: self.code)
            }
        }
    }
    
    /* ################################################################## */
    // MARK: - Public Sequence Iterator Struct
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
    // MARK: - Public Instance Methods
    /* ################################################################## */
    /**
     This is the required default initializer.
     
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
        self._connectionSession = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        
        // If any one of the optionals is provided, then they must ALL be provided.
        if nil != inLoginId || nil != inPassword || nil != inLoginTimeout {
            if nil == inLoginId || nil == inPassword || nil == inLoginTimeout {
                return
            }
            
            // If a login was provided, we attempt a login.
            self.login(loginID: inLoginId, password: inPassword, timeout: inLoginTimeout)
        } else {    // Otherwise, simply fetch the baseline plugins, which will result in the delegate being called.
            self._getBaselinePlugins()
        }
    }
    
    /* ################################################################## */
    /**
     We simply make sure that we clean up after ourselves.
     */
    deinit {
        self.logout()
    }

    /* ################################################################## */
    /**
     This is the standard login method.
     
     When we log in, we go through the process of getting the API key (sending the login info), then getting our login information, our user information (if available), and the baseline plugins.
     
     After all that, the delegate will be called with the login valid/invalid response.
     
     - parameter loginID: (REQUIRED) A String, with a login ID.
     - parameter password: (REQUIRED) A String, with a login password.
     - parameter timeout: (REQUIRED) A Floating-point value, with the number of seconds the login has to be active.
     */
    public func login(loginID inLoginID: String, password inPassword: String, timeout inLoginTimeout: TimeInterval) {
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
                                self._handleHTTPError(response as? HTTPURLResponse ?? nil)
                                return
                        }
                        if let mimeType = httpResponse.mimeType, mimeType == "text/html",
                            let data = data,
                            let apiKey = String(data: data, encoding: .utf8) {
                            self._apiKey = apiKey
                            self._getMyLoginInfo()
                        }
                    }
                    
                    loginTask.resume()
                }
            }
        }
    }

    /* ################################################################## */
    /**
     This is the logout method.
     
     You must already be logged in for this to do anything. If so, it simply asks the server to log us out.
     */
    public func logout() {
        if self.isLoggedIn {
            let url = self._server_uri + "/logout?" + self._loginParameters
            if let url_object = URL(string: url) {
                let logoutTask = self._connectionSession.dataTask(with: url_object) { _, _, _ in
                    self._callDelegateLoginValid(false)
                }
                
                logoutTask.resume()
            }
        }
    }
    
    /* ################################################################## */
    // MARK: - Sequence Methods
    /* ################################################################## */
    /**
     - returns: a new iterator for the instance.
     */
    public func makeIterator() -> RVP_IOS_SDK.Iterator {
        return Iterator(self._dataItems)
    }
}
