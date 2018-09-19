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
 This protocol needs to be applied to any class that will use the SDK. The SDK requires a delegate.
 */
public protocol RVP_IOS_SDK_Delegate: class {
    /* ################################################################## */
    // MARK: - REQUIRED METHODS
    /* ################################################################## */
    /**
     This is called when a server session (not login) is started or ended.
     If the connection was invalidated, then sessionDisconnectedBecause will also be called after this.
     
     - parameter sdkInstance: This is the SDK instance making the call.
     - parameter sessionConnectionIsValid: A Bool, true, if the SDK is currently in a valid session with a server.
     */
    func sdkInstance(_: RVP_IOS_SDK, sessionConnectionIsValid: Bool)
    
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
    
    /* ################################################################## */
    /**
     This is called with one or more data items. Each item is a single object.
     
     - parameter sdkInstance: This is the SDK instance making the call.
     - parameter fetchedDataItems: An array of subclasses of A_RVP_IOS_SDK_Object.
     */
    func sdkInstance(_: RVP_IOS_SDK, fetchedDataItems: [A_RVP_IOS_SDK_Object])
}

/* ###################################################################################################################################### */
// MARK: - Main Library Interface Class -
/* ###################################################################################################################################### */
/**
 This class represents the public interface to the White Dragon Greate Rift Valley Platform BAOBAB Server iOS SDK framework.
 
 The SDK is a Swift-only shared framework for use by Swift applications, targeting iOS 10 or above.
 
 This system works by caching retrieved objects in the main SDK instance, and referencing them. This is different from the PHP SDK, where each object is an
 independent instance and state. Swift likes objects to be referenced, as opposed to copied, so we honor that. Since the SDK is really an ORM, this makes sense.
 
 This class follows the Sequence protocol, so its cached instances can be iterated and subscripted. These instances are kept sorted by ID and database.
 
 The SDK opens a session to the server upon instantiation, and maintains that throughout its lifecycle. This happens whether or not a login is done.
 */
public class RVP_IOS_SDK: NSObject, Sequence, URLSessionDelegate {
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
            if let apiKey = self._apiKey?.urlEncodedString {
                return "login_server_secret=" + secret + "&login_api_key=" + apiKey
            }
        }
        
        return ""
    }

    /* ################################################################## */
    /**
     This sorts our instance Array by ID and database.
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
            self._handleError(SDK_Data_Errors.invalidData(inData))
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
                            self._handleError(SDK_Data_Errors.invalidData(inData))
                        }
                    }
                } else {
                    self._handleError(SDK_Data_Errors.invalidData(inData))
                }
            } else {
                self._handleError(SDK_Data_Errors.invalidData(inData))
            }
        } catch {   // We end up here if the response is not a proper JSON object.
            self._handleError(SDK_Data_Errors.invalidData(inData))
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
                let data: Data = NSKeyedArchiver.archivedData(withRootObject: inDictionary)
                self._handleError(SDK_Data_Errors.invalidData(data))
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
                } else {
                    let data: Data = NSKeyedArchiver.archivedData(withRootObject: inDictionary)
                    self._handleError(SDK_Data_Errors.invalidData(data))
                    break
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
            } else {
                let data: Data = NSKeyedArchiver.archivedData(withRootObject: inArray)
                self._handleError(SDK_Data_Errors.invalidData(data))
                break
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
        if let response = inResponse {
            let error = HTTPError(code: response.statusCode, description: "")
            self._handleError(error)
        }
    }

    /* ################################################################## */
    /**
     This is called to state the status of our session.
     
     If the delegate is valid, we call it with a notice that the session disconnected because of an invalid server connection.
     */
    private func _reportSessionValidity() {
        if nil != self._delegate {
            self._delegate!.sdkInstance(self, sessionConnectionIsValid: self.isValid)
        }
    }

    /* ################################################################## */
    /**
     This is called with a list of one or more data items to be sent to the delegate.
     
     - parameter inItemArray: An Array of concrete instances of subclasses of A_RVP_IOS_SDK_Object.
     */
    private func _sendItemsToDelegate(_ inItemArray: [A_RVP_IOS_SDK_Object]) {
        if nil != self._delegate {
            self._delegate!.sdkInstance(self, fetchedDataItems: inItemArray)
        }
    }

    /* ################################################################## */
    /**
     This is called if we determine the server connection to be invalid.
     
     If the delegate is valid, we call it with a notice that the session disconnected because of an invalid server connection.
     */
    private func _handleInvalidServer() {
        if nil != self._delegate {
            self._delegate!.sdkInstance(self, sessionDisconnectedBecause: RVP_IOS_SDK.DisconnectionReason.serverConnectionInvalid)
        }
    }

    /* ################################################################## */
    /**
     This is called after the server responds to a login or logout (in the case of a login, a lot of other stuff happens, as well).
     
     If the delegate is valid, we call it with a report of the current SDK instance login status.
     
     - parameter isLoggedIn: This is true, if the instance is currently logged into the server.
     */
    private func _callDelegateLoginValid(_ inIsLoggedIn: Bool) {
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
            // The my info request is a simple GET task, so we can just use a straight-up task for this.
            let url = self._server_uri + "/json/people/logins/my_info?" + self._loginParameters
            if let url_object = URL(string: url) {
                // We handle the response in the closure.
                let loginInfoTask = self._connectionSession.dataTask(with: url_object) { [unowned self] data, response, error in
                    if let error = error {
                        self._handleError(error)
                        return
                    }
                    guard let httpResponse = response as? HTTPURLResponse,
                        (200...299).contains(httpResponse.statusCode) else {
                            self._handleHTTPError(response as? HTTPURLResponse ?? nil)
                            return
                    }
                    if let mimeType = httpResponse.mimeType, mimeType == "application/json", let data = data {
                        if let object = self._makeInstance(data: data) as? [RVP_IOS_SDK_Login] {
                            if 1 == object.count {
                                self._loginInfo = object[0]
                                // Assuming all went well, we ask for any user information.
                                self._getMyUserInfo()
                            } else {
                                self._handleError(SDK_Data_Errors.invalidData(data))
                            }
                        }
                    } else {
                        self._handleError(SDK_Data_Errors.invalidData(data))
                    }
                }
                
                loginInfoTask.resume()
            } else {
                self._handleError(SDK_Connection_Errors.invalidServerURI(url))
            }
        }
    }

    /* ################################################################## */
    /**
     This is to be called after a successful API Key fetch (login) and a successful login info fetch.
     
     We ask the server to send us our user (data database) object information.
     
     When we get the information, we parse it, create a new instance of the handler class, and cache that instance.
     */
    private func _getMyUserInfo() {
        if self.isLoggedIn {
            let url = self._server_uri + "/json/people/people/my_info?" + self._loginParameters
            // The my info request is a simple GET task, so we can just use a straight-up task for this.
            if let url_object = URL(string: url) {
                let userInfoTask = self._connectionSession.dataTask(with: url_object) { [unowned self] data, response, error in
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
                        if self._plugins.isEmpty {
                            self._getBaselinePlugins()
                        } else {
                            self._reportSessionValidity()   // We report whether or not this session is valid.
                            self._callDelegateLoginValid(self.isLoggedIn)   // OK. We're done. Tell the delegate whether or not we are logged in.
                        }
                    } else if let mimeType = httpResponse.mimeType, mimeType == "application/json", let data = data {
                        if let object = self._makeInstance(data: data) as? [RVP_IOS_SDK_User] {
                            if 1 == object.count {
                                self._userInfo = object[0]
                                if self._plugins.isEmpty {
                                    self._getBaselinePlugins()
                                } else {
                                    self._reportSessionValidity()   // We report whether or not this session is valid.
                                    self._callDelegateLoginValid(self.isLoggedIn)   // OK. We're done. Tell the delegate whether or not we are logged in.
                                }
                            } else {
                                if self._plugins.isEmpty {
                                    self._getBaselinePlugins()
                                } else {
                                    self._reportSessionValidity()   // We report whether or not this session is valid.
                                    self._callDelegateLoginValid(self.isLoggedIn)   // OK. We're done. Tell the delegate whether or not we are logged in.
                                }
                            }
                        }
                    } else {
                        self._handleError(SDK_Data_Errors.invalidData(data))
                    }
                }
                
                userInfoTask.resume()
            } else {
                self._handleError(SDK_Connection_Errors.invalidServerURI(url))
            }
        }
    }

    /* ################################################################## */
    /**
     This fetches user objects from the server.
     
     - parameter inIntegerUserIDs: An Array of Int, with the user IDs.
     */
    private func _getUserInfo(_ inIntegerUserIDs: [Int]) {
        var fetchUserIDs: [Int] = []
        var cachedUserObjects: [RVP_IOS_SDK_User] = []
        
        // First, we look for cached instances. If we have them, we send them to the delegate.
        for id in inIntegerUserIDs {
            var needMore: Bool = true
            
            for dataItem in self._dataItems {   // See if we already have this user. If so, we immediately fetch it.
                if let dataItem = dataItem as? RVP_IOS_SDK_User, dataItem.id == id {
                    cachedUserObjects.append(dataItem)
                    needMore = false
                    break
                }
            }
            
            if needMore { // We'll need to fetch this one.
                fetchUserIDs.append(id)
            }
        }
        
        if !cachedUserObjects.isEmpty {
            self._sendItemsToDelegate(cachedUserObjects)   // We just send our cached items to the delegate right away.
        }
        
        if !fetchUserIDs.isEmpty {  // If we didn't find everything we were looking for in the junk drawer, we will be asking the server for the remainder.
            fetchUserIDs = fetchUserIDs.sorted()    // Just because we're anal...
            var loginParams = self._loginParameters
            
            if !loginParams.isEmpty {
                loginParams = "&" + loginParams
            }
            
            let url = self._server_uri + "/json/people/people/" + (fetchUserIDs.map(String.init)).joined(separator: ",") + "?show_details" + loginParams   // We will be asking for the "full Monty".
            // The request is a simple GET task, so we can just use a straight-up task for this.
            if let url_object = URL(string: url) {
                let userInfoTask = self._connectionSession.dataTask(with: url_object) { [unowned self] data, response, error in
                    if let error = error {
                        self._handleError(error)
                        return
                    }
                    guard let httpResponse = response as? HTTPURLResponse,
                        (200...299).contains(httpResponse.statusCode) else {
                            self._handleHTTPError(response as? HTTPURLResponse ?? nil)
                            return
                    }
                    
                    if let mimeType = httpResponse.mimeType, mimeType == "application/json", let data = data {
                        if let objectArray = self._makeInstance(data: data) as? [RVP_IOS_SDK_User] {
                            self._dataItems.append(contentsOf: objectArray)
                            self._sortDataItems()
                            self._sendItemsToDelegate(objectArray)
                        }
                    } else {
                        self._handleError(SDK_Data_Errors.invalidData(data))
                    }
                }
                
                userInfoTask.resume()
            } else {
                self._handleError(SDK_Connection_Errors.invalidServerURI(url))
            }
        }
    }

    /* ################################################################## */
    /**
     This method fetches the plugin array from the server. This is used as a "validity" test.
     A valid server will always return this list, and you don't need to be logged in.
     */
    private func _getBaselinePlugins() {
        let url = self._server_uri + "/json/baseline"
        // The plugin list is a simple GET task, so we can just use a straight-up task for this.
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
                if let mimeType = httpResponse.mimeType, mimeType == "application/json", let data = data {
                    if let plugins = self._parseBaselineResponse(data: data) as? [String: [String]] {
                        if let plugin_array = plugins["plugins"] {
                            self._plugins = plugin_array
                            self._reportSessionValidity()   // We report whether or not this session is valid.
                            self._callDelegateLoginValid(self.isLoggedIn)   // OK. We're done. Tell the delegate whether or not we are logged in.
                        }
                    }
                } else {
                    self._handleError(SDK_Data_Errors.invalidData(data))
                }
            }
            
            baselineTask.resume()
        } else {
            self._handleError(SDK_Connection_Errors.invalidServerURI(url))
        }
    }
    
    /* ################################################################## */
    // MARK: - Public Types
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
        case unknown = 0
        /** The connection period has completed. */
        case timeout = 1
        /** The server initiated the disconnection. */
        case serverDisconnected = 2
        /** The client initiated the disconnection. */
        case clientDisconnected = 3
        /** The server connection cannot be established. */
        case serverConnectionInvalid = 4
    }

    /* ################################################################## */
    /**
     These are the errors that may occur when we are trying to connect to the server.
     */
    public enum SDK_Connection_Errors: Error {
        /** Unkown error. The Int contains any associated error code. */
        case unknown(Int)
        /** The server URI is not valid. The String contains the invalid URI. */
        case invalidServerURI(String)
        /** The URI is valid, but the server is not. The string contains the URI. */
        case invalidServer(String)
    }

    /* ################################################################## */
    /**
     These are the errors that may occur while we are trying to parse the data returned from the server.
     */
    public enum SDK_Data_Errors: Error {
        /** Unkown error. The Int contains any associated error code. */
        case unknown(Int)
        /** The data is not there, or in an unexpected format. The Data may contain the unexpected data. */
        case invalidData(Data?)
    }

    /* ################################################################## */
    /**
     These are errors in the SDK operation.
     */
    public enum SDK_Operation_Errors: Error {
        /** Unkown error. The Int contains any associated error code. */
        case unknown(Int)
        /** Invalid Parameters Provided. */
        case invalidParameters
    }

    /* ################################################################## */
    /**
     These are supplied in the delegate method.
     */
    public enum SDK_Error {
        /** Unkown error. The associated value is any Error that was supplied. */
        case unknown(_: Error?)
        /** There was an error in the connection between the SDK and the server. */
        case connectionError(_: SDK_Connection_Errors)
        /** There was a problem with the data that was transferred from the server to the SDK. */
        case dataError(_: SDK_Data_Errors)
        /** There was a problem in the operation of the SDK. */
        case operationalError(_: SDK_Operation_Errors)
    }

    /* ################################################################## */
    // MARK: - Public Calculated Properties
    /* ################################################################## */
    /**
     This is a computed property that will return true if the login is valid.
     
     Logins only last so long, at which time a new API key should be fetched.
     
     Returns true, if we are logged in, and the time interval has not passed.
     */
    public var isLoggedIn: Bool {
        if nil != self._loginTime && nil != self._apiKey && nil != self._loginTimeout { // If we don't have a login time or API Key, then we're def not logged in.
            let logged_in_time: TimeInterval = Date().timeIntervalSince(self._loginTime)    // See if we are still in the login window.
            return self._loginTimeout! >= logged_in_time
        }
        
        return false
    }
    
    /* ################################################################## */
    /**
     This is a test to see if the currently logged-in user is a manager.
     
     Returns true, if we are logged in as at least a manager user.
     */
    public var isManager: Bool {
        if self.isLoggedIn, let myLoginInfo = self.myLoginInfo, myLoginInfo.isManager {
            return true
        }
        
        return false
    }
    
    /* ################################################################## */
    /**
     This is a test to see if the currently logged-in user is a manager.
     
     Returns true, if we are logged in as the main ("God") user.
     */
    public var isMainAdmin: Bool {
        if self.isLoggedIn, let myLoginInfo = self.myLoginInfo, myLoginInfo.isMainAdmin {
            return true
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
     Returns an Array of Int, with the current tokens. If logged in, then this will be at least 1, and the current ID of the login. If not logged in, this will return an empty Array.
     */
    var securityTokens: [Int] {
        var ret: [Int] = []
        
        if self.isLoggedIn, let myInfo = self.myLoginInfo {
            ret = myInfo.securityTokens
        }
        
        return ret
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
     Returns the Array of plugins (if the SDK is connected to a valid server).
     */
    var plugins: [String] {
        return self._plugins
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
    // MARK: - Public Structs
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
    /**
     This is the Sequence Iterator Struct.
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
         
         - parameter inCurrentState: The current list of instances at the time the iterator is created. Since this is a struct, the Array is copied.
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
    // MARK: - Internal Instance Methods
    /* ################################################################## */
    /**
     We simply make sure that we clean up after ourselves.
     */
    deinit {
        self.logout()
        self._connectionSession.finishTasksAndInvalidate()   // Take off and nuke the site from orbit. It's the only way to be sure.
        self._connectionSession = nil
    }
    
    /* ################################################################## */
    // MARK: - Internal URLSessionDelegate Protocol Methods
    /* ################################################################## */
    /**
     This is called when the the session becomes invalid for any reason.
     
     - parameter session: The session calling this.
     - parameter didBecomeInvalidWithError: The error (if any) that caused the invalidation.
     */
    internal func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        self._plugins = []  // This makes the session invalid.
        if let error = error {  // If there was an error, we report it first.
            self._handleError(error)
        }
        self._reportSessionValidity()   // Report the invalid session.
    }
    
    /* ################################################################## */
    // MARK: - Public Properties and Calculated Properties
    /* ################################################################## */
    /**
     This is the login info for our current login. Returns nil, if not logged in.
     */
    public var myLoginInfo: RVP_IOS_SDK_Login? {
        return self._loginInfo
    }
    
    /* ################################################################## */
    /**
     This is the user info for our current login. Returns nil, if not logged in, or we don't have any user info associated with the login.
     */
    public var myUserInfo: RVP_IOS_SDK_User? {
        return self._userInfo
    }

    /* ################################################################## */
    // MARK: - Public Instance Methods
    /* ################################################################## */
    /**
     This is the required default initializer.
     
     - parameter serverURI: (REQUIRED) A String, with the URI to a valid BAOBAB Server
     - parameter serverSecret: (REQUIRED) A String, with the Server secret for the target server.
     - parameter delegate: (REQUIRED) A RVP_IOS_SDK_Delegate that will receive updates from the SDK instance.
     - parameter loginID: (OPTIONAL) A String, with a login ID. If provided, then you must also provide inPassword and inLoginTimeout.
     - parameter password: (OPTIONAL) A String, with a login password. If provided, then you must also provide inLoginId and inLoginTimeout.
     - parameter timeout: (OPTIONAL) A Floating-point value, with the number of seconds the login has to be active. If provided, then you must also provide inLoginId and inPassword.
     */
    public init(serverURI inServerURI: String, serverSecret inServerSecret: String, delegate inDelegate: RVP_IOS_SDK_Delegate, loginID inLoginID: String! = nil, password inPassword: String! = nil, timeout inLoginTimeout: TimeInterval! = nil) {
        super.init()
        
        self._delegate = inDelegate
        
        // Store the items we hang onto.
        self._server_uri = inServerURI
        self._server_secret = inServerSecret
        
        // Set up our URL session.
        let configuration = URLSessionConfiguration.ephemeral
        self._connectionSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        self.connect(loginID: inLoginID, password: inPassword, timeout: inLoginTimeout)
    }
    
    /* ################################################################## */
    /**
     This will connect to the server. If login credentials are provided, then it will also log in.
     
     - parameter loginId: (OPTIONAL) A String, with a login ID. If provided, then you must also provide inPassword and inLoginTimeout.
     - parameter password: (OPTIONAL) A String, with a login password. If provided, then you must also provide inLoginId and inLoginTimeout.
     - parameter timeout: (OPTIONAL) A Floating-point value, with the number of seconds the login has to be active. If provided, then you must also provide inLoginId and inPassword.
     */
    public func connect(loginID inLoginId: String! = nil, password inPassword: String! = nil, timeout inLoginTimeout: TimeInterval! = nil) {
        // If any one of the optionals is provided, then they must ALL be provided.
        if nil != inLoginId || nil != inPassword || nil != inLoginTimeout {
            if nil == inLoginId || nil == inPassword || nil == inLoginTimeout {
                self._handleError(SDK_Operation_Errors.invalidParameters)
                return
            }
            
            // If a login was provided, we attempt a login.
            self.login(loginID: inLoginId, password: inPassword, timeout: inLoginTimeout)
        } else {    // Otherwise, simply fetch the baseline plugins, which will result in the delegate being called.
            if self._plugins.isEmpty {
                self._getBaselinePlugins()
            } else {
                self._reportSessionValidity()   // We report whether or not this session is valid.
                self._callDelegateLoginValid(self.isLoggedIn)   // OK. We're done. Tell the delegate whether or not we are logged in.
            }
        }
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
                        if let mimeType = httpResponse.mimeType, mimeType == "text/html", let data = data, let apiKey = String(data: data, encoding: .utf8) {
                            self._apiKey = apiKey
                            self._getMyLoginInfo()
                        } else {
                            self._handleError(SDK_Data_Errors.invalidData(data))
                        }
                    }
                    
                    self._dataItems = []    // We nuke the cache when we log in.
                    loginTask.resume()
                } else {
                    self._handleError(SDK_Connection_Errors.invalidServerURI(url))
                }
            } else {
                self._handleError(SDK_Operation_Errors.invalidParameters)
            }
        } else {
            self._handleError(SDK_Operation_Errors.invalidParameters)
        }
    }

    /* ################################################################## */
    /**
     This is the logout method.
     
     You must already be logged in for this to do anything. If so, it simply asks the server to log us out.
     */
    public func logout() {
        if self.isLoggedIn {
            // The logout is a simple GET task, so we can just use a straight-up task for this.
            let url = self._server_uri + "/logout?" + self._loginParameters
            if let url_object = URL(string: url) {
                let logoutTask = self._connectionSession.dataTask(with: url_object) { [unowned self] _, response, error in
                    if let error = error {
                        self._handleError(error)
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse, 205 == httpResponse.statusCode
                        else {
                            self._handleHTTPError(response as? HTTPURLResponse ?? nil)
                            return
                    }
                    
                    self._apiKey = nil
                    self._loginTime = nil
                    self._loginInfo = nil
                    self._userInfo = nil
                    self._callDelegateLoginValid(false) // At this time, we are logged out, but the session is still valid.
                }
                
                self._dataItems = []    // We nuke the cache when we log out.
                logoutTask.resume()
            } else {
                self._handleError(SDK_Connection_Errors.invalidServerURI(url))
            }
        }
    }
    
    /* ################################################################## */
    /**
     - parameter inUserIntegerID: An Array of Int, with the data database IDs of the user objects Requested.
     */
    public func fetchUsers(_ inUserIntegerIDArray: [Int]) {
        // If we got here, it means that we didn't find the user, and need to fetch the user from the server.
        self._getUserInfo(inUserIntegerIDArray)
    }

    /* ################################################################## */
    // MARK: - Public Sequence Protocol Methods
    /* ################################################################## */
    /**
     - returns: a new iterator for the instance.
     */
    public func makeIterator() -> RVP_IOS_SDK.Iterator {
        return Iterator(self._dataItems)
    }
}
