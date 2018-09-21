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
        
        self.addSubview(topLabel)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            NSLayoutConstraint(item: topLabel,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: topLabel,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .centerX,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: topLabel,
                               attribute: .width,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .width,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: topLabel,
                               attribute: .height,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1.0,
                               constant: 30)])
    }
}
