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

import UIKit
import MapKit

@IBDesignable
class RVP_DisplayElementView: UIView {
    var displayedElement: A_RVP_IOS_SDK_Object? {
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
            if let token = displayedElement.readToken {
                self.addItemLabel(label: "Read Token", value: String(token))
            }
            if let token = displayedElement.writeToken {
                self.addItemLabel(label: "Write Token", value: String(token))
            }
            if let lastAccess = displayedElement.lastAccess {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .short
                dateFormatter.locale = Locale(identifier: "en_US")
                self.addItemLabel(label: "Last Access", value: dateFormatter.string(from: lastAccess))
            }
            
            let dictionary = displayedElement.asDictionary
            self.displayitemDictionary(dictionary)
            
            if let children = dictionary["childrenIDs"] as? [String: [Int]] {
                self.addChildrenLabels(children)
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
                
                if !(["id", "name", "isDirty", "isWriteable", "readToken", "writeToken", "lastAccess", "children"]).contains(key) {
                    if let strVal = value as? String {
                        self.addItemLabel(label: key, value: strVal)
                    } else if let boolVal = value as? Bool {
                        self.addItemLabel(label: key, value: boolVal ? "true" : "false")
                    } else if let intVal = value as? Int {
                        self.addItemLabel(label: key, value: String(intVal))
                    } else if let floatVal = value as? Float {
                        self.addItemLabel(label: key, value: String(floatVal))
                    } else if let locVal = value as? CLLocationCoordinate2D {
                        self.addItemLabel(label: key, value: "(" + String(locVal.latitude) + "," + String(locVal.longitude) + ")")
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
        
        self.addConstraints(thisElement: topLabel, height: topLabel.oneLineHeight)
    }
    
    /* ################################################################## */
    /**
     */
    func addChildrenLabels(_ inChildrenDictionary: [String: [Int]]) {
        let topLabel = UILabel()
        
        topLabel.text = "CHILDREN"
        topLabel.font = UIFont.systemFont(ofSize: 12)
        topLabel.textAlignment = .center
        
        self.addConstraints(thisElement: topLabel, height: topLabel.oneLineHeight)
        
        if let people = inChildrenDictionary["people"], !people.isEmpty {
            let newLabel = UILabel()
            newLabel.text = "people"
            newLabel.font = UIFont.italicSystemFont(ofSize: 12)
            newLabel.textAlignment = .center
            self.addConstraints(thisElement: newLabel, height: topLabel.oneLineHeight)

            for item in people.chunk(8) {
                let strVal = item.map(String.init).joined(separator: ",")
                self.addItemLabel(value: strVal)
            }
        }
        
        if let places = inChildrenDictionary["places"], !places.isEmpty {
            let newLabel = UILabel()
            newLabel.text = "places"
            newLabel.font = UIFont.italicSystemFont(ofSize: 12)
            newLabel.textAlignment = .center
            self.addConstraints(thisElement: newLabel, height: topLabel.oneLineHeight)

            for item in places.chunk(8) {
                let strVal = item.map(String.init).joined(separator: ",")
                self.addItemLabel(value: strVal)
            }
        }
        
        if let things = inChildrenDictionary["things"], !things.isEmpty {
            let newLabel = UILabel()
            newLabel.text = "things"
            newLabel.font = UIFont.italicSystemFont(ofSize: 12)
            newLabel.textAlignment = .center
            self.addConstraints(thisElement: newLabel, height: topLabel.oneLineHeight)

            for item in things.chunk(8) {
                let strVal = item.map(String.init).joined(separator: ",")
                self.addItemLabel(value: strVal)
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
        
        self.addConstraints(thisElement: theLabel, height: theLabel.oneLineHeight)
    }

    /* ################################################################## */
    /**
     */
    func addConstraints(thisElement inThisElement: UIView, height inHeight: CGFloat) {
        var previousView: UIView!
        
        if !self.subviews.isEmpty {
            previousView = self.subviews.last
        }
        
        self.addSubview(inThisElement)
        inThisElement.translatesAutoresizingMaskIntoConstraints = false
        
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
