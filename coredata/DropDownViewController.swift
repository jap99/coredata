//
//  DropDownViewController.swift
//  coredata
//
//  Created by Javid Poornasir on 8/23/17.
//  Copyright © 2017 Javid Poornasir. All rights reserved.
//

import UIKit

protocol DropDownDelegate {
    func dropDownValueSelected(key: String, value: String)
}

class DropDownViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
     var dataDictionary = [ "String" : ["1", "2", "3"],
                       "String2" : ["A", "B", "C"],
                       "String3" : ["X", "Y", "Z"]
                    ]
    
    var delegate: DropDownDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 1000
        
    }
    
    // MARK: - Table View Delegate and Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataDictionary.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keyArray = Array(dataDictionary.keys) // ["string", "string2", "string3"]
        let keyAtIndex = keyArray[section]  // for section = 0, it will give me "string"
        return (dataDictionary[keyAtIndex] as Array).count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let keyArray = Array(dataDictionary.keys)
        let keyAtIndex = keyArray[section]
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownTitle", for: indexPath) as! DropDownTitle
            cell.titleLabel.text = keyAtIndex
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownValue", for: indexPath) as! DropDownValue
            
            let dataValue = (dataDictionary[keyAtIndex] as Array)[indexPath.row - 1]
            cell.valueLabel.text = dataValue
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            if let delegate = delegate {
                let keyArray = Array(dataDictionary.keys)
                let keyAtIndex = keyArray[section]
                let dataValue = (dataDictionary[keyAtIndex] as Array)[indexPath.row - 1]
                
                self.dismiss(animated: true, completion: {
                    delegate.dropDownValueSelected(key: keyAtIndex, value: dataValue)
                })
            }
        }
    }
}


