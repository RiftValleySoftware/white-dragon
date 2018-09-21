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
            self.addBoolLabel(label: "Modified", value: displayedElement.isDirty)
            self.addBoolLabel(label: "Writeable", value: displayedElement.isWriteable)
            if let token = displayedElement.readToken {
                self.addIntLabel(label: "Read Token", value: token)
            }
            if let token = displayedElement.writeToken {
                self.addIntLabel(label: "Write Token", value: token)
            }
            if let lastAccess = displayedElement.lastAccess {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .short
                dateFormatter.locale = Locale(identifier: "en_US")
                self.addStringLabel(label: "Last Access", value: dateFormatter.string(from: lastAccess))
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
                                   constant: 0)])
        }
        
        self.setNeedsLayout()
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
    func addIntLabel(label inLabel: String, value inValue: Int) {
        let theLabel = UILabel()
        
        theLabel.text = inLabel + ": " + String(inValue)
        theLabel.font = UIFont.systemFont(ofSize: 12)
        theLabel.textAlignment = .center
        
        self.addConstraints(thisElement: theLabel, height: theLabel.oneLineHeight)
    }
    
    /* ################################################################## */
    /**
     */
    func addBoolLabel(label inLabel: String, value inValue: Bool) {
        let theLabel = UILabel()
        
        theLabel.text = inLabel + ": " + (inValue ? "true" : "false")
        theLabel.font = UIFont.systemFont(ofSize: 12)
        theLabel.textAlignment = .center
        
        self.addConstraints(thisElement: theLabel, height: theLabel.oneLineHeight)
    }
    
    /* ################################################################## */
    /**
     */
    func addStringLabel(label inLabel: String, value inValue: String) {
        let theLabel = UILabel()
        
        theLabel.text = inLabel + ": " + inValue
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
