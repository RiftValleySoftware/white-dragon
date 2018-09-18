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
// MARK: - Main Class -
/* ###################################################################################################################################### */
/**
 */
public class A_RVP_IOS_SDK_Object: NSObject {
    /* ################################################################## */
    // MARK: - Internal Variables -
    /* ################################################################## */
    /** This is the SDK object that "owns" this instance. It may be nil for change history entries. */
    internal var _sdkInstance: RVP_IOS_SDK?
    
    /** This records changes made during the current instantiation (not before) of this object. It has a tuple with a "before" instance, and an "after" instance. */
    internal var _changeHistory: [(before: A_RVP_IOS_SDK_Object?, after: A_RVP_IOS_SDK_Object?)] = []
    
    /** This contains the actual JSON data that was read from the server for this record. */
    internal var _myData: [String: Any] = [:]
    
    /* ################################################################## */
    // MARK: - Public Methods and Calulated properties -
    /* ################################################################## */
    /**
     - returns all of the values for this object, as a Dictionary.
     */
    public var asDictionary: [String: Any?] {
        var ret: [String: Any?] = ["id": self.id, "name": self.name]

        if let readToken = self.readToken {
            ret ["readToken"] = readToken
        }
        
        if let writeToken = self.writeToken {
            ret ["writeToken"] = writeToken
        }
        
        if let lastAccess = self.lastAccess {
            ret ["lastAccess"] = lastAccess
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     - returns the object ID, as an Int
     */
    public var id: Int {
        var ret = 0
        
        if let id = self._myData["id"] as? Int {
            ret = id
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     - returns the object name, as a String
     */
    public var name: String {
        var ret = ""
        
        if let name = self._myData["name"] as? String {
            ret = name
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     - returns the read token, as an Int. Be aware that the read token may not be available, in which case, it will be nil.
     */
    public var readToken: Int? {
        var ret: Int?
        
        if let id = self._myData["read_token"] as? Int {
            ret = id
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     - returns the write token, as an Int. Be aware that the write token may not be available, in which case, it will be nil.
     */
    public var writeToken: Int? {
        var ret: Int?
        
        if let id = self._myData["write_token"] as? Int {
            ret = id
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     - returns the last time the object was accessed. Nil, if no date available.
     */
    public var lastAccess: Date? {
        if let dateString = self._myData["last_access"] as? String {
            let dateFormatter = ISO8601DateFormatter()
            let options: ISO8601DateFormatter.Options = [.withYear, .withMonth, .withDay, .withDashSeparatorInDate, .withSpaceBetweenDateAndTime, .withTime, .withColonSeparatorInTime]
            dateFormatter.formatOptions = options
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
        }
        
        return nil
    }

    /* ################################################################## */
    /**
     */
    public init(sdkInstance inSDKInstance: RVP_IOS_SDK? = nil, objectInfoData inData: [String: Any]) {
        self._sdkInstance = inSDKInstance
        self._myData = inData
    }
}
