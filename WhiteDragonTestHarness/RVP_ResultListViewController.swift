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

/* ###################################################################################################################################### */
// MARK: - Navigation Controller Class -
/* ###################################################################################################################################### */
/**
 */
class RVP_ResultListNavController: UINavigationController {
    var resultObjectList: [A_RVP_Cocoa_SDK_Object] = []
}

/* ###################################################################################################################################### */
// MARK: - Main Class -
/* ###################################################################################################################################### */
/**
 */
class RVP_ResultListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var resultObjectList: [A_RVP_Cocoa_SDK_Object] {
        get {
            if let navCtl = self.navigationController as? RVP_ResultListNavController {
                return navCtl.resultObjectList
            }
            
            return []
        }
        
        set {
            if let navCtl = self.navigationController as? RVP_ResultListNavController {
                navCtl.resultObjectList = newValue
            }
        }
    }
    
    @IBOutlet weak var resultListTableView: UITableView!
    
    /* ################################################################## */
    /**
     */
    private func _showObjectDetails(_ inObject: A_RVP_Cocoa_SDK_Object) {
        self.performSegue(withIdentifier: "show-object-details", sender: inObject)
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func doneButtonHit(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    /* ################################################################## */
    /**
     */
    private func _sortList() {
        self.resultObjectList = self.resultObjectList.sorted {
            var ret = $0.id < $1.id
            
            if !ret {   // Security objects get listed before data objects
                ret = $0 is A_RVP_Cocoa_SDK_Security_Object && $1 is A_RVP_Cocoa_SDK_Data_Object
            }
            
            return ret
        }
    }

    /* ################################################################## */
    /**
     */
    private func _applyConstraints(thisElement inThisElement: UIView, height inHeight: CGFloat, container inContainerElement: UITableViewCell) {
        inContainerElement.addSubview(inThisElement)
        inThisElement.translatesAutoresizingMaskIntoConstraints = false
        
        inContainerElement.addConstraints([
            NSLayoutConstraint(item: inThisElement,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: inContainerElement,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: 3),
            NSLayoutConstraint(item: inThisElement,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: inContainerElement,
                               attribute: .centerX,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: inThisElement,
                               attribute: .width,
                               relatedBy: .equal,
                               toItem: inContainerElement,
                               attribute: .width,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: inThisElement,
                               attribute: .height,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1.0,
                               constant: inHeight)
            ])
    }

    /* ################################################################## */
    /**
     */
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self._sortList()
        self.resultListTableView.reloadData()
    }
    
    /* ################################################################## */
    /**
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RVP_DisplayResultsScreenViewController {
            if let node = sender as? A_RVP_Cocoa_SDK_Object {
                destination.resultsArray = [node]
            }
        }
        
        super.prepare(for: segue, sender: nil)
    }

    /* ################################################################## */
    /**
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultObjectList.count
    }

    /* ################################################################## */
    /**
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var ret: UITableViewCell!   // If we don't have anything, then this will cause the method to crash; which is what we want. It shouldn't be called if we have nothing.
        
        if 0 < self.resultObjectList.count, indexPath.row < self.resultObjectList.count {
            let rowObject = self.resultObjectList[indexPath.row]
            var nameString = String(rowObject.id)
            if !rowObject.name.isEmpty {
                nameString = rowObject.name + " (" + nameString + ")"
            }
            
            let listLabel = UILabel()
            
            listLabel.text = nameString
            listLabel.font = UIFont.boldSystemFont(ofSize: 20)
            listLabel.textAlignment = .center
            let height: CGFloat = listLabel.oneLineHeight
            var frame = tableView.bounds
            frame.size.height = height
            ret = UITableViewCell(frame: frame)
            ret.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: ((0 == indexPath.row % 2) ? 0 : 0.05))
            self._applyConstraints(thisElement: listLabel, height: height, container: ret)
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if 0 < self.resultObjectList.count, indexPath.row < self.resultObjectList.count {
            tableView.deselectRow(at: indexPath, animated: true)
            let rowObject = self.resultObjectList[indexPath.row]
            self._showObjectDetails(rowObject)
        }
    }
}
