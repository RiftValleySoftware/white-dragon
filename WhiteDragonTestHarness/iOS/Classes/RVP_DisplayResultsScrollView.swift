/***************************************************************************************************************************/
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
import WhiteDragon

/* ###################################################################################################################################### */
// MARK: - Main Class -
/* ###################################################################################################################################### */
/**
 */
@IBDesignable
class RVP_DisplayResultsScrollView: UIScrollView {
    @IBOutlet var myViewController: RVP_DisplayResultsScreenViewController!

    var contentView: UIView!
    var sdkInstance: RVP_Cocoa_SDK!
    
    var results: [A_RVP_Cocoa_SDK_Object] = [] {
        didSet {
            self.establishSubviews()
        }
    }

    /* ################################################################## */
    /**
     */
    func nukem() {
        self.contentView?.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    /* ################################################################## */
    /**
     */
    func establishSubviews() {
        if nil == self.contentView {
            self.contentView = UIView()
            self.addSubview(self.contentView)
            self.contentView.translatesAutoresizingMaskIntoConstraints = false
            
            self.addConstraints([
                NSLayoutConstraint(item: self.contentView,
                                   attribute: .centerX,
                                   relatedBy: .equal,
                                   toItem: self,
                                   attribute: .centerX,
                                   multiplier: 1.0,
                                   constant: 0.0),
                NSLayoutConstraint(item: self.contentView,
                                   attribute: .width,
                                   relatedBy: .equal,
                                   toItem: self,
                                   attribute: .width,
                                   multiplier: 1.0,
                                   constant: 0.0),
                NSLayoutConstraint(item: self.contentView,
                                   attribute: .top,
                                   relatedBy: .equal,
                                   toItem: self,
                                   attribute: .top,
                                   multiplier: 1.0,
                                   constant: 0.0),
                NSLayoutConstraint(item: self.contentView,
                                   attribute: .bottom,
                                   relatedBy: .equal,
                                   toItem: self,
                                   attribute: .bottom,
                                   multiplier: 1.0,
                                   constant: 0.0)
                ])
        } else {
            self.nukem()
        }
        
        var previousViewElement: UIView!
        
        for item in self.results {
            let view = RVP_DisplayElementView()
            view.myController = self.myViewController
            view.displayedElement = item
            self.contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addConstraints([
                NSLayoutConstraint(item: view,
                                   attribute: .centerX,
                                   relatedBy: .equal,
                                   toItem: self.contentView,
                                   attribute: .centerX,
                                   multiplier: 1.0,
                                   constant: 0.0),
                NSLayoutConstraint(item: view,
                                   attribute: .width,
                                   relatedBy: .equal,
                                   toItem: self.contentView,
                                   attribute: .width,
                                   multiplier: 1.0,
                                   constant: 0.0)])
            
            if nil == previousViewElement {
                self.contentView.addConstraint(
                    NSLayoutConstraint(item: view,
                                       attribute: .top,
                                       relatedBy: .equal,
                                       toItem: self.contentView,
                                       attribute: .top,
                                       multiplier: 1.0,
                                       constant: 4))
            } else {
                self.contentView.addConstraint(
                    NSLayoutConstraint(item: view,
                                       attribute: .top,
                                       relatedBy: .equal,
                                       toItem: previousViewElement,
                                       attribute: .bottom,
                                       multiplier: 1.0,
                                       constant: 10))
            }
            
            previousViewElement = view
        }
        
        if nil != previousViewElement {
            contentView.addConstraint(
                NSLayoutConstraint(item: previousViewElement,
                                   attribute: .bottom,
                                   relatedBy: .equal,
                                   toItem: self.contentView,
                                   attribute: .bottom,
                                   multiplier: 1.0,
                                   constant: 4))
        }
        
        self.setNeedsLayout()
    }
}
