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

import UIKit
import MapKit
import AVKit
import PDFKit
import WhiteDragon

/* ###################################################################################################################################### */
// MARK: - AV Player View Class -
/* ###################################################################################################################################### */
/**
 */
class RVP_VideoPlayerView: UIView {
    /* ################################################################## */
    /**
     */
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    /* ################################################################## */
    /**
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.black
    }
    
    /* ################################################################## */
    /**
     */
    var playerLayer: AVPlayerLayer! {
        if let ret = self.layer as? AVPlayerLayer {
            return ret
        }
        
        return nil
    }
    
    /* ################################################################## */
    /**
     */
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        
        set {
            playerLayer.player = newValue
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - Generic Payload Button Class -
/* ###################################################################################################################################### */
/**
 */
@IBDesignable
class RVP_PayloadButton: UIButton {
    var payload: Data?
    
    /* ################################################################## */
    /**
     */
    init(_ inPayload: Data) {
        self.payload = inPayload
        super.init(frame: CGRect.zero)
    }
    
    /* ################################################################## */
    /**
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /* ################################################################## */
    /**
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        self.subviews.forEach({ $0.removeFromSuperview() })
        let innerLabel = UILabel()
        innerLabel.text = "VIEW PAYLOAD"
        self.addSubview(innerLabel)
        innerLabel.translatesAutoresizingMaskIntoConstraints = false
        innerLabel.textAlignment = .center
        
        self.addConstraints([
            NSLayoutConstraint(item: innerLabel,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: 0),
            NSLayoutConstraint(item: innerLabel,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: 0),
            NSLayoutConstraint(item: innerLabel,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .centerX,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: innerLabel,
                               attribute: .width,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .width,
                               multiplier: 1.0,
                               constant: 0.0)])
    }
}

/* ###################################################################################################################################### */
// MARK: - Generic Children Button Class -
/* ###################################################################################################################################### */
/**
 */
@IBDesignable
class RVP_ChildrenButton: UIButton {
    var children: [Int] = []
    var sdkInstance: RVP_Cocoa_SDK!

    /* ################################################################## */
    /**
     */
    init(_ inChildren: [Int], sdkInstance inSDKInstance: RVP_Cocoa_SDK) {
        self.children = inChildren
        self.sdkInstance = inSDKInstance
        super.init(frame: CGRect.zero)
    }
    
    /* ################################################################## */
    /**
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /* ################################################################## */
    /**
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        self.subviews.forEach({ $0.removeFromSuperview() })
        let innerLabel = UILabel()
        innerLabel.text = "VIEW CHILDREN (" + String(self.children.count) + ")"
        self.addSubview(innerLabel)
        innerLabel.translatesAutoresizingMaskIntoConstraints = false
        innerLabel.textAlignment = .center
        
        self.addConstraints([
            NSLayoutConstraint(item: innerLabel,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: 0),
            NSLayoutConstraint(item: innerLabel,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: 0),
            NSLayoutConstraint(item: innerLabel,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .centerX,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: innerLabel,
                               attribute: .width,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .width,
                               multiplier: 1.0,
                               constant: 0.0)])
    }
}

/* ###################################################################################################################################### */
// MARK: - Login Button Class -
/* ###################################################################################################################################### */
/**
 */
@IBDesignable
class RVP_LoginButton: UIButton {
    @IBInspectable var loginID: Int = 0
    var sdkInstance: RVP_Cocoa_SDK!
    
    /* ################################################################## */
    /**
     */
    init(_ inLoginID: Int) {
        self.loginID = inLoginID
        super.init(frame: CGRect.zero)
    }
    
    /* ################################################################## */
    /**
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /* ################################################################## */
    /**
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        self.subviews.forEach({ $0.removeFromSuperview() })
        let innerLabel = UILabel()
        innerLabel.text = "Login ID: \(self.loginID)"
        self.addSubview(innerLabel)
        innerLabel.translatesAutoresizingMaskIntoConstraints = false
        innerLabel.textAlignment = .center
        
        self.addConstraints([
            NSLayoutConstraint(item: innerLabel,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: 0),
            NSLayoutConstraint(item: innerLabel,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: 0),
            NSLayoutConstraint(item: innerLabel,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .centerX,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: innerLabel,
                               attribute: .width,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .width,
                               multiplier: 1.0,
                               constant: 0.0)])
    }
}

/* ###################################################################################################################################### */
// MARK: - User Button Class -
/* ###################################################################################################################################### */
/**
 */
@IBDesignable
class RVP_UserButton: UIButton {
    @IBInspectable var userID: Int = 0
    var sdkInstance: RVP_Cocoa_SDK!
    
    /* ################################################################## */
    /**
     */
    init(_ inUserID: Int) {
        self.userID = inUserID
        super.init(frame: CGRect.zero)
    }
    
    /* ################################################################## */
    /**
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /* ################################################################## */
    /**
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        self.subviews.forEach({ $0.removeFromSuperview() })
        let innerLabel = UILabel()
        innerLabel.text = "User ID: \(self.userID)"
        self.addSubview(innerLabel)
        innerLabel.translatesAutoresizingMaskIntoConstraints = false
        innerLabel.textAlignment = .center
        
        self.addConstraints([
            NSLayoutConstraint(item: innerLabel,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: 0),
            NSLayoutConstraint(item: innerLabel,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: 0),
            NSLayoutConstraint(item: innerLabel,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .centerX,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: innerLabel,
                               attribute: .width,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .width,
                               multiplier: 1.0,
                               constant: 0.0)])
    }
}

/* ###################################################################################################################################### */
// MARK: - Location Button Class -
/* ###################################################################################################################################### */
/**
 */
@IBDesignable
class RVP_LocationButton: UIButton {
    var location: CLLocationCoordinate2D
    var title: String = ""
    var locationName: String = ""

    /* ################################################################## */
    /**
     */
    init(_ inLocation: CLLocationCoordinate2D, title inTitle: String, locationName inLocationName: String) {
        self.location = inLocation
        self.locationName = inLocationName
        self.title = inTitle
        super.init(frame: CGRect.zero)
    }
    
    /* ################################################################## */
    /**
     */
    required init?(coder aDecoder: NSCoder) {
        self.location = CLLocationCoordinate2D()
        super.init(coder: aDecoder)
    }
    
    /* ################################################################## */
    /**
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        self.subviews.forEach({ $0.removeFromSuperview() })
        let innerLabel = UILabel()
        innerLabel.text = self.title + ": (" + String(self.location.latitude) + "," + String(self.location.longitude) + ")"
        self.addSubview(innerLabel)
        innerLabel.translatesAutoresizingMaskIntoConstraints = false
        innerLabel.textAlignment = .center
        
        self.addConstraints([
            NSLayoutConstraint(item: innerLabel,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: 0),
            NSLayoutConstraint(item: innerLabel,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: 0),
            NSLayoutConstraint(item: innerLabel,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .centerX,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: innerLabel,
                               attribute: .width,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .width,
                               multiplier: 1.0,
                               constant: 0.0)])
    }
}

/* ###################################################################################################################################### */
// MARK: - Main Class -
/* ###################################################################################################################################### */
/**
 */
@IBDesignable
class RVP_DisplayElementView: UIView, AVAudioPlayerDelegate {
    private var _observer = false
    
    var myController: RVP_DisplayResultsScreenViewController!
    
    /* ################################################################## */
    /**
     */
    var displayedElement: A_RVP_Cocoa_SDK_Object? {
        didSet {
            self.establishSubviews()
        }
    }
    
    /* ################################################################## */
    /**
     */
    func establishSubviews() {
        // We start by "clearing the decks." We remove all of our subviews.
        self.subviews.forEach({ $0.removeFromSuperview() })
        if let displayedElement = self.displayedElement {
            self.addTopLabel(name: displayedElement.name, id: displayedElement.id)
            self.addItemLabel(label: "Modified", value: displayedElement.isDirty ? "true" : "false")
            self.addItemLabel(label: "Writeable", value: displayedElement.isWriteable ? "true" : "false")
            self.addItemLabel(label: "Read Token", value: String(displayedElement.readToken))
            self.addItemLabel(label: "Write Token", value: String(displayedElement.writeToken))
            
            if let lastAccess = displayedElement.lastAccess {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .short
                dateFormatter.locale = Locale(identifier: "en_US")
                self.addItemLabel(label: "Last Access", value: dateFormatter.string(from: lastAccess))
            }
            
            let dictionary = displayedElement.asDictionary
            self.displayitemDictionary(dictionary)
            
            if let userItem = displayedElement as? RVP_Cocoa_SDK_User {
                if 0 < userItem.loginID {
                    self.addLoginButton(userItem.loginID, sdkInstance: displayedElement.sdkInstance!)
                }
            }
            
            if let loginItem = displayedElement as? RVP_Cocoa_SDK_Login {
                self.addItemLabel(label: "Login ID", value: loginItem.loginID)
                if let userID = loginItem.userObjectID {
                    self.addUserButton(userID, sdkInstance: displayedElement.sdkInstance!)
                }
            }
            
            if let item = displayedElement as? A_RVP_Cocoa_SDK_Data_Object, let location = item.location {
                self.addLocationButton(location, title: "location", locationName: item.name)
            }
            
            if let item = displayedElement as? A_RVP_Cocoa_SDK_Data_Object, let location = item.rawLocation {
                self.addLocationButton(location, title: "rawlocation", locationName: item.name)
            }

            if let children = dictionary["childrenIDs"] as? [String: [Int]] {
                self.addChildrenButton(children, sdkInstance: displayedElement.sdkInstance!)
            }

            if let payload = dictionary["payload"] as? RVP_Cocoa_SDK_Payload {
                self.addPayloadHandler(payload)
            }
        }
        
        if let lastView = self.subviews.last {
            self.addConstraints([
                NSLayoutConstraint(item: lastView,
                                   attribute: .bottom,
                                   relatedBy: .equal,
                                   toItem: self,
                                   attribute: .bottom,
                                   multiplier: 1.0,
                                   constant: -10)])
        }
        
        self.setNeedsLayout()
    }
    
    /* ################################################################## */
    /**
     */
    func displayitemDictionary(_ inDictionary: [String: Any?]) {
        for tup in inDictionary {
            if let value = tup.value {
                let key = tup.key
                
                if !(["id", "name", "isDirty", "isWriteable", "readToken", "writeToken", "lastAccess", "childrenIDs", "loginID", "userObjectID", "location", "rawLocation", "payload"]).contains(key) {
                    if let strVal = value as? String {
                        self.addItemLabel(label: key, value: strVal)
                    } else if let boolVal = value as? Bool {
                        self.addItemLabel(label: key, value: boolVal ? "true" : "false")
                    } else if let intVal = value as? Int {
                        self.addItemLabel(label: key, value: String(intVal))
                    } else if let floatVal = value as? Float {
                        self.addItemLabel(label: key, value: String(floatVal))
                    } else if let doubleVal = value as? Double {
                        self.addItemLabel(label: key, value: String(doubleVal))
                    } else if let locVal = value as? CLLocationCoordinate2D {
                        self.addItemLabel(label: key, value: "(" + String(locVal.latitude) + "," + String(locVal.longitude) + ")")
                    } else if let intArrayVal = value as? [Int] {
                        self.addItemLabel(label: key, value: intArrayVal.map(String.init).joined(separator: ","))
                    } else if let floatArrayVal = value as? [Float] {
                        self.addItemLabel(label: key, value: floatArrayVal.map { String($0) }.joined(separator: ","))
                    } else if let doubleArrayVal = value as? [Double] {
                        self.addItemLabel(label: key, value: doubleArrayVal.map { String($0) }.joined(separator: ","))
                    } else if let stringArrayVal = value as? [String] {
                        self.addItemLabel(label: key, value: "'" + stringArrayVal.joined(separator: "','") + "'")
                    } else {
                        print("Unhandled for \(key): \(String(describing: value))")
                    }
                }
            }
        }
    }
    
    /* ################################################################## */
    /**
     */
    func addTopLabel(name inName: String, id inID: Int) {
        var nameString = String(inID)
        if !inName.isEmpty {
            nameString = inName + " (" + nameString + ")"
        }
        
        let topLabel = UILabel()
        
        topLabel.text = nameString
        topLabel.font = UIFont.boldSystemFont(ofSize: 12)
        topLabel.textAlignment = .center
        
        self.applyConstraints(thisElement: topLabel, height: topLabel.oneLineHeight)
    }
    
    /* ################################################################## */
    /**
     */
    func addLocationButton(_ inLocation: CLLocationCoordinate2D, title inTitle: String, locationName inLocationName: String) {
        let calloutButton = RVP_LocationButton(inLocation, title: inTitle, locationName: inLocationName)
        
        calloutButton.addTarget(self.myController, action: #selector(RVP_DisplayResultsScreenViewController.getMapForLocation(_:)), for: .touchUpInside)
        
        self.applyConstraints(thisElement: calloutButton, height: 30)
    }
    
    /* ################################################################## */
    /**
     */
    func addLoginButton(_ inID: Int, sdkInstance inSDKInstance: RVP_Cocoa_SDK?) {
        let calloutButton = RVP_LoginButton(inID)
        calloutButton.sdkInstance = inSDKInstance
        calloutButton.loginID = inID
        
        calloutButton.addTarget(self.myController, action: #selector(RVP_DisplayResultsScreenViewController.fetchLoginForUser(_:)), for: .touchUpInside)
        
        self.applyConstraints(thisElement: calloutButton, height: 30)
    }

    /* ################################################################## */
    /**
     */
    func addUserButton(_ inID: Int, sdkInstance inSDKInstance: RVP_Cocoa_SDK?) {
        let calloutButton = RVP_UserButton(inID)
        calloutButton.sdkInstance = inSDKInstance
        calloutButton.userID = inID

        calloutButton.addTarget(self.myController, action: #selector(RVP_DisplayResultsScreenViewController.fetchUserForLogin(_:)), for: .touchUpInside)
        
        self.applyConstraints(thisElement: calloutButton, height: 30)
    }

    /* ################################################################## */
    /**
     */
    func addChildrenButton(_ inChildrenDictionary: [String: [Int]], sdkInstance inSDKInstance: RVP_Cocoa_SDK?) {
        var idList: [Int] = []
        
        if let people = inChildrenDictionary["people"], !people.isEmpty {
            for item in people {
                idList.append(item)
            }
        }
        
        if let places = inChildrenDictionary["places"], !places.isEmpty {
            for item in places {
                idList.append(item)
            }
        }
        
        if let things = inChildrenDictionary["things"], !things.isEmpty {
            for item in things {
                idList.append(item)
            }
        }
        
        if !idList.isEmpty {
            if let sdkInstance = inSDKInstance {
                let newButton = RVP_ChildrenButton(idList, sdkInstance: sdkInstance)
                newButton.addTarget(self.myController, action: #selector(RVP_DisplayResultsScreenViewController.displayChildrenButtonHit(_:)), for: .touchUpInside)
                self.applyConstraints(thisElement: newButton, height: 30)
            }
        }
    }

    /* ################################################################## */
    /**
     */
    func addItemLabel(label inLabel: String = "", value inValue: String) {
        let theLabel = UILabel()
        
        theLabel.text = (inLabel.isEmpty ? "" : inLabel + ": ") + inValue
        theLabel.font = UIFont.systemFont(ofSize: 12)
        theLabel.textAlignment = .center
        
        self.applyConstraints(thisElement: theLabel, height: theLabel.oneLineHeight)
    }

    /* ################################################################## */
    /**
     */
    func applyConstraints(thisElement inThisElement: UIView, height inHeight: CGFloat) {
        var previousView: UIView!
        
        if !self.subviews.isEmpty {
            previousView = self.subviews.last
        }
        
        self.addSubview(inThisElement)
        inThisElement.translatesAutoresizingMaskIntoConstraints = false
        inThisElement.setContentCompressionResistancePriority(.required, for: .vertical)

        if nil != previousView {
            self.addConstraints([
                NSLayoutConstraint(item: inThisElement,
                                   attribute: .top,
                                   relatedBy: .equal,
                                   toItem: previousView,
                                   attribute: .bottom,
                                   multiplier: 1.0,
                                   constant: 4)])
        } else {
            self.addConstraints([
                NSLayoutConstraint(item: inThisElement,
                                   attribute: .top,
                                   relatedBy: .equal,
                                   toItem: self,
                                   attribute: .top,
                                   multiplier: 1.0,
                                   constant: 0)])
        }

        self.addConstraints([
            NSLayoutConstraint(item: inThisElement,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .centerX,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: inThisElement,
                               attribute: .width,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .width,
                               multiplier: 1.0,
                               constant: 0.0)])
        
        if 0 < inHeight {
            self.addConstraints([
                NSLayoutConstraint(item: inThisElement,
                                   attribute: .height,
                                   relatedBy: .equal,
                                   toItem: nil,
                                   attribute: .notAnAttribute,
                                   multiplier: 1.0,
                                   constant: inHeight)])
        }
    }
    
    /* ################################################################## */
    /**
     */
    func addPayloadHandler(_ inPayload: RVP_Cocoa_SDK_Payload) {
        let payloadView = RVP_DisplayPayloadView(inPayload, controller: self.myController)
        self.applyConstraints(thisElement: payloadView, height: 500)
    }
}
