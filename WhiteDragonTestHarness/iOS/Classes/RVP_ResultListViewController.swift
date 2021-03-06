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
import WhiteDragon

/* ###################################################################################################################################### */
// MARK: - Navigation Controller Class -
/* ###################################################################################################################################### */
/**
 */
class RVP_ResultListNavController: UINavigationController {
    var sdkObject: RVP_Cocoa_SDK!
    /* ################################################################## */
    /**
     */
    var resultObjectList: [A_RVP_Cocoa_SDK_Object] = [] {
        didSet {
            self.resultObjectList = self.resultObjectList.sorted {
                var ret = false
                
                if let distanceA = ($0 as? A_RVP_Cocoa_SDK_Data_Object)?.distance, let distanceB = ($1 as? A_RVP_Cocoa_SDK_Data_Object)?.distance {
                    ret = distanceA < distanceB
                }
                
                if !ret {
                    ret = $0.id < $1.id
                }
                
                if !ret {   // Security objects get listed before data objects
                    ret = $0 is A_RVP_Cocoa_SDK_Security_Object && $1 is A_RVP_Cocoa_SDK_Data_Object
                }
                
                return ret
            }
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - Main Class -
/* ###################################################################################################################################### */
/**
 */
class RVP_ResultListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    /* ################################################################## */
    /**
     */
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
    
    /* ################################################################## */
    /**
     */
    var sdkInstance: RVP_Cocoa_SDK! {
        get {
            if let navCtl = self.navigationController as? RVP_ResultListNavController {
                return navCtl.sdkObject
            }
            
            return nil
        }
        
        set {
            if let navCtl = self.navigationController as? RVP_ResultListNavController {
                navCtl.sdkObject = newValue
            }
        }
    }
    
    @IBOutlet weak var resultListTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!

    /* ################################################################## */
    /**
     */
    private func _showObjectDetails(_ inObject: A_RVP_Cocoa_SDK_Object) {
        self.performSegue(withIdentifier: "show-object-details", sender: inObject)
    }
    
    /* ################################################################## */
    /**
     */
    private func _determineEditEligibility() {
        var editable: Bool = false
        
        for item in self.resultObjectList where item.isWriteable {
            editable = true
            break
        }
        
        self.editButton.isEnabled = editable
    }
    
    /* ################################################################## */
    /**
     */
    private func _determineDeleteEligibility() {
        self.deleteButton.isEnabled = nil != self.resultListTableView.indexPathsForSelectedRows && 0 < (self.resultListTableView.indexPathsForSelectedRows?.count)!
    }

    /* ################################################################## */
    /**
     */
    @IBAction func backButtonHit(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

    /* ################################################################## */
    /**
     */
    @IBAction func deleteButtonHit(_ sender: Any) {
        if let selectedRows = self.resultListTableView.indexPathsForSelectedRows, 0 < selectedRows.count {
            var instanceList: [A_RVP_Cocoa_SDK_Object] = []
            
            for selectedRow in selectedRows {
                instanceList.append(self.resultObjectList[selectedRow.row])
            }
            
            self.sdkInstance.deleteObjects(instanceList)
        }
    }

    /* ################################################################## */
    /**
     */
    @IBAction func editButtonHit(_ sender: Any! = nil) {
        if self.resultListTableView.isEditing {
            self.editButton.title = "Edit"
            self.deleteButton.isEnabled = false
            self.resultListTableView.isEditing = false
        } else {
            self.editButton.title = "Done"
            self.resultListTableView.isEditing = true
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
        self.resultListTableView.reloadData()
        let title = "\(self.resultObjectList.count) RESULTS"
        self.navigationItem.title = title
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
    func deleteTheseItems(_ inItems: [A_RVP_Cocoa_SDK_Object]) {
        var deleteIndexes: [Int] = []
        for index in 0..<self.resultObjectList.count {
            let inCompInstance = self.resultObjectList[index]
            for item in inItems where item.id == inCompInstance.id {
                // OK. The ID is unique in each database, so we check to see if an existing object and the given object are in the same database.
                if (item is A_RVP_Cocoa_SDK_Security_Object && inCompInstance is A_RVP_Cocoa_SDK_Security_Object) || (item is A_RVP_Cocoa_SDK_Data_Object && inCompInstance is A_RVP_Cocoa_SDK_Data_Object) {
                    deleteIndexes.append(index)
                }
            }
        }
        
        if !deleteIndexes.isEmpty {
            deleteIndexes = deleteIndexes.reversed()
            for index in 0..<deleteIndexes.count {
                self.resultObjectList.remove(at: deleteIndexes[index])
            }
            
            self.editButtonHit()
            self.resultListTableView.reloadData()
        }
    }

    /* ################################################################## */
    /**
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self._determineEditEligibility()
        return resultObjectList.count
    }

    /* ################################################################## */
    /**
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ret = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "")
        
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
            ret.frame = frame
            ret.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: ((0 == indexPath.row % 2) ? 0 : 0.05))
            self._applyConstraints(thisElement: listLabel, height: height, container: ret)
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     */
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return self.resultObjectList[indexPath.row].isWriteable ? .delete : .none
    }
    
    /* ################################################################## */
    /**
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing, 0 < self.resultObjectList.count, indexPath.row < self.resultObjectList.count {
            tableView.deselectRow(at: indexPath, animated: true)
            let rowObject = self.resultObjectList[indexPath.row]
            self._showObjectDetails(rowObject)
        } else {
            self._determineDeleteEligibility()
        }
    }
    
    /* ################################################################## */
    /**
     */
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            self._determineDeleteEligibility()
        }
    }
    
    /* ################################################################## */
    /**
     */
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        var ret = false
        
        if 0 < self.resultObjectList.count, indexPath.row < self.resultObjectList.count {
            ret = self.resultObjectList[indexPath.row].isWriteable
        }
        
        return ret
    }
}
