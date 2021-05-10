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

import Foundation
import MapKit

/* ###################################################################################################################################### */
// MARK: - Delegate Protocol -
/* ###################################################################################################################################### */
/**
 This protocol needs to be applied to any class that will use the SDK. The SDK requires a delegate.
 
 All methods are required.
 
 These are likely to be called in non-main threads, so caveat emptor.
 */
public protocol RVP_Cocoa_SDK_Delegate: AnyObject {
    /* ################################################################## */
    /**
     This is called when a server session (not login) is started or ended.
     If the connection was invalidated, then sessionDisconnectedBecause will also be called after this.
     
     **NOTE:** This is not guaranteed to be called in the main thread!
     
     - parameter: This is the SDK instance making the call.
     - parameter sessionConnectionIsValid: A Bool, true, if the SDK is currently in a valid session with a server.
     - parameter refCon: This is an optional Any parameter that is simply returning attached data to the delegate. The data is sent during the initial call. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    func sdkInstance(_: RVP_Cocoa_SDK, sessionConnectionIsValid: Bool, refCon: Any?)
    
    /* ################################################################## */
    /**
     This is called when the server has completed its login sequence, and all is considered OK.
     The server should not be considered "usable" until after this method has been called with true.
     
     **NOTE:** This is not guaranteed to be called in the main thread!

     - parameter: This is the SDK instance making the call.
     - parameter loginValid: A Bool, true, if the SDK is currently logged in.
     - parameter refCon: This is an optional Any parameter that is simply returning attached data to the delegate. The data is sent during the initial call. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    func sdkInstance(_: RVP_Cocoa_SDK, loginValid: Bool, refCon: Any?)
    
    /* ################################################################## */
    /**
     This is called when the SDK instance disconnects from the server.
     
     **NOTE:** This is not guaranteed to be called in the main thread!

     - parameter: This is the SDK instance making the call.
     - parameter sessionDisconnectedBecause: The reason for the disconnection.
     - parameter refCon: This is an optional Any parameter that is simply returning attached data to the delegate. The data is sent during the initial call. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
    */
    func sdkInstance(_: RVP_Cocoa_SDK, sessionDisconnectedBecause: RVP_Cocoa_SDK.DisconnectionReason, refCon: Any?)
    
    /* ################################################################## */
    /**
     This is called when there is an error in the SDK instance.
     
     **NOTE:** This is not guaranteed to be called in the main thread!

     - parameter: This is the SDK instance making the call.
     - parameter sessionError: The error in question.
     - parameter refCon: This is an optional Any parameter that is simply returning attached data to the delegate. The data is sent during the initial call. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    func sdkInstance(_: RVP_Cocoa_SDK, sessionError: Error, refCon: Any?)
    
    /* ################################################################## */
    /**
     This is called with one or more data items. Each item is a single object.
     In an auto-radius search, this may be called repeatedly.
     
     **NOTE:** This is not guaranteed to be called in the main thread!
     
     - parameter: This is the SDK instance making the call.
     - parameter fetchedDataItems: An array of subclasses of A_RVP_IOS_SDK_Object.
     - parameter refCon: This is an optional Any parameter that is simply returning attached data to the delegate. The data is sent during the initial call. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    func sdkInstance(_: RVP_Cocoa_SDK, fetchedDataItems: [A_RVP_Cocoa_SDK_Object], refCon: Any?)
    
    /* ################################################################## */
    /**
     This is a response to a new token creation request.
     
     **NOTE:** This is not guaranteed to be called in the main thread!
     
     - parameter: This is the SDK instance making the call.
     - parameter newSecurityTokens: An Array of new security token IDs.
     - parameter refCon: This is an optional Any parameter that is simply returning attached data to the delegate. The data is sent during the initial call. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    func sdkInstance(_: RVP_Cocoa_SDK, newSecurityTokens: [Int], refCon: Any?)

    /* ################################################################## */
    /**
     This is a response to the count how many logins have access to a token test.
     
     **NOTE:** This is not guaranteed to be called in the main thread!
     
     - parameter: This is the SDK instance making the call.
     - parameter tokenAccessTest: A dictionary, with the keys being a token, and the values being how many logins have access to that token.
     - parameter refCon: This is an optional Any parameter that is simply returning attached data to the delegate. The data is sent during the initial call. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    func sdkInstance(_: RVP_Cocoa_SDK, tokenAccessTest: [Int: Int], refCon: Any?)

    /* ################################################################## */
    /**
     This is a response to the token catalog request (fetchAllTokensFromServer).
     
     **NOTE:** This is not guaranteed to be called in the main thread!
     
     - parameter: This is the SDK instance making the call.
     - parameter tokenList: An Array of Token Type Enum values. Some may have associated data.
     - parameter refCon: This is an optional Any parameter that is simply returning attached data to the delegate. The data is sent during the initial call. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    func sdkInstance(_: RVP_Cocoa_SDK, tokenList: [RVP_Cocoa_SDK.TokenType], refCon: Any?)

    /* ################################################################## */
    /**
     This is a response to the count how many logins have access to a token test.
     
     This version of the call is security-restricted, so the IDs will only be for logins that the current login can see.
     
     **NOTE:** This is not guaranteed to be called in the main thread!
     
     - parameter: This is the SDK instance making the call.
     - parameter tokenAccessTest: A tuple, containing the tested token ("token"), and the IDs of the logins (not users) that have the token ("logins").
     - parameter refCon: This is an optional Any parameter that is simply returning attached data to the delegate. The data is sent during the initial call. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    func sdkInstance(_: RVP_Cocoa_SDK, tokenAccessTest: (token: Int, logins: [Int]), refCon: Any?)
    
    /* ################################################################## */
    /**
     This is a response to the count how many users have access to a token test.
     
     This version of the call is security-restricted, so the IDs will only be for users that the current login can see.
     
     **NOTE:** This is not guaranteed to be called in the main thread!
     
     - parameter: This is the SDK instance making the call.
     - parameter tokenAccessTest: A tuple, containing the tested token ("token"), and the IDs of the users (not logins) that have the token ("users").
     - parameter refCon: This is an optional Any parameter that is simply returning attached data to the delegate. The data is sent during the initial call. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    func sdkInstance(_: RVP_Cocoa_SDK, tokenAccessTest: (token: Int, users: [Int]), refCon: Any?)
    
    /* ################################################################## */
    /**
     This is a response to the get a fast list of available users and IDs.
     We will use this for things like auto-populating search boxes.
     
     This version of the call is security-restricted, so the IDs will only be for users that the current login can see.
     
     **NOTE:** This is not guaranteed to be called in the main thread!
     
     - parameter: This is the SDK instance making the call.
     - parameter fastUserList: Dictionary, indexed by the integer user (not login) ID, and a string value, containing the display name for that user.
     - parameter refCon: This is an optional Any parameter that is simply returning attached data to the delegate. The data is sent during the initial call. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    func sdkInstance(_: RVP_Cocoa_SDK, fastUserList: [Int: String], refCon: Any?)

    /* ################################################################## */
    /**
     This is called with one or more data items. Each item is a single object.
     This returns the items that were deleted (they no longer exist) in the database.
     
     **NOTE:** This is not guaranteed to be called in the main thread!
     
     - parameter: This is the SDK instance making the call.
     - parameter deletedDataItems: An array of subclasses of A_RVP_IOS_SDK_Object.
     - parameter refCon: This is an optional Any parameter that is simply returning attached data to the delegate. The data is sent during the initial call. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    func sdkInstance(_: RVP_Cocoa_SDK, deletedDataItems: [A_RVP_Cocoa_SDK_Object], refCon: Any?)

    /* ################################################################## */
    /**
     This is called when a new object has been created in the system.
     It is called once per new object, just before sdkInstance(_:,fetchedDataItems:),
     which will be called with the same object, in an Array of one element.
     
     **NOTE:** This is not guaranteed to be called in the main thread!
     
     - parameter: This is the SDK instance making the call.
     - parameter newObject: The newly-created object.
     - parameter refCon: This is an optional Any parameter that is simply returning attached data to the delegate. The data is sent during the initial call. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    func sdkInstance(_: RVP_Cocoa_SDK, newObject: A_RVP_Cocoa_SDK_Object, refCon: Any?)

    /* ################################################################## */
    /**
     This is called when an object has been changed in the system.
     
     **NOTE:** This is not guaranteed to be called in the main thread!
     
     - parameter: This is the SDK instance making the call.
     - parameter changedObject: The changed object.
     - parameter refCon: This is an optional Any parameter that is simply returning attached data to the delegate. The data is sent during the initial call. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    func sdkInstance(_: RVP_Cocoa_SDK, changedObject: A_RVP_Cocoa_SDK_Object, refCon: Any?)

    /* ################################################################## */
    /**
     This is called with zero or more IDs. Baseline searches are a "two-step" process, where IDs are fetched first, then objects.
     This call is made between the two steps. In the case of auto-radius, the second step is not done until the end, so this is the only indication of progress.
     In an auto-radius search, this will be called repeatedly, but the actual objects will not be fetched until the final call.
     
     **NOTE:** This is not guaranteed to be called in the main thread!
     
     - parameter: This is the SDK instance making the call.
     - parameter baselineAutoRadiusIDs: An array of Int. This contains the current IDs for the interim step of a baseline search.
     - parameter isFinal: This is true, if this was the last call for an auto-radius search. Remember that the call may be made before the threshold has been reached.
     - parameter refCon: This is an optional Any parameter that is simply returning attached data to the delegate. The data is sent during the initial call. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    func sdkInstance(_: RVP_Cocoa_SDK, baselineAutoRadiusIDs: [Int], isFinal: Bool, refCon: Any?)

    /* ################################################################## */
    /**
     This is called when the last auto-radius call has been made.
     This is called BEFORE the results of that call come, so keep in mind that it is not the last. You should wait for sdkInstanceOperationComplete() to be called.
     
     **NOTE:** This is not guaranteed to be called in the main thread!
     
     - parameter: This is the SDK instance making the call.
     - parameter refCon: This is an optional Any parameter that is simply returning attached data to the delegate. The data is sent during the initial call. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    func sdkInstanceFinalAutoRadiusCall(_: RVP_Cocoa_SDK, refCon: Any?)

    /* ################################################################## */
    /**
     This is called when an operation is complete.
     
     **NOTE:** This is not guaranteed to be called in the main thread!
     
     - parameter: This is the SDK instance making the call.
     - parameter refCon: This is an optional Any parameter that is simply returning attached data to the delegate. The data is sent during the initial call. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    func sdkInstanceOperationComplete(_: RVP_Cocoa_SDK, refCon: Any?)
}

/* ###################################################################################################################################### */
// MARK: - Main Library Interface Class -
/* ###################################################################################################################################### */
/**
 This class represents the public interface to the White Dragon Great Rift Valley Platform BAOBAB Server iOS SDK framework.
 
 The SDK is a Swift-only shared framework for use by Swift applications, targeting iOS 11 or above.
 
 This system works by caching retrieved objects in the main SDK instance, and referencing them. This is different from the PHP SDK, where each object is an
 independent instance and state. Swift likes objects to be referenced, as opposed to copied, so we honor that. Since the SDK is really an ORM, this makes sense.
 
 This class follows the Sequence protocol, so its cached instances can be iterated and subscripted. These instances are kept sorted by ID and database.
 
 The SDK opens a session to the server upon instantiation, and maintains that throughout its lifecycle. This happens whether or not a login is done.
 
 It can also have an open session passed in at instantiation, and it will use that session.
 */
public class RVP_Cocoa_SDK: NSObject, Sequence, URLSessionDelegate {
    /* ################################################################## */
    // MARK: - Private Static Properties
    /* ################################################################## */
    /** This queue will be used to ensure that the operation counter is called atomically. Since it is static, it will be atomic. */
    private static let _staticQueue = DispatchQueue(label: "RVP_Cocoa_SDK_Static_Queue")

    /* ################################################################## */
    // MARK: - Private Properties
    /* ################################################################## */
    /** This is an array of data instances. They are cached here. */
    private var _dataItems: [A_RVP_Cocoa_SDK_Object] = []
    
    /** This is the delegate object. This instance is pretty much useless without a delegate. */
    private weak var _delegate: RVP_Cocoa_SDK_Delegate?
    
    /** This is the URI to the server. */
    private var _server_uri: String = ""
    
    /** This is the server's sectret. */
    private var _server_secret: String = ""
    
    /** This is the version reported by the server. */
    private var _server_version: String = ""

    /** If _loggedIn is true, then this must be non-nil, and is the time at which the login was made. */
    private var _loginTime: Date! = nil
    
    /** If _loggedIn is true, then this must be non-nil, and is the period of time the login is valid. */
    private var _loginTimeout: TimeInterval! = nil

    /** This is the connection session with the server. It is initiated at the time the class is instantiated, and destroyed when the class is torn down. */
    private var _connectionSession: URLSession! = nil
    
    /** This is the API Key (if logged in). */
    private var _apiKey: String! = nil
    
    /** This is our login info. If we are logged in, this should always have something. */
    private var _loginInfo: RVP_Cocoa_SDK_Login?
    
    /** This is our user info. If we are logged in, we might have something, but not always. */
    private var _userInfo: RVP_Cocoa_SDK_User?

    /** This is our list of available plugins. It will be filled, regardless of login status. */
    private var _plugins: [String] = []
    
    /** This is set to true, if we created our own session (as opposed to using one passed in). */
    private var _newSession: Bool = false
    
    /** This is the step size for auto-radius searches, in kilometers. Default is 0.5 Km, but it can be changed by changing the autoRadiusStepSizeInKm public calculated property. */
    private var _autoRadiusStepSizeInKm: Double = 0.5
    
    /** This is the number of personal tokens that should be added to new logins. */
    private var _number_of_personal_tokens_per_login: Int = 0
    
    /** This will be used to determine when a stack of operations is complete. It is incremented whenever an operation is started, and decremented when it is complete. When it reaches 0, the delegate is informed. */
    private var _openOperations: Int = 0 {
        didSet {
            if 0 >= self._openOperations {  // If zero, we need to tell the delegate.
                self._openOperations = 0    // We can never be less than zero.
                if 0 < oldValue {   // If this is the last one, we call the delegate. We don't call repeatedly for zero.
                    self._delegate?.sdkInstanceOperationComplete(self, refCon: nil)
                }
            }
        }
    }
    
    /* ################################################################## */
    // MARK: - Private Calculated Properties
    /* ################################################################## */
    /**
     Returns a String, with the server secret and API Key already in URI form.
     This should be appended to the URI, but be aware that it is not preceded by an ampersand (&) or question mark (?). You need to provide those, yourself. READ ONLY
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
    // MARK: - Private Class Methods
    /* ################################################################## */
    /**
     This method sorts out the strings passed into the fetchObjectsByString(_:,andLocation:,withPlugin) method. It will return a valid generic search set for the given plugin.
     
     The possible keys for the incoming Dictionary are (baseline, places, people, things):
     - "name" This is the object name. It applies to all objects.
     - "tag0", "venue" (you cannot directly search for the login ID of a user with this method, but you can look for a baseline tag0 value, which is the user login. Same for thing keys.)
     - "tag1", "streetAddress", "surname", "description"
     - "tag2", "extraInformation", "middleName"
     - "tag3", "town", "givenName"
     - "tag4", "county", "nickname"
     - "tag5", "state", "prefix"
     - "tag6", "postalCode", "suffix"
     - "tag7", "nation"
     - "tag8"
     - "tag9"
     
     The values can use SQL-style wildcards (%) and are case-insensitive.
     
     - returns: a Dictionary, with the parameter set required for the given plugin.
     */
    private class func _sortOutStrings(_ inTagValues: [String: String]?, forPlugin inPlugin: String) -> [String: String] {
        var ret: [String: String] = [:]
        
        // First, make sure we got something, and normalize the keys to "tagX" keys.
        if var temp: [String: String] = self._normalizeKeys(inTagValues) {
            switch inPlugin {
            case "people":
                temp = self._normalizeKeysForPeoplePlugin(temp)
            case "places":
                temp = self._normalizeKeysForPlacesPlugin(temp)
            case "things":
                temp = self._normalizeKeysForThingsPlugin(temp)
            default:
                break
            }
            
            if !temp.isEmpty {
                ret = temp
            }
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     Normalizes the strings for the people plugin.
     
     - returns: an optional Dictionary, with the parameter set required for the plugin. It will return an empty Dictionary, if none of the keys will translate (should never happen)
     */
    private class func _normalizeKeysForPeoplePlugin(_ inTagValues: [String: String]) -> [String: String] {
        var ret: [String: String] = [:]
        
        for tup in inTagValues {
            switch tup.key {
            case "name":
                ret["name"] = tup.value
            case "tag1":
                ret["surname"] = tup.value
            case "tag2":
                ret["middle_name"] = tup.value
            case "tag3":
                ret["given_name"] = tup.value
            case "tag4":
                ret["nickname"] = tup.value
            case "tag5":
                ret["prefix"] = tup.value
            case "tag6":
                ret["suffix"] = tup.value
            case "tag7":
                ret["tag7"] = tup.value
            case "tag8":
                ret["tag8"] = tup.value
            case "tag9":
                ret["tag9"] = tup.value
            default:
                break
            }
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     Normalizes the strings for the places plugin.
     
     - returns: an optional Dictionary, with the parameter set required for the plugin. It will return an empty Dictionary, if none of the keys will translate (should never happen)
     */
    private class func _normalizeKeysForPlacesPlugin(_ inTagValues: [String: String]) -> [String: String] {
        var ret: [String: String] = [:]
        
        for tup in inTagValues {
            switch tup.key {
            case "name":
                ret["name"] = tup.value
            case "tag0":
                ret["venue"] = tup.value
            case "tag1":
                ret["street_address"] = tup.value
            case "tag2":
                ret["extra_information"] = tup.value
            case "tag3":
                ret["town"] = tup.value
            case "tag4":
                ret["county"] = tup.value
            case "tag5":
                ret["state"] = tup.value
            case "tag6":
                ret["postal_code"] = tup.value
            case "tag7":
                ret["nation"] = tup.value
            case "tag8":
                ret["tag8"] = tup.value
            case "tag9":
                ret["tag9"] = tup.value
            default:
                break
            }
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     Normalizes the strings for the things plugin.
     
     - returns: an optional Dictionary, with the parameter set required for the plugin. It will return an empty Dictionary, if none of the keys will translate (should never happen)
     */
    private class func _normalizeKeysForThingsPlugin(_ inTagValues: [String: String]) -> [String: String] {
        var ret: [String: String] = [:]
        
        for tup in inTagValues {
            switch tup.key {
            case "tag0":
                ret["key"] = tup.value
            case "tag1", "description":
                ret["description"] = tup.value
            case "name", "tag2", "tag3", "tag4", "tag5", "tag6", "tag7", "tag8", "tag9":
                ret[tup.key] = tup.value
            default:
                break
            }
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     This method "normalizes" all the strings into a Dictionary of "tagX" keys (baseline keys).
     
     The possible keys for the incoming Dictionary are (baseline, places, people, things):
     - "tag0", "venue" (you cannot directly search for the login ID of a user with this method, but you can look for a baseline tag0 value, which is the user login. Same for thing keys.)
     - "tag1", "streetAddress", "surname", "description"
     - "tag2", "extraInformation", "middleName"
     - "tag3", "town", "givenName"
     - "tag4", "county", "nickname"
     - "tag5", "state", "prefix"
     - "tag6", "postalCode", "suffix"
     - "tag7", "nation"
     - "tag8"
     - "tag9"
     
     - returns: an optional Dictionary, with the parameter set required for the given plugin. Nil, if we could not normalize the keys.
     */
    private class func _normalizeKeys(_ inTagValues: [String: String]?) -> [String: String]? {
        var ret: [String: String]?
        
        // First, make sure we got something.
        if let tagValues = inTagValues, !tagValues.isEmpty {
            ret = [:]
            
            for tup in tagValues {
                switch tup.key {
                case "name":
                    ret?["name"] = tup.value
                case "tag0", "venue":
                    ret?["tag0"] = tup.value
                case "tag1", "streetAddress", "surname", "description":
                    ret?["tag1"] = tup.value
                case "tag2", "extraInformation", "middleName":
                    ret?["tag2"] = tup.value
                case "tag3", "town", "givenName":
                    ret?["tag3"] = tup.value
                case "tag4", "county", "nickname":
                    ret?["tag4"] = tup.value
                case "tag5", "state", "prefix":
                    ret?["tag5"] = tup.value
                case "tag6", "postalCode", "suffix":
                    ret?["tag6"] = tup.value
                case "tag7", "nation":
                    ret?["tag7"] = tup.value
                case "tag8":
                    ret?["tag8"] = tup.value
                case "tag9":
                    ret?["tag9"] = tup.value
                default:
                    break
                }
            }
        }
        return ret
    }
    
    /* ################################################################## */
    // MARK: - Private Instance Methods
    /* ################################################################## */
    /**
     This checks our Array of instances, looking for an item with the given database and ID.
     
     This is used to prevent multiple instances representing the same object in the server.
     
     - parameter inCompInstance: An instance of a subclass of A_RVP_IOS_SDK_Object, to be compared.
     
     - returns: The instance, if found. nil, otherwise.
     */
    private func _findDatabaseItem(compInstance inCompInstance: A_RVP_Cocoa_SDK_Object) -> A_RVP_Cocoa_SDK_Object? {
        if !self.isEmpty {  // Nothing to do, if we have no items.
            for item in self where item.id == inCompInstance.id {
                // OK. The ID is unique in each database, so we check to see if an existing object and the given object are in the same database.
                if (item is A_RVP_Cocoa_SDK_Security_Object && inCompInstance is A_RVP_Cocoa_SDK_Security_Object) || (item is A_RVP_Cocoa_SDK_Data_Object && inCompInstance is A_RVP_Cocoa_SDK_Data_Object) {
                    return item // If so, we return the cached object.
                }
            }
        }
        
        return nil
    }

    /* ################################################################## */
    /**
     This is a factory method for creating baseline objects.
     
     The baseline plugin can produce a variety of objects, so it needs to be handled differently. These will not be cached.
     
     - parameter data: A Data object, with the JSON data (which will be parsed) returned from the server.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.

     - returns: A Dictionary ([String: Any]), with the resulting data.
     */
    private func _parseBaselineResponse(data inData: Data, refCon inRefCon: Any?) -> [String: Any] {
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
                                ret[key] = plugin_response
                            }

                        case "version":
                            if let plugin_response = value as? String {
                                self._server_version = plugin_response
                            }

                        case "plugins":
                            if let plugin_response = value as? [String] {
                                ret[key] = plugin_response
                            }

                        case "serverinfo", "search_location", "bulk_upload", "token", "id":
                            if let plugin_response = value as? [String: Any] {
                                ret[key] = plugin_response
                            }

                        case "tokens":
                            if let plugin_response = value as? [Int] {
                                ret[key] = plugin_response
                            }

                        default:
                            self._handleError(SDK_Data_Errors.invalidData(inData), refCon: inRefCon)
                        }
                    }
                } else if let baseline_response = main_object["version"] as? String {
                    self._server_version = baseline_response
                }   // No data is not an error. It's just...no data.
            } else {
                self._handleError(SDK_Data_Errors.invalidData(inData), refCon: inRefCon)
            }
        } catch {   // We end up here if the response is not a proper JSON object.
            self._handleError(SDK_Data_Errors.invalidData(inData), refCon: inRefCon)
        }
        
        return ret
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
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.

     - returns: An optional array of new instances of concrete subclasses of A_RVP_IOS_SDK_Object.
     */
    internal func _makeInstance(data inData: Data, refCon inRefCon: Any?) -> [A_RVP_Cocoa_SDK_Object]? {
        var ret: [A_RVP_Cocoa_SDK_Object] = []
        
        do {    // Extract a usable object from the given JSON data.
            let temp = try JSONSerialization.jsonObject(with: inData, options: [])
            
            if let main_object = temp as? NSDictionary {
                ret = self._makeInstancesFromDictionary(main_object, refCon: inRefCon)
            } else if let main_object = temp as? NSArray {
                ret = self._makeInstancesFromArray(main_object, refCon: inRefCon)
            }
        } catch {   // We end up here if the response is not a proper JSON object.
            self._handleError(SDK_Data_Errors.invalidData(inData), refCon: inRefCon)
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
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.

     - returns: An Array of new subclass instances of A_RVP_Cocoa_SDK_Object.
     */
    private func _makeInstancesFromDictionary(_ inDictionary: NSDictionary, parent inParent: String? = nil, refCon inRefCon: Any?) -> [A_RVP_Cocoa_SDK_Object] {
        var ret: [A_RVP_Cocoa_SDK_Object] = []
        // First, see if we have a data item. If so, we simply go right to the factory.
        if let parent = inParent, nil != inDictionary.object(forKey: "id"), nil != inDictionary.object(forKey: "name"), nil != inDictionary.object(forKey: "lang"), let object_data = inDictionary as? [String: Any] {
            if let object = self._makeNewInstanceFromDictionary(object_data, parent: parent) {
                ret = [object]
            }
        } else { // Otherwise, we simply go down the rabbit-hole.
            for (key, value) in inDictionary {
                if var forcedKey = key as? String {    // This will be the "parent" key for the next level down.
                    if "results" == forcedKey || forcedKey.isAnInteger, let parent = inParent {    // This is a special case for searches, or for what should be an Array, but was mapped to a Dictionary.
                        forcedKey = parent
                    }
                    let passKey = forcedKey
                    if let forcedValue = value as? NSDictionary {  // See whether we go Dictionary or Array.
                        ret = [ret, self._makeInstancesFromDictionary(forcedValue, parent: passKey, refCon: inRefCon)].flatMap { $0 }   // The flatmap() method ensures that we merge the arrays "flat."
                    } else if let forcedValue = value as? NSArray {
                        ret = [ret, self._makeInstancesFromArray(forcedValue, parent: forcedKey, refCon: inRefCon)].flatMap { $0 }
                    }
                } else {
                    do {
                        let data: Data = try NSKeyedArchiver.archivedData(withRootObject: inDictionary, requiringSecureCoding: false)
                        self._handleError(SDK_Data_Errors.invalidData(data), refCon: inRefCon)
                    } catch {
                        self._handleError(SDK_Data_Errors.invalidData(nil), refCon: inRefCon)
                    }
                    
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
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.

     - returns: An Array of new subclass instances of A_RVP_Cocoa_SDK_Object.
     */
    private func _makeInstancesFromArray(_ inArray: NSArray, parent inParent: String! = nil, refCon inRefCon: Any?) -> [A_RVP_Cocoa_SDK_Object] {
        var ret: [A_RVP_Cocoa_SDK_Object] = []
        // With Arrays, we don't have parent keys, so we use the one that was originally passed in.
        for value in inArray {
            if let forced_value = value as? NSDictionary {
                ret = [ret, self._makeInstancesFromDictionary(forced_value, parent: inParent, refCon: inRefCon)].flatMap { $0 }
            } else if let forced_value = value as? NSArray {
                ret = [ret, self._makeInstancesFromArray(forced_value, parent: inParent, refCon: inRefCon)].flatMap { $0 }
            } else {
                do {
                    let data: Data = try NSKeyedArchiver.archivedData(withRootObject: inArray, requiringSecureCoding: false)
                    self._handleError(SDK_Data_Errors.invalidData(data), refCon: inRefCon)
                } catch {
                    self._handleError(SDK_Data_Errors.invalidData(nil), refCon: inRefCon)
                }
                break
            }
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     This is called to state the status of our session.
     
     If the delegate is valid, we call it with a notice that the session disconnected because of an invalid server connection.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _reportSessionValidity(refCon inRefCon: Any?) {
        self._delegate?.sdkInstance(self, sessionConnectionIsValid: self.isValid, refCon: inRefCon)
    }

    /* ################################################################## */
    /**
     This is called when we want to send interim baseline auto-radius results to the client.
     
     - parameter inIDArray: An Array of Int, containing zero or more IDs found so far.
     - parameter isFinal: This is true (default is false), if this was the last call in an auto-radius search. Remember that the call may be made before the threshold has been reached.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _sendIDsToDelegate(_ inIDArray: [Int], isFinal inIsFinal: Bool = false, refCon inRefCon: Any?) {
        self._delegate?.sdkInstance(self, baselineAutoRadiusIDs: inIDArray, isFinal: inIsFinal, refCon: inRefCon)
    }
    
    /* ################################################################## */
    /**
     This is called if we determine the server connection to be invalid.
     
     If the delegate is valid, we call it with a notice that the session disconnected because of an invalid server connection.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _handleInvalidServer(refCon inRefCon: Any?) {
        self._delegate?.sdkInstance(self, sessionDisconnectedBecause: RVP_Cocoa_SDK.DisconnectionReason.serverConnectionInvalid, refCon: inRefCon)
    }

    /* ################################################################## */
    /**
     This is called after the server responds to a login or logout (in the case of a login, a lot of other stuff happens, as well).
     
     If the delegate is valid, we call it with a report of the current SDK instance login status.
     
     - parameter isLoggedIn: This is true, if the instance is currently logged into the server.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _callDelegateLoginValid(_ inIsLoggedIn: Bool, refCon inRefCon: Any?) {
        self._delegate?.sdkInstance(self, loginValid: inIsLoggedIn, refCon: inRefCon)
    }

    /* ################################################################## */
    /**
     This fetches objects from the data database server.
     
     - parameter inResultDictionary: A Dictionary of the returned IDs.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _handleReturnedIDs(_ inResultDictionary: [String: [Int]], refCon inRefCon: Any?) {
        var handled = false // If we get any IDs, then we have something...
        
        if let peopleIDs = inResultDictionary["people"], !peopleIDs.isEmpty {
            self.fetchDataItemsByIDs(peopleIDs, andPlugin: "people", dontNukeTheLocation: true, refCon: inRefCon)
            handled = true
        }
        
        if let placeIDs = inResultDictionary["places"], !placeIDs.isEmpty {
            self.fetchDataItemsByIDs(placeIDs, andPlugin: "places", dontNukeTheLocation: true, refCon: inRefCon)
        }
        
        if let thingIDs = inResultDictionary["things"], !thingIDs.isEmpty {
            self.fetchDataItemsByIDs(thingIDs, andPlugin: "things", dontNukeTheLocation: true, refCon: inRefCon)
        }
        
        if !handled {
            self._sendItemsToDelegate([], refCon: inRefCon)   // We got nuthin'
        }
    }

    /* ################################################################## */
    /**
     Asks the server to create a security token (no login).
     This can only be called if you are logged in as a manager.
     
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _createSecurityToken(refCon inRefCon: Any?) {
        if self.isLoggedIn {
            // The my info request is a simple GET task, so we can just use a straight-up task for this.
            let url = self._server_uri + "/json/baseline/tokens?" + self._loginParameters
            if let url_object = URL(string: url) {
                var urlRequest = URLRequest(url: url_object)
                urlRequest.httpMethod = "POST"
                Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                    self._openOperations += 1
                }
                
                if let session = self._connectionSession {
                    session.dataTask(with: urlRequest) { [unowned self] data, response, error in
                        if let error = error {
                            self._handleError(error, refCon: inRefCon)
                            return
                        }
                        
                        guard let httpResponse = response as? HTTPURLResponse,
                            (200...299).contains(httpResponse.statusCode) else {
                                self._handleHTTPError(response as? HTTPURLResponse ?? nil, refCon: inRefCon)
                                return
                        }

                        if let mimeType = httpResponse.mimeType, "application/json" == mimeType, let data = data {
                            if let response = self._parseBaselineResponse(data: data, refCon: inRefCon) as? [String: [Int]] {
                                if let token_array = response["tokens"] {
                                    self.myLoginInfo?.securityTokens += token_array
                                    self.myLoginInfo?.securityTokens = self.myLoginInfo?.securityTokens.sorted() ?? []
                                    self._delegate?.sdkInstance(self, newSecurityTokens: token_array, refCon: inRefCon)
                                }
                            }
                        } else {
                            self._handleError(SDK_Data_Errors.invalidData(data), refCon: inRefCon)
                        }
                        
                        Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                            self._openOperations -= 1
                        }
                    }.resume()
                }
            } else {
                self._handleError(SDK_Connection_Errors.invalidServerURI(url), refCon: inRefCon)
            }
        }
    }

    /* ################################################################## */
    /**
     This is to be called after a successful API Key fetch (login).
     
     We ask the server to send us our login object information.
     
     When we get the information, we parse it, create a new instance of the handler class
     and cache that instance.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _fetchMyLoginInfo(refCon inRefCon: Any?) {
        if self.isLoggedIn {
            // The my info request is a simple GET task, so we can just use a straight-up task for this.
            let url = self._server_uri + "/json/people/logins/my_info?" + self._loginParameters
            if let url_object = URL(string: url) {
                // We handle the response in the closure.
                Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                    self._openOperations += 1
                }
                let loginInfoTask = self._connectionSession.dataTask(with: url_object) { [unowned self] data, response, error in
                    if let error = error {
                        self._handleError(error, refCon: inRefCon)
                        return
                    }
                    guard let httpResponse = response as? HTTPURLResponse,
                        (200...299).contains(httpResponse.statusCode) else {
                            self._handleHTTPError(response as? HTTPURLResponse ?? nil, refCon: inRefCon)
                            return
                    }
                    if let mimeType = httpResponse.mimeType, "application/json" == mimeType, let data = data {
                        if let object = self._makeInstance(data: data, refCon: inRefCon) as? [RVP_Cocoa_SDK_Login] {
                            if 1 == object.count {
                                self._loginInfo = object[0]
                                // Assuming all went well, we ask for any user information.
                                self._fetchMyUserInfo(refCon: inRefCon)
                            } else {
                                self._handleError(SDK_Data_Errors.invalidData(data), refCon: inRefCon)
                            }
                        }
                    } else {
                        self._handleError(SDK_Data_Errors.invalidData(data), refCon: inRefCon)
                    }
                    
                    Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                        self._openOperations -= 1
                    }
                }
                
                loginInfoTask.resume()
            } else {
                self._handleError(SDK_Connection_Errors.invalidServerURI(url), refCon: inRefCon)
            }
        }
    }

    /* ################################################################## */
    /**
     This is to be called after a successful API Key fetch (login) and a successful login info fetch.
     
     We ask the server to send us our user (data database) object information.
     
     When we get the information, we parse it, create a new instance of the handler class, and cache that instance.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _fetchMyUserInfo(refCon inRefCon: Any?) {
        if self.isLoggedIn {
            let url = self._server_uri + "/json/people/people/my_info?" + self._loginParameters
            // The my info request is a simple GET task, so we can just use a straight-up task for this.
            if let url_object = URL(string: url) {
                Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                    self._openOperations += 1
                }
                let userInfoTask = self._connectionSession.dataTask(with: url_object) { [unowned self] data, response, error in
                    if let error = error {
                        self._handleError(error, refCon: inRefCon)
                        return
                    }
                    guard let httpResponse = response as? HTTPURLResponse,
                        (200...299).contains(httpResponse.statusCode) || (400 == httpResponse.statusCode) else {
                            self._handleHTTPError(response as? HTTPURLResponse ?? nil, refCon: inRefCon)
                            return
                    }
                    if 400 == httpResponse.statusCode { // If we get nothing but a 400, we assume there is no user info, and go straight to completion.
                        if self._plugins.isEmpty {
                            self._validateServer(refCon: inRefCon)
                        } else {
                            self._reportSessionValidity(refCon: inRefCon)   // We report whether or not this session is valid.
                            self._callDelegateLoginValid(self.isLoggedIn, refCon: inRefCon)   // OK. We're done. Tell the delegate whether or not we are logged in.
                        }
                    } else if let mimeType = httpResponse.mimeType, "application/json" == mimeType, let data = data {
                        if let object = self._makeInstance(data: data, refCon: inRefCon) as? [RVP_Cocoa_SDK_User] {
                            if 1 == object.count {
                                self._userInfo = object[0]
                                if self._plugins.isEmpty {
                                    self._validateServer(refCon: inRefCon)
                                } else {
                                    self._reportSessionValidity(refCon: inRefCon)   // We report whether or not this session is valid.
                                    self._callDelegateLoginValid(self.isLoggedIn, refCon: inRefCon)   // OK. We're done. Tell the delegate whether or not we are logged in.
                                }
                            } else {
                                if self._plugins.isEmpty {
                                    self._validateServer(refCon: inRefCon)
                                } else {
                                    self._reportSessionValidity(refCon: inRefCon)   // We report whether or not this session is valid.
                                    self._callDelegateLoginValid(self.isLoggedIn, refCon: inRefCon)   // OK. We're done. Tell the delegate whether or not we are logged in.
                                }
                            }
                        }
                    } else {
                        self._handleError(SDK_Data_Errors.invalidData(data), refCon: inRefCon)
                    }
                    
                    Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                        self._openOperations -= 1
                    }
                }
                
                userInfoTask.resume()
            } else {
                self._handleError(SDK_Connection_Errors.invalidServerURI(url), refCon: inRefCon)
            }
        }
    }

    /* ################################################################## */
    /**
     This fetches arbitrary type objects from the data database server.
     
     - parameter inIntegerIDs: An Array of Int, with the data database item IDs.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _fetchBaselineObjectsByID(_ inIntegerIDs: [Int], refCon inRefCon: Any?) {
        var fetchIDs: [Int] = []
        var cachedObjects: [A_RVP_Cocoa_SDK_Data_Object] = []
        
        // First, we look for cached instances. If we have them, we send them to the delegate.
        for var id in inIntegerIDs {
            for dataItem in self._dataItems {   // See if we already have this item. If so, we immediately fetch it.
                if let dataItem = dataItem as? A_RVP_Cocoa_SDK_Data_Object, dataItem.id == id {
                    cachedObjects.append(dataItem)
                    id = 0
                    break
                }
            }
            
            if 0 < id { // We'll need to fetch this one.
                fetchIDs.append(id)
            }
        }
        
        if !cachedObjects.isEmpty {
            self._sendItemsToDelegate(cachedObjects, refCon: inRefCon)   // We just send our cached items to the delegate right away.
        }
        
        if !fetchIDs.isEmpty {  // If we didn't find everything we were looking for in the junk drawer, we will be asking the server for the remainder.
            fetchIDs = fetchIDs.sorted()    // Just because we're anal...
            
            // This uses our extension to break the array up. This is to reduce the size of the GET URI.
            for idArray in fetchIDs.chunk(10) {
                var loginParams = self._loginParameters
                
                if !loginParams.isEmpty {
                    loginParams = "?" + loginParams
                }
                
                let url = self._server_uri + "/json/baseline/handlers/" + (idArray.map(String.init)).joined(separator: ",") + loginParams   // We are asking the plugin to return the handlers for the IDs we are sending in.
                
                // We will use the handlers returned to fetch the actual object data.
                if let url_object = URL(string: url) {
                    Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                        self._openOperations += 1
                    }
                    let fetchTask = self._connectionSession.dataTask(with: url_object) { [weak self] data, response, error in
                        if let error = error {
                            self?._handleError(error, refCon: inRefCon)
                            return
                        }
                        guard let httpResponse = response as? HTTPURLResponse,
                            (200...299).contains(httpResponse.statusCode) else {
                                self?._handleHTTPError(response as? HTTPURLResponse ?? nil, refCon: inRefCon)
                                return
                        }
                        
                        if let mimeType = httpResponse.mimeType, "application/json" == mimeType, let myData = data {
                            do {    // Extract a usable object from the given JSON data.
                                let temp = try JSONSerialization.jsonObject(with: myData, options: [])
                                
                                // We get a set of integer IDs returned, separated by plugin. We will sort through these, and return objects fetched for each.
                                if let resultDictionary = temp as? [String: [String: [Int]]] {
                                    if let handlers = resultDictionary["baseline"] {
                                        self?._handleReturnedIDs(handlers, refCon: inRefCon)
                                    }
                                } else {
                                    self?._handleError(SDK_Data_Errors.invalidData(myData), refCon: inRefCon)
                                }
                            } catch {   // We end up here if the response is not a proper JSON object.
                                self?._handleError(SDK_Data_Errors.invalidData(myData), refCon: inRefCon)
                            }
                        } else {
                            self?._handleError(SDK_Data_Errors.invalidData(data), refCon: inRefCon)
                        }
                        
                        Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                            self?._openOperations -= 1
                        }
                    }
                    
                    fetchTask.resume()
                } else {
                    self._handleError(SDK_Connection_Errors.invalidServerURI(url), refCon: inRefCon)
                }
            }
        } else {
            Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                self._openOperations += 1   // This triggers a call to the delegate, saying we're done.
                self._openOperations -= 1
            }
        }
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
                    ret = $0 is A_RVP_Cocoa_SDK_Security_Object && $1 is A_RVP_Cocoa_SDK_Data_Object
                }
                
                return ret
            }
        }
    }
    
    /* ################################################################## */
    /**
     This fetches objects from the data database server.
     
     - parameter inIntegerIDs: An Array of Int, with the data database item IDs.
     - parameter plugin: The plugin for these objects.
     - parameter withLogins: If true, then this call will ask for the logins associated with users, and only users that have logins. This is ignored, if the user is not a manager.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _fetchDataItems(_ inIntegerIDs: [Int], plugin inPlugin: String, withLogins inWithLogins: Bool, refCon inRefCon: Any?) {
        var fetchIDs: [Int] = []
        var cachedObjects: [A_RVP_Cocoa_SDK_Data_Object] = []
        
        // First, we look for cached instances. If we have them, we send them to the delegate.
        for var id in inIntegerIDs {
            for dataItem in self._dataItems {   // See if we already have this item. If so, we immediately fetch it.
                if let dataItem = dataItem as? A_RVP_Cocoa_SDK_Data_Object, dataItem.id == id {
                    cachedObjects.append(dataItem)
                    id = 0
                    break
                }
            }
            
            if 0 < id { // We'll need to fetch this one.
                fetchIDs.append(id)
            }
        }
        
        if !cachedObjects.isEmpty {
            self._sendItemsToDelegate(cachedObjects, refCon: inRefCon)   // We just send our cached items to the delegate right away.
        }
        
        if !fetchIDs.isEmpty {  // If we didn't find everything we were looking for in the junk drawer, we will be asking the server for the remainder.
            fetchIDs = fetchIDs.sorted()    // Just because we're anal...
            
            // This uses our extension to break the array up. This is to reduce the size of the GET URI.
            for idArray in fetchIDs.chunk(10) {
                var loginParams = self._loginParameters
                
                if !loginParams.isEmpty {
                    loginParams = "?" + loginParams
                }
                
                if "people/people" == inPlugin {
                    loginParams += (!loginParams.isEmpty ? "&" : "?") + "show_details"
                    if isManager,
                       inWithLogins {
                        loginParams += "&login_user"
                    }
                }
                
                let url = self._server_uri + "/json/\(inPlugin)/" + (idArray.map(String.init)).joined(separator: ",") + loginParams   // We are asking the plugin to return the handlers for the IDs we are sending in.
                
                // We will use the handlers returned to fetch the actual object data.
                if let url_object = URL(string: url) {
                    Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                        self._openOperations += 1
                    }
                    
                    let fetchTask = self._connectionSession.dataTask(with: url_object) { [weak self] data, response, error in
                        if let error = error {
                            self?._handleError(error, refCon: inRefCon)
                            return
                        }
                        guard let httpResponse = response as? HTTPURLResponse,
                            (200...299).contains(httpResponse.statusCode) else {
                                self?._handleHTTPError(response as? HTTPURLResponse ?? nil, refCon: inRefCon)
                                return
                        }
                        
                        if let mimeType = httpResponse.mimeType, "application/json" == mimeType, let myData = data {
                            if let objectArray = self?._makeInstance(data: myData, refCon: inRefCon) {
                                self?._dataItems.append(contentsOf: objectArray)
                                self?._sortDataItems()
                                self?._sendItemsToDelegate(objectArray, refCon: inRefCon)
                            }
                        } else {
                            self?._handleError(SDK_Data_Errors.invalidData(data), refCon: inRefCon)
                        }
                        
                        Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                            self?._openOperations -= 1
                        }
                    }
                    
                    fetchTask.resume()
                } else {
                    self._handleError(SDK_Connection_Errors.invalidServerURI(url), refCon: inRefCon)
                }
            }
        } else {
            Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                self._openOperations += 1   // This triggers a call to the delegate, saying we're done.
                self._openOperations -= 1
            }
        }
    }
    
    /* ################################################################## */
    /**
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _fetchVisibleUserIDAndNames(refCon inRefCon: Any?) {
        let loginParams = self._loginParameters
    
        if !loginParams.isEmpty {
            let url = "\(self._server_uri)/json/people/people?get_all_visible_users&\(loginParams)"   // We will be asking for all the users.
            // The request is a simple GET task, so we can just use a straight-up task for this.
            if let url_object = URL(string: url) {
                Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                    self._openOperations += 1
                }
                    
                let fetchTask = self._connectionSession.dataTask(with: url_object) { [unowned self] data, response, error in
                    if let error = error {
                        self._handleError(error, refCon: inRefCon)
                        return
                    }
                    guard let httpResponse = response as? HTTPURLResponse,
                        (200...299).contains(httpResponse.statusCode) else {
                            self._handleHTTPError(response as? HTTPURLResponse ?? nil, refCon: inRefCon)
                            return
                    }
                    
                    if let mimeType = httpResponse.mimeType, "application/json" == mimeType, let myData = data {
                        do {    // Extract a usable object from the given JSON data.
                            let temp = try JSONSerialization.jsonObject(with: myData, options: [])
                            
                            if let main_object = temp as? NSDictionary,
                               let wrapper_1 = main_object.object(forKey: "people") as? NSDictionary,
                               let wrapper_2 = wrapper_1.object(forKey: "people") as? NSDictionary,
                               let wrapper_3 = wrapper_2.object(forKey: "get_all_visible_users") as? [String: String] {
                                let keys = wrapper_3.keys.compactMap { Int($0) }
                                var ret: [Int: String] = [:]
                                
                                // Cnvert the String-based response to an Int-based Dictionary.
                                keys.forEach {
                                    if let value = wrapper_3[String($0)] {
                                        ret[$0] = value
                                    }
                                }
                                
                                // Send the user list to the delegate.
                                self._delegate?.sdkInstance(self, fastUserList: ret, refCon: inRefCon)
                            } else {
                                self._handleError(SDK_Data_Errors.invalidData(myData), refCon: inRefCon)
                            }
                        } catch {   // We end up here if the response is not a proper JSON object.
                            self._handleError(SDK_Data_Errors.invalidData(myData), refCon: inRefCon)
                        }
                    } else {
                        self._handleError(SDK_Data_Errors.invalidData(data), refCon: inRefCon)
                    }
                    
                    Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                        self._openOperations -= 1
                    }
                }
                
                fetchTask.resume()
            }
        }
    }

    /* ################################################################## */
    /**
     This fetches objects from the security database server (low-level fetch).
     This method does the actual server query.
     
     - parameter inIDString: A String, with a list of integers or login IDs, representing logins, separated by commas.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _fetchLoginItemsFromServer(_ inIDString: String, refCon inRefCon: Any?) {
        var loginParams = self._loginParameters
        
        if !loginParams.isEmpty {
            loginParams = "&" + loginParams
        }
        
        let url = self._server_uri + "/json/people/logins/" + inIDString + "?show_details" + loginParams   // We will be asking for the "full Monty".
        // The request is a simple GET task, so we can just use a straight-up task for this.
        if let url_object = URL(string: url) {
            Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                self._openOperations += 1
            }
            let fetchTask = self._connectionSession.dataTask(with: url_object) { [unowned self] data, response, error in
                if let error = error {
                    self._handleError(error, refCon: inRefCon)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                        self._handleHTTPError(response as? HTTPURLResponse ?? nil, refCon: inRefCon)
                        return
                }
                
                if let mimeType = httpResponse.mimeType, "application/json" == mimeType, let myData = data {
                    if let objectArray = self._makeInstance(data: myData, refCon: inRefCon) {
                        self._dataItems.append(contentsOf: objectArray)
                        self._sortDataItems()
                        self._sendItemsToDelegate(objectArray, refCon: inRefCon)
                    }
                } else {
                    self._handleError(SDK_Data_Errors.invalidData(data), refCon: inRefCon)
                }
                
                Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                    self._openOperations -= 1
                }
            }
            
            fetchTask.resume()
        } else {
            self._handleError(SDK_Connection_Errors.invalidServerURI(url), refCon: inRefCon)
        }
    }

    /* ################################################################## */
    /**
     This fetches all users with logins, that the current user can edit.
     This method does the actual server query.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _fetchAllEditableUsersFromServer(refCon inRefCon: Any?) {
        var loginParams = self._loginParameters
        self._dataItems = []
        if !loginParams.isEmpty {
            loginParams = "&" + loginParams
        }
        
        let url = self._server_uri + "/json/people/people/?show_details&writeable&login_user" + loginParams   // We will be asking for the "full Monty".
        // The request is a simple GET task, so we can just use a straight-up task for this.
        if let url_object = URL(string: url) {
            Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                self._openOperations += 1
            }
            let fetchTask = self._connectionSession.dataTask(with: url_object) { [unowned self] data, response, error in
                if let error = error {
                    self._handleError(error, refCon: inRefCon)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                        self._handleHTTPError(response as? HTTPURLResponse ?? nil, refCon: inRefCon)
                        return
                }
                
                if let mimeType = httpResponse.mimeType, "application/json" == mimeType, let myData = data {
                    if let objectArray = self._makeInstance(data: myData, refCon: inRefCon) {
                        self._dataItems.append(contentsOf: objectArray)
                        self._sortDataItems()
                        self._sendItemsToDelegate(objectArray, refCon: inRefCon)
                    }
                } else {
                    self._handleError(SDK_Data_Errors.invalidData(data), refCon: inRefCon)
                }
                
                Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                    self._openOperations -= 1
                }
            }
            
            fetchTask.resume()
        } else {
            self._handleError(SDK_Connection_Errors.invalidServerURI(url), refCon: inRefCon)
        }
    }

    /* ################################################################## */
    /**
     This fetches all the available tokens from the server.
     This method does the actual server query.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _fetchAllTokensFromServer(refCon inRefCon: Any?) {
        var loginParams = self._loginParameters
        self._dataItems = []
        if !loginParams.isEmpty {
            loginParams = "&" + loginParams
        }
        
        let url = self._server_uri + "/json/baseline/tokens?types" + loginParams   // We will be asking for the "full Monty".
        // The request is a simple GET task, so we can just use a straight-up task for this.
        if let url_object = URL(string: url) {
            Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                self._openOperations += 1
            }
            let fetchTask = self._connectionSession.dataTask(with: url_object) { [unowned self] data, response, error in
                if let error = error {
                    self._handleError(error, refCon: inRefCon)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                        self._handleHTTPError(response as? HTTPURLResponse ?? nil, refCon: inRefCon)
                        return
                }
                
                if let mimeType = httpResponse.mimeType, "application/json" == mimeType, let myData = data {
                    do {    // Extract a usable object from the given JSON data.
                        let temp = try JSONSerialization.jsonObject(with: myData, options: [])
                        
                        if let main_object = temp as? NSDictionary,
                           let baseline = main_object.object(forKey: "baseline") as? NSDictionary,
                           let tokens = baseline.object(forKey: "tokens") as? NSArray,
                           0 < tokens.count {
                            var tokenTypes: [TokenType] = []
                            let myLoginID = self.myLoginInfo?.id ?? 0

                            tokens.forEach {
                                if let token = $0 as? [String: Any],
                                   let id = token["id"] as? Int,
                                   1 < id,  // We start with non-"system" IDs.
                                   let type = token["type"] as? String {
                                    var tokenType: TokenType = .none
                                    
                                    switch type {
                                    case "login":
                                        tokenType = .loginID(id: id)
                                        
                                    case "token":
                                        if myLoginID == id {    // If we are a non-God admin, then our own login will be reported as a standard token. We report it as a login ID.
                                            tokenType = .loginID(id: id)
                                        } else {
                                            tokenType = .token(id: id)
                                        }

                                    case "personal":    // Personal tokens are associated with a login. In the case of non-God admins, the only login reported, is our own.
                                        tokenType = .personal(id: id, loginID: token["login_id"] as? Int ?? myLoginID)

                                    case "assigned":    // This is what is reported to non-God admins, when we have a token that was assigned from somewhere else.
                                        tokenType = .assigned(id: id)

                                    default:
                                        break
                                    }
                                    
                                    if .none != tokenType {
                                        tokenTypes.append(tokenType)
                                    }
                                }
                            }
                            self._delegate?.sdkInstance(self, tokenList: tokenTypes.sorted(), refCon: inRefCon)

                        } else {
                            self._handleError(SDK_Data_Errors.invalidData(myData), refCon: inRefCon)
                        }
                    } catch {   // We end up here if the response is not a proper JSON object.
                        self._handleError(SDK_Data_Errors.invalidData(myData), refCon: inRefCon)
                    }
                } else {
                    self._handleError(SDK_Data_Errors.invalidData(data), refCon: inRefCon)
                }
                
                Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                    self._openOperations -= 1
                }
            }
            
            fetchTask.resume()
        } else {
            self._handleError(SDK_Connection_Errors.invalidServerURI(url), refCon: inRefCon)
        }
    }

    /* ################################################################## */
    /**
     This fetches objects from the security database server.
     
     - parameter inIntegerIDs: An Array of Int, with the security database item IDs.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _fetchLoginItems(_ inIntegerIDs: [Int], refCon inRefCon: Any?) {
        var fetchIDs: [Int] = []
        var cachedObjects: [A_RVP_Cocoa_SDK_Object] = []
        
        // First, we look for cached instances. If we have them, we send them to the delegate.
        for var id in inIntegerIDs {
            for dataItem in self where dataItem is A_RVP_Cocoa_SDK_Security_Object && dataItem.id == id {
                cachedObjects.append(dataItem)
                id = 0
            }
            
            if 0 < id { // We'll need to fetch this one.
                fetchIDs.append(id)
            }
        }
        
        if !cachedObjects.isEmpty {
            self._sendItemsToDelegate(cachedObjects, refCon: inRefCon)   // We just send our cached items to the delegate right away.
        }
        
        if !fetchIDs.isEmpty {  // If we didn't find everything we were looking for in the junk drawer, we will be asking the server for the remainder.
            fetchIDs = fetchIDs.sorted()    // Just because we're anal...
            
            // This uses our extension to break the array up. This is to reduce the size of the GET URI.
            for idArray in fetchIDs.chunk(10) {
                self._fetchLoginItemsFromServer((idArray.map(String.init)).joined(separator: ","), refCon: inRefCon)
            }
        } else {
            Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                self._openOperations += 1   // This triggers a call to the delegate, saying we're done.
                self._openOperations -= 1
            }
        }
    }
    
    /* ################################################################## */
    /**
     This fetches objects from the security database server.
     
     - parameter inLoginIDs: An Array of String, with the login string IDs.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _fetchLoginItems(_ inLoginIDs: [String], refCon inRefCon: Any?) {
        var fetchIDs: [String] = []
        var cachedObjects: [A_RVP_Cocoa_SDK_Object] = []
        
        // First, we look for cached instances. If we have them, we send them to the delegate.
        for var id in inLoginIDs {
            for dataItem in self where dataItem is A_RVP_Cocoa_SDK_Security_Object {
                if let secItem = dataItem as? A_RVP_Cocoa_SDK_Security_Object, secItem.loginID == id {
                    cachedObjects.append(dataItem)
                    id = ""
                }
            }
            
            if !id.isEmpty { // We'll need to fetch this one.
                fetchIDs.append(id)
            }
        }
        
        if !cachedObjects.isEmpty {
            self._sendItemsToDelegate(cachedObjects, refCon: inRefCon)   // We just send our cached items to the delegate right away.
        }
        
        if !fetchIDs.isEmpty {  // If we didn't find everything we were looking for in the junk drawer, we will be asking the server for the remainder.
            fetchIDs = fetchIDs.sorted()    // Just because we're anal...
            
            // This uses our extension to break the array up. This is to reduce the size of the GET URI.
            for idArray in fetchIDs.chunk(10) {
                self._fetchLoginItemsFromServer(idArray.joined(separator: ","), refCon: inRefCon)
            }
        } else {
            Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                self._openOperations += 1   // This triggers a call to the delegate, saying we're done.
                self._openOperations -= 1
            }
        }
    }
    
    /* ################################################################## */
    /**
     This will ask the server to inform us as to who has access to the given security token.
     
     - parameter inTokens: An array of integers, representing the tokens we're testing.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _countWhoHasAccessToTheseSecurityTokens(_ inTokens: [Int], refCon inRefCon: Any?) {
        var loginParams = self._loginParameters
        
        if !loginParams.isEmpty {
            loginParams = "&" + loginParams
        }
        
        let tokenString = inTokens.compactMap { String($0) }.joined(separator: ",")
        let url = self._server_uri + "/json/baseline/tokens/\(tokenString)?count_access_to" + loginParams   // We ask who has access to the given tokens.
        // The request is a simple GET task, so we can just use a straight-up task for this.
        Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
            self._openOperations += 1
        }
        if let url_object = URL(string: url) {
            let fetchTask = self._connectionSession.dataTask(with: url_object) { [unowned self] data, response, error in
                if let error = error {
                    self._handleError(error, refCon: inRefCon)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                        self._handleHTTPError(response as? HTTPURLResponse ?? nil, refCon: inRefCon)
                        return
                }
                // We have a specific structure, which we'll unwind, and turn into a simple Int:Int Dictionary.
                if let mimeType = httpResponse.mimeType, "application/json" == mimeType, let myData = data {
                    do {
                        let temp = try JSONSerialization.jsonObject(with: myData, options: [])
                        
                        if let main_object = temp as? NSDictionary,
                           let baseline = main_object.object(forKey: "baseline") as? NSDictionary,
                           let count_access_to = baseline.object(forKey: "count_access_to") as? [[String: Int]] {
                            var accessDictionary: [Int: Int] = [:]
                            for elem in count_access_to {
                                if let token = elem["token"], let access = elem["access"] {
                                    accessDictionary[token] = access
                                }
                            }
                            self._delegate?.sdkInstance(self, tokenAccessTest: accessDictionary, refCon: inRefCon)
                        }
                    } catch {
                        self._handleError(SDK_Data_Errors.invalidData(myData), refCon: inRefCon)
                    }
                } else {
                    self._handleError(SDK_Data_Errors.invalidData(data), refCon: inRefCon)
                }
                
                Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                    self._openOperations -= 1
                }
            }
            
            fetchTask.resume()
        } else {
            self._handleError(SDK_Connection_Errors.invalidServerURI(url), refCon: inRefCon)
        }
    }

    /* ################################################################## */
    /**
     This asks the server to fetch the logins that have access to this token.
     
     - parameter inToken: An Integer, with the token ID.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _fetchIDsOfLoginsThatHaveThisToken(_ inToken: Int, refCon inRefCon: Any?) {
        var loginParams = self._loginParameters
        
        if !loginParams.isEmpty {
            loginParams = "?" + loginParams
        }
        
        let url = self._server_uri + "/json/baseline/visibility/token/\(inToken)" + loginParams   // We ask who has access to the given tokens.
        // The request is a simple GET task, so we can just use a straight-up task for this.
        Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
            self._openOperations += 1
        }
        if let url_object = URL(string: url) {
            let fetchTask = self._connectionSession.dataTask(with: url_object) { [unowned self] data, response, error in
                if let error = error {
                    self._handleError(error, refCon: inRefCon)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                        self._handleHTTPError(response as? HTTPURLResponse ?? nil, refCon: inRefCon)
                        return
                }
                // We have a specific structure, which we'll unwind, and turn into a simple Int:Int Dictionary.
                if let mimeType = httpResponse.mimeType, "application/json" == mimeType, let myData = data {
                    do {
                        let temp = try JSONSerialization.jsonObject(with: myData, options: [])
                        
                        if let main_object = temp as? NSDictionary,
                           let baseline = main_object.object(forKey: "baseline") as? NSDictionary,
                           let testResult = baseline.object(forKey: "token") as? NSDictionary,
                           let token = testResult.object(forKey: "token") as? Int,
                           let login_ids = testResult.object(forKey: "login_ids") as? [Int] {
                            self._delegate?.sdkInstance(self, tokenAccessTest: (token: token, logins: login_ids), refCon: inRefCon)
                        }
                    } catch {
                        self._handleError(SDK_Data_Errors.invalidData(myData), refCon: inRefCon)
                    }
                } else {
                    self._handleError(SDK_Data_Errors.invalidData(data), refCon: inRefCon)
                }
                
                Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                    self._openOperations -= 1
                }
            }
            
            fetchTask.resume()
        } else {
            self._handleError(SDK_Connection_Errors.invalidServerURI(url), refCon: inRefCon)
        }
    }
 
    /* ################################################################## */
    /**
     This asks the server to fetch the users that have access to this token.
     
     - parameter inToken: An Integer, with the token ID.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _fetchIDsOfUsersThatHaveThisToken(_ inToken: Int, refCon inRefCon: Any?) {
        var loginParams = self._loginParameters
        
        if !loginParams.isEmpty {
            loginParams = "&" + loginParams
        }
        
        let url = self._server_uri + "/json/baseline/visibility/token/\(inToken)?users" + loginParams   // We ask who has access to the given tokens.
        // The request is a simple GET task, so we can just use a straight-up task for this.
        Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
            self._openOperations += 1
        }
        if let url_object = URL(string: url) {
            let fetchTask = self._connectionSession.dataTask(with: url_object) { [unowned self] data, response, error in
                if let error = error {
                    self._handleError(error, refCon: inRefCon)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                        self._handleHTTPError(response as? HTTPURLResponse ?? nil, refCon: inRefCon)
                        return
                }
                // We have a specific structure, which we'll unwind, and turn into a simple Int:Int Dictionary.
                if let mimeType = httpResponse.mimeType, "application/json" == mimeType, let myData = data {
                    do {
                        let temp = try JSONSerialization.jsonObject(with: myData, options: [])
                        
                        if let main_object = temp as? NSDictionary,
                           let baseline = main_object.object(forKey: "baseline") as? NSDictionary,
                           let testResult = baseline.object(forKey: "token") as? NSDictionary,
                           let token = testResult.object(forKey: "token") as? Int {
                           if let login_ids = testResult.object(forKey: "login_ids") as? [Int] {
                                self._delegate?.sdkInstance(self, tokenAccessTest: (token: token, logins: login_ids), refCon: inRefCon)
                           } else if let user_ids = testResult.object(forKey: "user_ids") as? [Int] {
                                self._delegate?.sdkInstance(self, tokenAccessTest: (token: token, users: user_ids), refCon: inRefCon)
                           }
                        }
                    } catch {
                        self._handleError(SDK_Data_Errors.invalidData(myData), refCon: inRefCon)
                    }
                } else {
                    self._handleError(SDK_Data_Errors.invalidData(data), refCon: inRefCon)
                }
                
                Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                    self._openOperations -= 1
                }
            }
            
            fetchTask.resume()
        } else {
            self._handleError(SDK_Connection_Errors.invalidServerURI(url), refCon: inRefCon)
        }
    }

    /* ################################################################## */
    /**
     This fetches thing objects from the data database server.
     
     - parameter inKeys: An Array of String, with the thing keys.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _fetchThings(_ inKeys: [String], refCon inRefCon: Any?) {
        var fetchKeys: [String] = []
        var cachedObjects: [A_RVP_Cocoa_SDK_Object] = []

        // First, we look for cached instances. If we have them, we send them to the delegate.
        for var key in inKeys {
            for dataItem in self where dataItem is RVP_Cocoa_SDK_Thing {
                if let thing = dataItem as? RVP_Cocoa_SDK_Thing, thing.thingKey == key {
                    cachedObjects.append(thing)
                    key = ""
                }
            }
            
            if !key.isEmpty { // We'll need to fetch this one.
                fetchKeys.append(key)
            }
        }
        
        if !cachedObjects.isEmpty {
            self._sendItemsToDelegate(cachedObjects, refCon: inRefCon)   // We just send our cached items to the delegate right away.
        }
        
        if !fetchKeys.isEmpty {  // If we didn't find everything we were looking for in the junk drawer, we will be asking the server for the remainder.
            // This uses our extension to break the array up. This is to reduce the size of the GET URI.
            for keyArray in fetchKeys.chunk(10) {
                var loginParams = self._loginParameters
                
                if !loginParams.isEmpty {
                    loginParams = "&" + loginParams
                }
                let url = self._server_uri + "/json/things/" + keyArray.map({$0.urlEncodedString ?? ""}).joined(separator: ",") + "?show_details" + loginParams   // We will be asking for the "full Monty".
                // The request is a simple GET task, so we can just use a straight-up task for this.
                Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                    self._openOperations += 1
                }
                if let url_object = URL(string: url) {
                    let fetchTask = self._connectionSession.dataTask(with: url_object) { [unowned self] data, response, error in
                        if let error = error {
                            self._handleError(error, refCon: inRefCon)
                            return
                        }
                        guard let httpResponse = response as? HTTPURLResponse,
                            (200...299).contains(httpResponse.statusCode) else {
                                self._handleHTTPError(response as? HTTPURLResponse ?? nil, refCon: inRefCon)
                                return
                        }
                        
                        if let mimeType = httpResponse.mimeType, "application/json" == mimeType, let myData = data {
                            if let objectArray = self._makeInstance(data: myData, refCon: inRefCon) {
                                self._dataItems.append(contentsOf: objectArray)
                                self._sortDataItems()
                                self._sendItemsToDelegate(objectArray, refCon: inRefCon)
                            }
                        } else {
                            self._handleError(SDK_Data_Errors.invalidData(data), refCon: inRefCon)
                        }
                        
                        Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                            self._openOperations -= 1
                        }
                    }
                    
                    fetchTask.resume()
                } else {
                    self._handleError(SDK_Connection_Errors.invalidServerURI(url), refCon: inRefCon)
                }
            }
        } else {
            Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                self._openOperations += 1   // This triggers a call to the delegate, saying we're done.
                self._openOperations -= 1
            }
        }
    }

    /* ################################################################## */
    /**
     This method fetches the plugin array from the server. This is used as a "validity" test.
     A valid server will always return this list, and you don't need to be logged in.
     
     - parameter inGetVersion: If this is true (default), then we get the version first, then the plugins.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _validateServer(_ inGetVersion: Bool = true, refCon inRefCon: Any?) {
        let url = self._server_uri + "/json/baseline" + (inGetVersion ? "/version" : "")
        // The plugin list is a simple GET task, so we can just use a straight-up task for this.
        if let url_object = URL(string: url) {
            Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                self._openOperations += 1
            }
            let baselineTask = self._connectionSession.dataTask(with: url_object) { data, response, error in
                if let error = error {
                    self._handleError(error, refCon: inRefCon)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                        self._handleHTTPError(response as? HTTPURLResponse ?? nil, refCon: inRefCon)
                        return
                }
                if let mimeType = httpResponse.mimeType, "application/json" == mimeType, let data = data {
                    if inGetVersion {
                        _ = self._parseBaselineResponse(data: data, refCon: inRefCon)
                        self._validateServer(false, refCon: inRefCon)
                    } else if let plugins = self._parseBaselineResponse(data: data, refCon: inRefCon) as? [String: [String]] {
                        if let plugin_array = plugins["plugins"] {
                            self._plugins = plugin_array
                            self._reportSessionValidity(refCon: inRefCon)   // We report whether or not this session is valid.
                            self._callDelegateLoginValid(self.isLoggedIn, refCon: inRefCon)   // OK. We're done. Tell the delegate whether or not we are logged in.
                        }
                    }
                } else {
                    self._handleError(SDK_Data_Errors.invalidData(data), refCon: inRefCon)
                }
                
                Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                    self._openOperations -= 1
                }
            }
            
            baselineTask.resume()
        } else {
            self._handleError(SDK_Connection_Errors.invalidServerURI(url), refCon: inRefCon)
        }
    }

    /* ################################################################## */
    /**
     This method will do a search of the server, based on the input data.
     
     If the inTagValues Dictionary is non-empty, then the keys and values will be used to initiate a serach on the plugin selected by inPlugin.
     if a value in inTagValues is an empty String (""), then the search will search explicitly for objects that do not have a value in that tag.
     if a value in inTagValues has only a wildcard ("%"), then that means that only objects that have non-empty values of that tag will be returned; regardless of the content of the tag.
     NOTE: Wildcard in tag0 (key) of Things will not work.
     
     If andLocation is non-nil, then it needs to have a location, and possibly a radius and auto-radius.
     
     - parameter inTagValues: This is a pre-formatted Dictionary of keys and values
     - parameter andLocation: This is an optional location/radius specifier. If not specified, location will not be considered.
     - parameter withPlugin: This is the plugin to search. It can be: "baseline", "people", "places", "things"
     - parameter maxRadiusInKm: This is a "maximum radius." If left at 0, then only one radius search will be done.
                                If more than zero, and more than the radius in the location, then the radius will be increaed by the auto-radius step size, and another call will be made,
                                if the threshold has not been satisfied. If no location is given, this is ignored.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _fetchObjectsByString(_ inTagValues: [String: String], andLocation inLocation: LocationSpecification? = nil, withPlugin inPlugin: String, maxRadiusInKm inMaxRadiusInKm: Double = 0, refCon inRefCon: Any?) {
        var plugin = inPlugin
        var tagValues = inTagValues
        
        // If either threshold or maxRadius is zero, we won't be doing another search.
        // See if an auto-radius threshold has been specified.
        var threshold: Int = 0
        // See if a valid max radius was specified.
        var maxRadius = inMaxRadiusInKm
        
        var currentLocation = inLocation
        
        if var location = currentLocation {
            if let thresh = location.autoRadiusThreshold, 0 < thresh {
                threshold = thresh
                // If we are in an auto-radius search, and are just beginning, then we start at the beginning with one step size.
                if location.radiusInKm == inMaxRadiusInKm, 0 < inMaxRadiusInKm {
                    location.radiusInKm = self.autoRadiusStepSizeInKm
                } else if 0 == maxRadius {    // If we have no maximum size, then we are not doing an auto-radius.
                    threshold = 0
                } else {    // Otherwise, One Step Beyond...
                    location.radiusInKm += self.autoRadiusStepSizeInKm
                }
                let radius = location.radiusInKm
                location.radiusInKm = radius
            } else {
                maxRadius = 0   // If we don't have a threshold, we don't have auto-radius.
                threshold = 0
            }
            
            if 0 > maxRadius || (location.radiusInKm >= maxRadius) {   // If we are at the maximum, we're done.
                maxRadius = 0
                threshold = 0
            }
            
            currentLocation! = location
        } else {
            maxRadius = 0   // Can't have a max radius with no location.
            threshold = 0
        }

        // A couple of plugins need an extra step on the resource locator.
        switch plugin {
        case "baseline":
            plugin += "/search/?"
        case "people":
            plugin += "/people/?show_details&"
        case "things":
            if let thingKey = tagValues["key"], let key = thingKey.urlEncodedString {
                tagValues.removeValue(forKey: "key")
                plugin += "/" + key
            }
            plugin += "/?show_details&"
        default:
            plugin += "/?show_details&"
        }
        
        if let location = currentLocation {
            tagValues["latitude"] = String(location.coords.latitude)
            tagValues["longitude"] = String(location.coords.longitude)
            tagValues["radius"] = String(location.radiusInKm)
        }
        
        // This handles any login parameters.
        var loginParams = self._loginParameters
        
        if !loginParams.isEmpty {
            loginParams += "&"
        }
        
        // We join the various text items.
        let url = self._server_uri + "/json/" + plugin + loginParams + (tagValues.compactMap({ (key, value) -> String in
            if let value = value.urlEncodedString {
                return "search_\(key)=\(value)"
            }
            
            return ""
        }) as Array).joined(separator: "&")
        
        self._fetchObjectsByStringPartDeux(url, tags: inTagValues, andLocation: currentLocation, withPlugin: inPlugin, maxRadiusInKm: maxRadius, threshold: threshold, refCon: inRefCon)
    }
    
    /* ################################################################## */
    /**
     This method will execute the search set up previously (split to reduce CC).
     
     If the inTagValues Dictionary is non-empty, then the keys and values will be used to initiate a serach on the plugin selected by inPlugin.
     if a value in inTagValues is an empty String (""), then the search will search explicitly for objects that do not have a value in that tag.
     if a value in inTagValues has only a wildcard ("%"), then that means that only objects that have non-empty values of that tag will be returned; regardless of the content of the tag.
     
     If andLocation is non-nil, then it needs to have a location, and possibly a radius and auto-radius.
     
     - parameter inTagValues: This is a pre-formatted Dictionary of keys and values
     - parameter andLocation: This is an optional location/radius specifier. If not specified, location will not be considered.
     - parameter withPlugin: This is the plugin to search. It can be: "baseline", "people", "places", "things"
     - parameter maxRadiusInKm: This is a "maximum radius." If left at 0, then only one radius search will be done. If more than zero, and more than the radius in the location, then the radius will be increaed by the auto-radius step size, and another call will be made, if the threshold has not been satisfied. If no location is given, this is ignored.
     - parameter threshold: This is an Int with a minimum count threshold. Default is 0.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _fetchObjectsByStringPartDeux(_ inUrl: String, tags inTagValues: [String: String], andLocation inLocation: LocationSpecification! = nil, withPlugin inPlugin: String, maxRadiusInKm inMaxRadiusInKm: Double = 0, threshold inThreshold: Int = 0, refCon inRefCon: Any?) {
        // The request is a simple GET task, so we can just use a straight-up task for this.
        if let url_object = URL(string: inUrl) {
            Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                self._openOperations += 1
            }
            let fetchTask = self._connectionSession.dataTask(with: url_object) { [unowned self] data, response, error in
                if let error = error {
                    self._handleError(error, refCon: inRefCon)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                        self._handleHTTPError(response as? HTTPURLResponse ?? nil, refCon: inRefCon)
                        return
                }
                
                if let mimeType = httpResponse.mimeType, "application/json" == mimeType, let myData = data {
                    if "baseline" == inPlugin {
                        let plugins = self._parseBaselineResponse(data: myData, refCon: inRefCon)
                        var ids: [Int] = []
                        
                        for pluginTup in plugins {
                            if let value = pluginTup.value as? [Int] {
                                ids.append(contentsOf: value)
                            }
                        }
                        
                        // If we are at the maximum for an auto-radius search, or we are not doing an auto-radius search, we simply fetch all the results as objects.
                        if let location = inLocation, ids.count >= inThreshold || location.radiusInKm >= inMaxRadiusInKm {
                            self._delegate?.sdkInstanceFinalAutoRadiusCall(self, refCon: inRefCon)  // If we are at the end of our rope, we let the delegate know.
                            self._sendIDsToDelegate(ids, isFinal: true, refCon: inRefCon)
                            self._fetchBaselineObjectsByID(ids, refCon: inRefCon)
                        } else if nil != inLocation {
                            self._sendIDsToDelegate(ids, refCon: inRefCon)
                            self._fetchObjectsByString(inTagValues, andLocation: inLocation, withPlugin: inPlugin, maxRadiusInKm: inMaxRadiusInKm, refCon: inRefCon)
                        } else {
                            self._fetchBaselineObjectsByID(ids, refCon: inRefCon)
                        }
                    } else {
                        if let objectArray = self._makeInstance(data: myData, refCon: inRefCon) {
                            self._dataItems.append(contentsOf: objectArray)
                            self._sortDataItems()
                            self._sendItemsToDelegate(objectArray, refCon: inRefCon)
                            if let location = inLocation, objectArray.count >= inThreshold || location.radiusInKm >= inMaxRadiusInKm {  // If we are at the end of our rope, we let the delegate know.
                                self._delegate?.sdkInstanceFinalAutoRadiusCall(self, refCon: inRefCon)
                            }
                        } else if let location = inLocation, location.radiusInKm >= inMaxRadiusInKm {
                        }
                        
                        // If we are doing an auto-radius search, and aren't done yet, we go again.
                        if let location = inLocation, 0 < inMaxRadiusInKm, self._dataItems.count < inThreshold, location.radiusInKm < inMaxRadiusInKm {
                            self._fetchObjectsByString(inTagValues, andLocation: inLocation, withPlugin: inPlugin, maxRadiusInKm: inMaxRadiusInKm, refCon: inRefCon)
                        }
                    }
                } else {
                    self._handleError(SDK_Data_Errors.invalidData(data), refCon: inRefCon)
                }
                
                Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                    self._openOperations -= 1
                }
            }
            
            fetchTask.resume()
        } else {
            self._handleError(SDK_Connection_Errors.invalidServerURI(inUrl), refCon: inRefCon)
        }
    }
    
    /* ################################################################## */
    /**
     This sends a PUT command to the server.
     
     - parameter inURI: The URI to send to the server.
     - parameter payloadData: This is a String, containing Base64-encoded data to be sent as a payload.
     - parameter objectInstance: The instance of the data object that called this.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _sendPUTData(_ inURI: String, payloadData inPayloadString: String, objectInstance inObjectInstance: A_RVP_Cocoa_SDK_Object?, refCon inRefCon: Any?) {
        if let url_object = URL(string: inURI) {
            let urlRequest = NSMutableURLRequest(url: url_object)
            urlRequest.httpMethod = "PUT"
            let payloadData = inPayloadString.data(using: .utf8) ?? Data()  // Since we have already got Base64 data, we don't need to re-encode it. You need an empty Data object if no payload.
            
            Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                self._openOperations += 1
            }
            
            self._connectionSession.uploadTask(with: urlRequest as URLRequest, from: payloadData) { [unowned self, weak inObjectInstance] data, response, error in
                if let error = error {
                    self._handleError(error, refCon: inRefCon)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                        self._handleHTTPError(response as? HTTPURLResponse ?? nil, refCon: inRefCon)
                        return
                }
                
                if let data = data {    // Assuming we got a response, we send that to the instance that called us.
                    inObjectInstance?._handleChangeResponse(data, refCon: inRefCon)
                }
                
                Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                    self._openOperations -= 1
                }
            }.resume()
        }
    }
    
    /* ################################################################## */
    /**
     This sends a POST command to the server.
     
     - parameter inURI: The URI to send to the server.
     - parameter payloadData: This is a String, containing Base64-encoded data to be sent as a payload. It is optional (empty, if ommitted)
     - parameter objectInstance: The instance of the data object that called this.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _sendPOSTData(_ inURI: String, payloadData inPayloadString: String = "", objectInstance inObjectInstance: A_RVP_Cocoa_SDK_Object?, refCon inRefCon: Any?) {
        if let url_object = URL(string: inURI) {
            var urlRequest = URLRequest(url: url_object)
            urlRequest.httpMethod = "POST"
            if !inPayloadString.isEmpty {
                let boundary = "Boundary-\(NSUUID().uuidString)"
                urlRequest.setValue("Content-Type: multipart/form-data", forHTTPHeaderField: "Expect")
                urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                let payloadData = inPayloadString.data(using: .utf8) ?? Data()  // Since we have already got Base64 data, we don't need to re-encode it. You need an empty Data object if no payload.
                var body = Data()
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition:form-data; name=\"payload\"; filename=\"payload\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append(payloadData)
                body.append("\r\n--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
                urlRequest.httpBody = body as Data
            }
            
            Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                self._openOperations += 1
            }
            
            if let session = self._connectionSession {
                session.dataTask(with: urlRequest) { [unowned self, weak inObjectInstance] data, response, error in
                    if let error = error {
                        self._handleError(error, refCon: inRefCon)
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                        (200...299).contains(httpResponse.statusCode) else {
                            self._handleHTTPError(response as? HTTPURLResponse ?? nil, refCon: inRefCon)
                            return
                    }

                    if let data = data,    // Assuming we got a response, we send that to the instance that called us.
                       let callback = inObjectInstance?._handleChangeResponse {
                        callback(data, inRefCon)
                    }

                    Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                        self._openOperations -= 1
                    }
                }.resume()
            }
        }
    }
    
    /* ################################################################## */
    /**
     This sends a DELETE command to the server.
     
     - parameter inURI: The URI to send to the server.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    private func _sendDelete(_ inURI: String, refCon inRefCon: Any?) {
        if let url_object = URL(string: inURI) {
            var urlRequest = URLRequest(url: url_object)
            urlRequest.httpMethod = "DELETE"
            
            Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                self._openOperations += 1
            }
            
            self._connectionSession?.uploadTask(with: urlRequest, from: Data()) { [unowned self] data, response, error in
                if let error = error {
                    self._handleError(error, refCon: inRefCon)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                        self._handleHTTPError(response as? HTTPURLResponse ?? nil, refCon: inRefCon)
                        return
                }
                
                if let data = data {    // Assuming we got a response, we send that to the instance that called us.
                    do {    // Extract a usable object from the given JSON data.
                        let parsedObject: Any = try JSONSerialization.jsonObject(with: data, options: [])
                        
                        var resultList: [A_RVP_Cocoa_SDK_Object] = []  // This will contain our deleted items.
                        var parent: String = ""
                        
                        // Yeah, this is an awkward mess, but Swift isn't quite flexible enough to let me do the kind of freewheeling casting that I can get away with in PHP.
                        // This allows us to have two levels deep results, with generic plugin names.
                        // If we ever get around to writing more plugins, this will need to be revisited, but so will some other stuff in the SDK.
                        if let parsedDictionary = parsedObject as? [String: Any] {
                            for keyValue in parsedDictionary {
                                if let secondLevel = keyValue.value as? [String: Any] {
                                    for nextKeyValue in secondLevel {
                                        if let resultArray = nextKeyValue.value as? [[String: Any]] {
                                            parent = keyValue.key
                                            for item in resultArray {
                                                if let itemObject = self._makeNewInstanceFromDictionary(item, parent: parent, forceNew: true) {
                                                    resultList.append(itemObject)
                                                }
                                            }
                                        } else if let thirdLevel = nextKeyValue.value as? [String: Any] {
                                            for yetAnotherKeyValue in thirdLevel {
                                                if let resultArray = yetAnotherKeyValue.value as? [[String: Any]] {
                                                    parent = yetAnotherKeyValue.key
                                                    for item in resultArray {
                                                        if let itemObject = self._makeNewInstanceFromDictionary(item, parent: parent, forceNew: true) {
                                                            resultList.append(itemObject)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        // If we got any objects, we simply flush our cache, and send the items to the delegate.
                        if !resultList.isEmpty {
                            self.flushCache()
                            self._delegate?.sdkInstance(self, deletedDataItems: resultList, refCon: inRefCon)
                        }
                    } catch {   // We end up here if the response is not a proper JSON object.
                        self._handleError(RVP_Cocoa_SDK.SDK_Data_Errors.invalidData(data), refCon: inRefCon)
                    }
                }
                
                Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                    self._openOperations -= 1
                }
                }.resume()
        }
    }

    /* ################################################################## */
    // MARK: - Internal Stored Properties
    /* ################################################################## */
    /**
     This is a semaphore that is set when we are creating a user/login pair.
     The way that this works, is that the main appl calls createUserLoginPair(loginString:,name:),
     and this semaphore is set. The SDK then attempts to create the login object.
     If that is successful, then it will continue, and create the user object to accompany
     the new login object, after informing the delegate of the new login object, but will not be called
     with the sdkInstance(_:,fetchedDataItems:) call.
     If the login object creation fails, the main app delegate will be called with an error.
     If it is successful, the delegate is then called with the new user object,
     */
    internal var _creatingUserLoginPair: Bool = false

    /** This will contain the temporary new user during a login/user creation. */
    internal var _newUserInstance: A_RVP_Cocoa_SDK_Object!

    /* ################################################################## */
    // MARK: - Internal Instance Methods
    /* ################################################################## */
    /**
     We simply make sure that we clean up after ourselves.
     */
    deinit {
        if nil != self._connectionSession {
            if self._newSession {   // We only nuke the session if we created it.
                self._connectionSession.finishTasksAndInvalidate()   // Take off and nuke the site from orbit. It's the only way to be sure.
            }
            self._connectionSession = nil   // Just to be anal.
        }
    }
    
    /* ################################################################## */
    /**
     This is called with a list of one or more data items to be sent to the delegate.
     
     - parameter inItemArray: An Array of concrete instances of subclasses of A_RVP_IOS_SDK_Object.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    internal func _sendItemsToDelegate(_ inItemArray: [A_RVP_Cocoa_SDK_Object], refCon inRefCon: Any?) {
        self._delegate?.sdkInstance(self, fetchedDataItems: inItemArray, refCon: inRefCon)
    }
    
    /* ################################################################## */
    /**
     This is called to issue a PUT command to convert the login instance to a manager or a standard user. Nothing will happen, if it is already the destination type.
     The God Admin login cannot be changed.
     
     - parameter: The login object to convert.
     - parameter toManager: If true, then the login will be converted to a manager.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    internal func _convertLogin(_ inLogin: RVP_Cocoa_SDK_Login?, toManager inToManager: Bool, refCon inRefCon: Any?) {
        if !(inLogin?.isMainAdmin ?? false),                        // God can't be changed.
           inLogin?.isWriteable ?? false,                         // We have to have write permission.
           !(inLogin?.isManager ?? false && inToManager),         // There has to be an actual change.
           !(inLogin?.isManager ?? false) && !inToManager {
            #if DEBUG
                print("Converting \"\(inLogin?.loginID ?? "ERROR")\" to a \(inToManager ? "manager" : "user").")
            #endif
            var uri = self._server_uri + "/json"
            uri += (inLogin?._pluginPath ?? "") + "?convert_to_" + (inToManager ? "manager" : "login") + "&" + self._loginParameters
            self._sendPUTData(uri, payloadData: "", objectInstance: inLogin, refCon: inRefCon)
        }
    }

    /* ################################################################## */
    /**
     This executes a PUT query to the server, sending the data as necessary.
     
     - parameter inPutObject: The object to send to the server.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    internal func _putObject(_ inObjectToPut: A_RVP_Cocoa_SDK_Object?, refCon inRefCon: Any?) {
        var uri = ""
        var payloadString = ""
        
        if inObjectToPut?.isDirty ?? false {
            uri = inObjectToPut?._saveChangesURI ?? "" // First, get the changes URI.
        }
        
        // If we have a dirty payload, then we take care of that here.
        if let dataObject = inObjectToPut as? A_RVP_Cocoa_SDK_Data_Object,
           dataObject.isPayloadDirty,
           let tempPayloadString = dataObject.rawBase64Payload {
            if !tempPayloadString.isEmpty {
                payloadString = tempPayloadString
            } else {    // Removal is easy.
                if !uri.isEmpty {
                    uri += "&"
                }
                uri += "remove_payload"
            }
        } else if let dataObject = inObjectToPut as? A_RVP_Cocoa_SDK_Data_Object, dataObject.isPayloadDirty {   // Otherwise, we may need to specifically remove it.
            if !uri.isEmpty {
                uri += "&"
            }
            uri += "remove_payload"
        }
        
        if !uri.isEmpty || !payloadString.isEmpty {
            // This handles any login parameters.
            let loginParams = self._loginParameters
            
            if !loginParams.isEmpty {
                let uriTemp = self._server_uri + "/json" + (inObjectToPut?._pluginPath ?? "")
                uri = uriTemp + "?" + loginParams + "&" + uri
                
                if inObjectToPut?.isNew ?? false {
                    // If we are creating a new user with a login, we may want to ask for new personal tokens to be added.
                    if ("/people/people/" == inObjectToPut?._pluginPath && uri.contains("&login_id=")) || ("/people/logins/" == inObjectToPut?._pluginPath),
                       0 < number_of_personal_tokens_per_login {
                        uri += "&number_of_personal_tokens=\(number_of_personal_tokens_per_login)"
                    }
                    self._sendPOSTData(uri, payloadData: payloadString, objectInstance: inObjectToPut, refCon: inRefCon)
                } else {
                    self._sendPUTData(uri, payloadData: payloadString, objectInstance: inObjectToPut, refCon: inRefCon)
                }
            }
        }
    }

    /* ################################################################## */
    /**
     This executes a POST query to the server, sending the data as necessary.
     
     - parameter inPOSTObject: The object to send to the server.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    internal func _postObject(_ inPOSTObject: A_RVP_Cocoa_SDK_Object, refCon inRefCon: Any?) {
        var uri = ""
        
        if inPOSTObject.isDirty {
            uri = inPOSTObject._saveChangesURI // First, get the changes URI.
        }
        
        if !uri.isEmpty {
            // This handles any login parameters.
            let loginParams = self._loginParameters
            
            if !loginParams.isEmpty {
                uri = self._server_uri + "/json" + inPOSTObject._pluginPath + "?" + loginParams + "&" + uri
                
                self._sendPOSTData(uri, objectInstance: inPOSTObject, refCon: inRefCon)
            }
        }
    }

    /* ################################################################## */
    /**
     This is called to send any errors back to the delegate.
     
     - parameter inError: The error being handled.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    internal func _handleError(_ inError: Error, refCon inRefCon: Any?) {
        self._newUserInstance = nil
        self._creatingUserLoginPair = false
        self._delegate?.sdkInstance(self, sessionError: inError, refCon: inRefCon)
    }
    
    /* ################################################################## */
    /**
     This is called to handle an HTTP Status error. It will call the _handleError() method.
     
     - parameter inResponse: The HTTP Response object being handled.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    internal func _handleHTTPError(_ inResponse: HTTPURLResponse?, refCon inRefCon: Any?) {
        if let response = inResponse {
            let error = HTTPError(code: response.statusCode, description: "")
            self._handleError(error, refCon: inRefCon)
        }
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
     - parameter forceNew: If true (default is false), then a brand new instance will be returned; whether or not we have a cache (Meaning it's an independent copy -caveat emptor). Also, forced items will not be added to our cache. We Use the Force [Luke] to store before and after objects in the change records.
     
     - returns: A new subclass instance of A_RVP_IOS_SDK_Object, or nil.
     */
    internal func _makeNewInstanceFromDictionary(_ inDictionary: [String: Any], parent inParent: String, forceNew inForceNew: Bool = false) -> A_RVP_Cocoa_SDK_Object? {
        var ret: A_RVP_Cocoa_SDK_Object?
        var instance: A_RVP_Cocoa_SDK_Object?
        
        if nil != inDictionary["login_id"] {    // We can easily determine whether or not this is a login. If so, we create a login object. This will be the only security database item.
            instance = RVP_Cocoa_SDK_Login(sdkInstance: self, objectInfoData: inDictionary)
        } else {    // The login was low-hanging fruit. For the rest, we need to depend on the "parent" passed in.
            switch inParent {
            case "my_info", "people":
                instance = RVP_Cocoa_SDK_User(sdkInstance: self, objectInfoData: inDictionary)
                
            case "places":
                instance = RVP_Cocoa_SDK_Place(sdkInstance: self, objectInfoData: inDictionary)
                
            case "things":
                instance = RVP_Cocoa_SDK_Thing(sdkInstance: self, objectInfoData: inDictionary)
            
            default:
                instance = nil
            }
        }
        
        // Assuming we got something, we compare the temporary allocation with what we have in our cache.
        if nil != instance {
            // If we already have this object, and we are not forcing, we return our cached instance, instead of the one we just allocated.
            if !inForceNew, let existingInstance = self._findDatabaseItem(compInstance: instance!) {
                ret = existingInstance
            } else {    // Otherwise, we add our new instance to the cache, sort the cache, and return the instance. Forced items are not cached.
                if !inForceNew {
                    self._dataItems.append(instance!)
                    self._sortDataItems()
                }
                ret = instance
            }
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     This is called when we want to send a newly-minted object from the server to the delegate.
     
     - parameter inNewObject: The object to be sent to the delegate.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    internal func _callDelegateNewItem(_ inNewObject: A_RVP_Cocoa_SDK_Object, refCon inRefCon: Any?) {
        self._delegate?.sdkInstance(self, newObject: inNewObject, refCon: inRefCon)
    }

    /* ################################################################## */
    /**
     This is called when we want to send a changed object from the server to the delegate.
     
     - parameter inChangedObject: The object to be sent to the delegate.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    internal func _callDelegateChangedItem(_ inChangedObject: A_RVP_Cocoa_SDK_Object, refCon inRefCon: Any?) {
        self._delegate?.sdkInstance(self, changedObject: inChangedObject, refCon: inRefCon)
    }

    /* ################################################################## */
    // MARK: - Internal URLSessionDelegate Protocol Methods
    /* ################################################################## */
    /**
     This is called when the the session becomes invalid for any reason.
     
     - parameter session: The session calling this.
     - parameter didBecomeInvalidWithError: The error (if any) that caused the invalidation.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?, refCon inRefCon: Any?) {
        self._plugins = []  // This makes the session invalid.
        if let error = error {  // If there was an error, we report it first.
            self._handleError(error, refCon: inRefCon)
        }
        self._reportSessionValidity(refCon: inRefCon)   // Report the invalid session.
    }

    /* ################################################################## */
    // MARK: - Public Types and Structs
    /* ################################################################## */
    /**
     This is the element type for the Sequence protocol.
     */
    public typealias Element = A_RVP_Cocoa_SDK_Object

    /* ################################################################## */
    /** This is how we specify the location for searches.
     - coords: A lat/long coordinate (in degrees) of the location
     - radiusInKm: A distance within which the search will be performed.
     - autoRadiusThreshold: An optional field with a minimum number of results.
     */
    public struct LocationSpecification {
        /* ############################################################## */
        /**
         A lat/long coordinate (in degrees) of the location.
         */
        public var coords: CLLocationCoordinate2D

        /* ############################################################## */
        /**
         A distance (in Kilometers) within which the search will be performed.
         */
        public var radiusInKm: CLLocationDistance

        /* ############################################################## */
        /**
         An optional field with a minimum number of results.
         */
        public var autoRadiusThreshold: Int?
        
        /* ############################################################## */
        /**
         Default Initializer.
         
         - parameter coords: A lat/long coordinate (in degrees) of the location.
         - parameter radiusInKm: A distance (in Kilometers) within which the search will be performed.
         - parameter autoRadiusThreshold: An optional field with a minimum number of results.
         */
        public init(coords inCoords: CLLocationCoordinate2D, radiusInKm inRadiusInKm: CLLocationDistance, autoRadiusThreshold inAutoRadiusThreshold: Int?) {
            self.coords = inCoords
            self.radiusInKm = inRadiusInKm
            self.autoRadiusThreshold = inAutoRadiusThreshold
        }
    }

    /* ################################################################## */
    /**
     This is a quick resolver for the basic HTTP status.
     */
    public struct HTTPError: Error {
        /** This is the HTTP response code for this error. */
        public var code: Int
        /** This is an optional description string that can be added when instantiated. If it is given, then it will be returned in the response. */
        public var description: String?
        
        /* ############################################################## */
        /**
         - returns: A localized description for the instance HTTP code.
         */
        public var localizedDescription: String {
            if let desc = self.description {    // An explicitly-defined string has precedence.
                return String(self.code) + ", " + desc
            } else {    // Otherwise, use the system-localized version.
                return String(self.code) + ", " + HTTPURLResponse.localizedString(forStatusCode: self.code)
            }
        }
    }

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
        /** The attempted creation of a new login failed, as the ID is already taken. */
        case duplicateLoginID
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
    /**
     These are used to define the types of tokens.
     */
    public enum TokenType: Comparable {
        /** Unknown. This should be considered an error.  */
        case none
        /** This is a standard token. It may actually be a login ID, but that won't be exposed to non-God admis, most times.   */
        case token(id: Int)
        /** This is a login ID. In non-God admins, there will only be one (and it will be ours). */
        case loginID(id: Int)
        /** This is a personal token that was assigned from another login. */
        case assigned(id: Int)
        /** This is a personal ID. If this is the "God" ID, then the ID of the "owner" of the personal token will be associated (Int). */
        case personal(id: Int, loginID: Int?)

        /* ############################################################## */
        /**
         This allows us to sort the list.
         
         - parameter lhs: The left-hand comparable
         - parameter rhs: The right-hand comparable
         - returns: True, if lhs < rhs
         */
        public static func < (lhs: RVP_Cocoa_SDK.TokenType, rhs: RVP_Cocoa_SDK.TokenType) -> Bool {
            if .none != lhs, .none != rhs {
                var lh: Int = 0
                var rh: Int = 0
                
                switch lhs {
                case .none:
                    break
                case .token(let id):
                    lh = id
                case .personal(let id, _):
                    lh = id
                case .loginID(let id):
                    lh = id
                case .assigned(let id):
                    lh = id
                }
                
                switch rhs {
                case .none:
                    break
                case .token(let id):
                    rh = id
                case .personal(let id, _):
                    rh = id
                case .loginID(let id):
                    rh = id
                case .assigned(let id):
                    rh = id
                }
                
                return lh < rh
            }
            
            return false
        }
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
    public var isValid: Bool {
        return !self._plugins.isEmpty
    }
    
    /* ################################################################## */
    /**
     Returns an Array of Int, with the current tokens. If logged in, then this will be at least 1, and the current ID of the login. If not logged in, this will return an empty Array.
     */
    public var securityTokens: [Int] {
        var ret: [Int] = []
        
        if self.isLoggedIn, let myInfo = self.myLoginInfo {
            ret = myInfo.securityTokens
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     Returns an Array of Int, with the current tokens. If logged in, then this will be at least 1, and the current ID of the login. If not logged in, this will return an empty Array.
     */
    public var personalTokens: [Int] {
        var ret: [Int] = []
        
        if self.isLoggedIn, let myInfo = self.myLoginInfo {
            ret = myInfo.personalTokens
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     Returns the number of data items in our cache.
     */
    public var count: Int {
        return self._dataItems.count
    }

    /* ################################################################## */
    /**
     Returns true, if we have no items in our cache.
     */
    public var isEmpty: Bool {
        return self._dataItems.isEmpty
    }
    
    /* ################################################################## */
    /**
     Returns the Array of plugins (if the SDK is connected to a valid server).
     */
    public var plugins: [String] {
        return self._plugins
    }
    
    /* ################################################################## */
    /**
     Returns the number of personal tokens to be added to new users.
     */
    public var number_of_personal_tokens_per_login: Int {
        get {
            return self._number_of_personal_tokens_per_login
        }
        
        set {
            self._number_of_personal_tokens_per_login = newValue
        }
    }
    
    /* ################################################################## */
    /**
     Returns the step size, in kilometers, of the auto-radius search.
     */
    public var autoRadiusStepSizeInKm: Double {
        get {
            return self._autoRadiusStepSizeInKm
        }
        
        set {
            self._autoRadiusStepSizeInKm = newValue
        }
    }
    
    /* ################################################################## */
    /**
     This allows the instance to be treated like a simple Array.
     
     - parameter _: The 0-based index we are addressing.
     
     - returns the indexed item. Nil, if the index is out of range.
     */
    public subscript(_ inIndex: Int) -> Element? {
        if (0 <= inIndex) && (inIndex < self.count) {
            return self._dataItems[inIndex]
        }
        
        return nil
    }
    
    /* ################################################################## */
    /**
     This is the Sequence Iterator Struct.
     */
    // This is the iterator we'll use.
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
    /**
     This is the login info for our current login. Returns nil, if not logged in.
     */
    public var myLoginInfo: RVP_Cocoa_SDK_Login? {
        return self._loginInfo
    }
    
    /* ################################################################## */
    /**
     This is the user info for our current login. Returns nil, if not logged in, or we don't have any user info associated with the login.
     */
    public var myUserInfo: RVP_Cocoa_SDK_User? {
        return self._userInfo
    }
    
    /* ################################################################## */
    // MARK: - Public Stored Properties
    /* ################################################################## */
    /**
     This is a special "settable" property with the center of a radius search.
     If the object already has a "distance" property returned from the server,
     this is ignored. Otherwise, if it is provided, and the object has a long/lat,
     the "distance" read-only property will return a Vincenty's Formulae distance
     in Kilometers from this center.
     */
    public var searchLocation: CLLocationCoordinate2D?

    /* ################################################################## */
    // MARK: - Public Instance Methods
    /* ################################################################## */
    /**
     This is the required default initializer.
     
     - parameter serverURI: (REQUIRED) A String, with the URI to a valid BAOBAB Server
     - parameter serverSecret: (REQUIRED) A String, with the Server secret for the target server.
     - parameter delegate: (REQUIRED) A RVP_IOS_SDK_Delegate that will receive updates from the SDK instance.
     - parameter loginID: (OPTIONAL/REQUIRED) A String, with a login ID. If provided, then you must also provide inPassword and inLoginTimeout.
     - parameter password: (OPTIONAL/REQUIRED) A String, with a login password. If provided, then you must also provide inLoginId and inLoginTimeout.
     - parameter timeout: (OPTIONAL/REQUIRED) An Integer value, with the number of seconds the login has to be active. If provided, then you must also provide inLoginId and inPassword.
     - parameter session: (OPTIONAL) This allows the caller to have their own URLSession established (often, there is only one per app), so we can hitch a ride with that session. Otherwise, we create our own. The session must be ephemeral.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    public init(serverURI inServerURI: String, serverSecret inServerSecret: String, delegate inDelegate: RVP_Cocoa_SDK_Delegate, loginID inLoginID: String! = nil, password inPassword: String! = nil, timeout inLoginTimeout: Int! = nil, session inURLSession: URLSession? = nil, refCon inRefCon: Any?) {
        super.init()
        
        self._delegate = inDelegate
        
        // Store the items we hang onto.
        self._server_uri = inServerURI
        self._server_secret = inServerSecret
        
        // Set up our URL session.
        if nil != inURLSession {
            self._newSession = false
            self._connectionSession = inURLSession
        } else {
            self._newSession = true
            self._connectionSession = URLSession(configuration: .ephemeral, delegate: self, delegateQueue: nil)
        }
        self.connect(loginID: inLoginID, password: inPassword, timeout: inLoginTimeout, refCon: inRefCon)
    }
    
    /* ################################################################## */
    /**
     This is called with a list of one or more objects to be deleted from the server.
     
     This will sort through the objects, and will only delete ones we currently have cached.
     It will figure out whether or not the object is a security object or a data object, and perform the required deletion for each type.
     
     - parameter inItemArray: An Array of concrete instances of subclasses of A_RVP_IOS_SDK_Object.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    public func deleteObjects(_ inItemArray: [A_RVP_Cocoa_SDK_Object], refCon inRefCon: Any?) {
        // The first thing we do, is sort by plugin path, which we'll use for the next step.
        let sortedList = inItemArray.sorted(by: { (a, b) -> Bool in
            if a._pluginPathNoID < b._pluginPathNoID {
                return true
            } else if a._pluginPathNoID == b._pluginPathNoID {
                return a.id < b.id
            }
            
            return false
        })
        
        let keyArray = [String](Set(sortedList.map { (a) -> String in a._pluginPathNoID }))
        
        // At this point, keyArray has an Array with the unique plugin paths we'll need for the lists of IDs. Time to sort out the IDs.
        var deleteDictionary: [String: [Int]] = [:]
        for key in keyArray {
            for item in sortedList where key == item._pluginPathNoID {
                if nil == deleteDictionary[key] {
                    deleteDictionary[key] = [item.id]
                } else {
                    deleteDictionary[key]?.append(item.id)
                }
            }
        }
        
        // OK. Now we have a list of plugin paths and IDs to accompany them. We generate a list of URIs to send to the server.
        var uriList: [String] = []
        
        for delList in deleteDictionary {
            for idArray in delList.value.chunk(10) {    // Break up, if we have too many.
                let uriString = delList.key + "/" + (idArray.map { String($0) }).joined(separator: ",")
                uriList.append(uriString)
            }
        }
        
        // Now, we have a list of delete URIs to send to the server. Let's get to work...
        
        for var uri in uriList {
            let loginParams = self._loginParameters
            
            if !loginParams.isEmpty {
                uri = self._server_uri + "/json" + uri + "?" + self._loginParameters
                
                self._sendDelete(uri, refCon: inRefCon)
            }
        }
    }

    /* ################################################################## */
    /**
     - parameter id: The ID of the resource to be deleted
     - parameter andPlugin: The plugin to be affected.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    public func deleteBy(id inID: Int, andPlugin inPlugin: String, refCon inRefCon: Any?) {
        let uri = self._server_uri + "/json/" + inPlugin.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) + "/" + String(inID)
        self._sendDelete(uri, refCon: inRefCon)
    }
    
    /* ################################################################## */
    /**
     This will connect to the server. If login credentials are provided, then it will also log in.
     
     - parameter loginId: (OPTIONAL) A String, with a login ID. If provided, then you must also provide inPassword and inLoginTimeout.
     - parameter password: (OPTIONAL) A String, with a login password. If provided, then you must also provide inLoginId and inLoginTimeout.
     - parameter timeout: (OPTIONAL) A Floating-point value, with the number of seconds the login has to be active. If provided, then you must also provide inLoginId and inPassword.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    public func connect(loginID inLoginId: String! = nil, password inPassword: String! = nil, timeout inLoginTimeout: Int! = nil, refCon inRefCon: Any?) {
        // If any one of the optionals is provided, then they must ALL be provided.
        if (nil != inLoginId || nil != inPassword || nil != inLoginTimeout),
           (nil == inLoginId || nil == inPassword || nil == inLoginTimeout) {
            // If a login was provided, we attempt a login.
            self.login(loginID: inLoginId, password: inPassword, timeout: inLoginTimeout, refCon: inRefCon)
        } else if self._plugins.isEmpty {
            self._validateServer(refCon: inRefCon)
        } else {
            self._reportSessionValidity(refCon: inRefCon)   // We report whether or not this session is valid.
            self._callDelegateLoginValid(self.isLoggedIn, refCon: inRefCon)   // OK. We're done. Tell the delegate whether or not we are logged in.
        }
    }

    /* ################################################################## */
    /**
     This is the standard login method.
     
     When we log in, we go through the process of getting the API key (sending the login info), then getting our login information, our user information (if available), and the baseline plugins.
     
     After all that, the delegate will be called with the login valid/invalid response.
     
     - parameter loginID: (REQUIRED) A String, with a login ID.
     - parameter password: (REQUIRED) A String, with a login password.
     - parameter timeout: (REQUIRED) An Integervalue, with the number of seconds the login has to be active.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    public func login(loginID inLoginID: String, password inPassword: String, timeout inLoginTimeout: Int, refCon inRefCon: Any?) {
        self._loginTimeout = TimeInterval(inLoginTimeout) // This is how long we'll have to be logged in, before the server kicks us out.
        self._loginTime = Date()    // Starting now.
        self._apiKey = nil          // We wipe out any stored API key.
        // The login is a simple GET task, so we can just use a straight-up task for this.
        if let login_id_object = inLoginID.urlEncodedString {
            if let password_object = inPassword.urlEncodedString {
                let url = self._server_uri + "/login?login_id=" + login_id_object + "&password=" + password_object
                if let url_object = URL(string: url) {
                    Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                        self._openOperations += 1
                    }
                    var request = URLRequest(url: url_object)
                    request.httpMethod = "GET"
                    request.setValue("no-store, max-age=0", forHTTPHeaderField: "Cache-Control")
                    let loginTask = self._connectionSession.dataTask(with: request) { [weak self] data, response, error in
                        if let error = error {
                            self?._handleError(error, refCon: inRefCon)
                            return
                        }
                        guard let httpResponse = response as? HTTPURLResponse,
                            (200...299).contains(httpResponse.statusCode) else {
                                self?._handleHTTPError(response as? HTTPURLResponse ?? nil, refCon: inRefCon)
                                return
                        }
                        if let mimeType = httpResponse.mimeType, mimeType == "text/html",
                           let data = data,
                           let apiKey = String(data: data, encoding: .utf8) {
                            self?._apiKey = apiKey
                            self?._fetchMyLoginInfo(refCon: inRefCon)
                        } else {
                            self?._handleError(SDK_Data_Errors.invalidData(data), refCon: inRefCon)
                        }
                        
                        Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                            self?._openOperations -= 1
                        }
                    }
                    
                    self.flushCache()    // We nuke the cache when we log in.
                    loginTask.resume()
                } else {
                    self._handleError(SDK_Connection_Errors.invalidServerURI(url), refCon: inRefCon)
                }
            } else {
                self._handleError(SDK_Operation_Errors.invalidParameters, refCon: inRefCon)
            }
        } else {
            self._handleError(SDK_Operation_Errors.invalidParameters, refCon: inRefCon)
        }
    }

    /* ################################################################## */
    /**
     This is the logout method.
     
     You must already be logged in for this to do anything. If so, it simply asks the server to log us out.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    public func logout(refCon inRefCon: Any?) {
        if self.isLoggedIn {
            // The logout is a simple GET task, so we can just use a straight-up task for this.
            let url = self._server_uri + "/logout?" + self._loginParameters
            if let url_object = URL(string: url) {
                Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                    self._openOperations += 1
                }
                let logoutTask = self._connectionSession.dataTask(with: url_object) { [weak self] _, response, error in
                    if let error = error {
                        self?._handleError(error, refCon: inRefCon)
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          205 == httpResponse.statusCode
                        else {
                        // The reason for this, is that it is possible to sometimes get a "not authorized" error response.
                        // Since we are logging out, this is actually OK.
                        if let httpResponse = response as? HTTPURLResponse,
                           403 != httpResponse.statusCode {
                            self?._handleHTTPError(response as? HTTPURLResponse ?? nil, refCon: inRefCon)
                        }
                        return
                    }
                    
                    self?._apiKey = nil
                    self?._loginTime = nil
                    self?._loginInfo = nil
                    self?._userInfo = nil
                    self?._callDelegateLoginValid(false, refCon: inRefCon) // At this time, we are logged out, but the session is still valid.
                    Self._staticQueue.sync {    // This just makes sure the assignment happens in a thread-safe manner.
                        self?._openOperations -= 1
                    }
                }
                
                self.flushCache()    // We nuke the cache when we log out.
                logoutTask.resume()
            } else {
                self._handleError(SDK_Connection_Errors.invalidServerURI(url), refCon: inRefCon)
            }
        }
    }

    /* ################################################################## */
    /**
     This simply empties our cache, forcing the next load to go out to the server.
     */
    public func flushCache() {
        self._dataItems = []
    }

    /* ################################################################## */
    /**
     Asks the server to create a user/login pair, with a blank password.
     This can only be called if you are logged in as a manager.
     
     - parameter loginString: The Requested login ID string. It must be unique in the server, and the operation will fail, if it is already taken.
     - parameter name: A requested name for the objects (will be applied to both). It is optional. If not supplied, the Login ID will be used for the name.
     - parameter isManager: If true, then the new instance will be a maneger (default is false, and can be omitted).
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    public func createUserLoginPair(loginString inLoginStringID: String, name inName: String = "", isManager inIsManager: Bool = false, refCon inRefCon: Any?) {
        self._creatingUserLoginPair = true
        self._newUserInstance = nil
        var useName = inName
        if useName.isEmpty {
            useName = inLoginStringID
        }
        var initialData = ["name": useName, "login_id": inLoginStringID]
        if inIsManager {
            initialData["is_manager"] = "1"
        }
        self._newUserInstance = RVP_Cocoa_SDK_User(sdkInstance: self, objectInfoData: initialData)
        self._newUserInstance.sendToServer(refCon: inRefCon)
    }

    /* ################################################################## */
    /**
     Asks the server to create a security token (no login).
     This can only be called if you are logged in as a manager.
     
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    public func createSecurityToken(refCon inRefCon: Any?) {
        self._createSecurityToken(refCon: inRefCon)
    }

    /* ################################################################## */
    /**
     This is a general method for fetching items from the data database, by their numerical IDs.
     
     - parameter inIntegerIDs: An Array of Int, with the data database IDs of the data database objects Requested.
     - parameter andPlugin: An optional String, with the required plugin ("people", "places" or "things"). If nil, then the baseline plugin is invoked, which will fetch any object, regardless of plugin.
     - parameter withLogins: If true (default is false), then this call will ask for the logins associated with users, and only users that have logins. This is ignored, if the user is not a manager.
     - parameter dontNukeTheLocation: Optional. If true, then we keep the search location cached (like in an auto-radius call). Otherwise (default), the search location is reset after this call.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
    */
    public func fetchDataItemsByIDs(_ inIntegerIDs: [Int], andPlugin inPlugin: String? = "baseline", withLogins inWithLogins: Bool = false, dontNukeTheLocation inDontNuke: Bool = false, refCon inRefCon: Any?) {
        if !inDontNuke {
            self.searchLocation = nil   // We have the option of not nuking if we are fetching as part of a location/radius search.
        }
        if let plugin = inPlugin, "baseline" != plugin {    // nil is "baseline".
            self._fetchDataItems(inIntegerIDs, plugin: plugin, withLogins: inWithLogins, refCon: inRefCon)
        } else {
            self._fetchBaselineObjectsByID(inIntegerIDs, refCon: inRefCon)    // If we fetch baseline objects, it's a 2-step process.
        }
    }

    /* ################################################################## */
    /**
     This method fetches every user (with a login) that can be edited by the current manager instance.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    public func fetchAllEditableUsersFromServer(refCon inRefCon: Any?) {
        if self.isManager {
            self._fetchAllEditableUsersFromServer(refCon: inRefCon)
        }
    }

    /* ################################################################## */
    /**
     This method will initiate a fetch of all types of objects, based upon a list of IDs.
     
     - parameter inIDArray: An Array of Int, with the data database IDs of the place objects Requested.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    public func fetchBaselineObjectsByID(_ inIDArray: [Int], refCon inRefCon: Any?) {
        self.fetchDataItemsByIDs(inIDArray, refCon: inRefCon)
    }

    /* ################################################################## */
    /**
     This method will initiate a fetch of place objects, based upon a list of IDs.
     
     - parameter inPlaceIDArray: An Array of Int, with the data database IDs of the place objects Requested.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    public func fetchPlaces(_ inPlaceIDArray: [Int], refCon inRefCon: Any?) {
        self.fetchDataItemsByIDs(inPlaceIDArray, andPlugin: "places", refCon: inRefCon)
    }

    /* ################################################################## */
    /**
     This method will initiate a fetch of user objects, based upon a list of IDs.
     
     - parameter inUserIntegerIDArray: An Array of Int, with the data database IDs of the user objects Requested.
     - parameter withLogins: If true (default is false), then this call will ask for the logins associated with users, and only users that have logins. This is ignored, if the user is not a manager.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    public func fetchUsers(_ inUserIntegerIDArray: [Int], withLogins inWithLogins: Bool = false, refCon inRefCon: Any?) {
        self.fetchDataItemsByIDs(inUserIntegerIDArray, andPlugin: "people/people", refCon: inRefCon)
    }

    /* ################################################################## */
    /**
     This method will initiate a fetch of user objects, based upon a list of IDs.
     
     - parameter inUserIntegerIDArray: An Array of Int, with the data database IDs of the user objects Requested.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    public func fetchVisibleUserIDAndNames(refCon inRefCon: Any?) {
        self._fetchVisibleUserIDAndNames(refCon: inRefCon)
    }

    /* ################################################################## */
    /**
     This fetches thing objects from the data database server.
     
     - parameter inThingIntegerIDArray: An Array of Int, with the data database IDs of the thing objects Requested.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    public func fetchThings(_ inThingIntegerIDArray: [Int], refCon inRefCon: Any?) {
        self.fetchDataItemsByIDs(inThingIntegerIDArray, andPlugin: "things", refCon: inRefCon)
    }
    
    /* ################################################################## */
    /**
     This fetches thing objects from the data database server.
     
     - parameter inKeys: An Array of String, with the thing keys.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    public func fetchThings(_ inKeys: [String], refCon inRefCon: Any?) {
        self.searchLocation = nil
        self._fetchThings(inKeys, refCon: inRefCon)
    }
    
    /* ################################################################## */
    /**
     This method will initiate a fetch of login objects, based upon a list of IDs.
     
     - parameter inLoginIntegerIDArray: An Array of Int, with the security database IDs of the login objects Requested.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    public func fetchLogins(_ inLoginIntegerIDArray: [Int], refCon inRefCon: Any?) {
        self.searchLocation = nil   // This will always nil out if we are fetching logins.
        self._fetchLoginItems(inLoginIntegerIDArray, refCon: inRefCon)
    }

    /* ################################################################## */
    /**
     This method will initiate a fetch of login objects, based upon a list of IDs.
     
     - parameter inLoginStringIDArray: An Array of String, with the string login IDs of the login objects Requested.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    public func fetchLogins(_ inLoginStringIDArray: [String], refCon inRefCon: Any?) {
        self.searchLocation = nil   // This will always nil out if we are fetching logins.
        self._fetchLoginItems(inLoginStringIDArray, refCon: inRefCon)
    }

    /* ################################################################## */
    /**
     This method will initiate a fetch of all visible ID objects, listed with types and "owners" (if logged in as "God").
     
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    public func fetchAllTokens(refCon inRefCon: Any?) {
        self._fetchAllTokensFromServer(refCon: inRefCon)
    }
    
    /* ################################################################## */
    /**
     We ask the server to send us our login object information.
     
     When we get the information, we parse it, create a new instance of the handler class and cache that instance.
     
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    public func fetchMyLoginInfo(refCon inRefCon: Any?) {
        self._fetchMyLoginInfo(refCon: inRefCon)
    }
    
    /* ################################################################## */
    /**
     This will ask the server to inform us as to who has access to the given security token.
     
     - parameter inTokens: An integer array, with the tokens we're testing.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    public func countWhoHasAccessToTheseSecurityTokens(_ inTokens: [Int], refCon inRefCon: Any?) {
        self._countWhoHasAccessToTheseSecurityTokens(inTokens, refCon: inRefCon)
    }
    
    /* ################################################################## */
    /**
     This will ask the server to get all the logins that have access to provided security token.
     
     This is security-vetted, so only logins that the current login can see, will be returned.
     
     - parameter inToken: An Integer, with the token we are testing.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    public func fetchIDsOfLoginsThatHaveThisToken(_ inToken: Int, refCon inRefCon: Any?) {
        _fetchIDsOfLoginsThatHaveThisToken(inToken, refCon: inRefCon)
    }
    
    /* ################################################################## */
    /**
     This will ask the server to get all the users that have access to provided security token.
     
     This is security-vetted, so only users that the current login can see, will be returned.
     
     - parameter inToken: An Integer, with the token we are testing.
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    public func fetchIDsOfUsersThatHaveThisToken(_ inToken: Int, refCon inRefCon: Any?) {
        _fetchIDsOfUsersThatHaveThisToken(inToken, refCon: inRefCon)
    }

    /* ################################################################## */
    /**
     This method starts a "generic" search, based upon the input given.
     
     - parameter inTagValues:   This is an optional String-key Dictionary, with the key being any one of these values (on the same line means it must be one of the values). The order is tag, places, people, things:
                                The value must be a String, but, in some cases, it may be a string representation of an integer.
                                The values can use SQL-style wildcards (%) and are case-insensitive.
                                If the object has one of its tags with a matching string (and the user has permission), it may be added to the returned set.
                                Despite the plugin-specific keys, the search will search the tag position of all records, so specifying a givenName of "Billings" will also return any Place object that has a "town" of "Billings".
                                If this is not specified, or is empty, then all results will be returned.
                                In order to be considered in a location-based search (andLocation is set to a location), then the objects need to have a lat/long value assigned.
                                if a value in inTagValues is an empty String (""), then the search will search explicitly for objects that do not have a value in that tag.
                                if a value in inTagValues has only a wildcard ("%"), then that means that only objects that have non-empty values of that tag will be returned; regardless of the content of the tag.

                                Possible inTagValues keys are:
                                - "tag0", "venue" (you cannot directly search for the login ID of a user with this method, but you can look for a baseline tag0 value, which is the user login as an Int. Same for thing keys, which are String.)
                                - "tag1", "streetAddress", "surname", "description"
                                - "tag2", "extraInformation", "middleName"
                                - "tag3", "town", "givenName"
                                - "tag4", "county", "nickname"
                                - "tag5", "state", "prefix"
                                - "tag6", "postalCode", "suffix"
                                - "tag7", "nation"
                                - "tag8"
                                - "tag9"

     - parameter andLocation:   This is a tuple with the following structure:
                                    - **coords** This is a required CLLocationCoordinate2D struct, with a latitude and longitude.
                                    - **radiusInKm** This is a CLLocationDistance (Double) number, with a requested radius (in kilometers). If autoRadiusThreshold is set, and greater than zero, then this is a "maximum" radius. If the auto radius threshold is not specified, this is the full radius.
                                    - **autoRadiusThreshold** This is an optional Int, with a "threshold" number of results to be returned in an "auto-radius hunt."
                                        This means that the SDK will search from the "coords" location, out, in progressively widening circles, until it either gets *at least* the number in this value, or reaches the maximum radius in "radiusInKm."
                                        If this is specified, the "radiusInKm" specifies the maximum radius to search. At the end of that search, any resources found will be returned, even if they are fewer than requested.
     
     - parameter withPlugin:    This is an optional String. It can specify that only a certain plugin will be searched. For the default plugins, this can only be "baseline", "people", "places", and "things".
                                If not specified, then the "baseline" plugin will be searched (returns all types).
     - parameter refCon: This is an optional Any parameter that is simply returned after the call is complete. "refCon" is a very old concept, that stands for "Reference Context." It allows the caller of an async operation to attach context to a call.
     */
    public func fetchObjectsUsingCriteria(_ inTagValues: [String: String]? = nil, andLocation inLocation: LocationSpecification! = nil, withPlugin inPlugin: String = "baseline", refCon inRefCon: Any?) {
        self.searchLocation = inLocation?.coords
        self._fetchObjectsByString(Self._sortOutStrings(inTagValues, forPlugin: inPlugin), andLocation: inLocation, withPlugin: inPlugin, maxRadiusInKm: inLocation?.radiusInKm ?? 0, refCon: inRefCon)
    }
    
    /* ################################################################## */
    // MARK: - Public Sequence Protocol Methods
    /* ################################################################## */
    /**
     - returns: a new iterator for the instance.
     */
    public func makeIterator() -> RVP_Cocoa_SDK.Iterator {
        return Iterator(self._dataItems)
    }
}
