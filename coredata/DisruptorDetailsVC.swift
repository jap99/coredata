//
//  DisruptorDetailsVC.swift
//  coredata
//
//  Created by Javid Poornasir on 8/23/17.
//  Copyright © 2017 Javid Poornasir. All rights reserved.
//

import UIKit

class DisruptorDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var disruptorDetail: DisruptorDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 1000
        
        tableView.reloadData()
    }

    // MARK: - Table View Delegate and Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // SECTION = 1: Represent buyer section
        if section == 1 {
            if let disruptorDetail = disruptorDetail {
                if let leadType = disruptorDetail.leadType, leadType == "BUYER" {
                    return 11
                }
            }
        } else {
            if let disruptorDetail = disruptorDetail {
                if let leadType = disruptorDetail.leadType, leadType == "SELLER" {
                    return 12
                }
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisruptorDetailsCell", for: indexPath) as! DisruptorDetailsCell
        
        var key = ""
        var value = ""
        if let disruptorDetail = disruptorDetail {
            // SECTION = 1: Represent buyer section
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    key = "number"
                    value = (disruptorDetail.number != nil) ? disruptorDetail.number?.description : ""
                } else if indexPath.row == 1 {
                    key = "email"
                    value = (disruptorDetail.email != nil) ? disruptorDetail.email! : ""
                } else if indexPath.row == 2 {
                    key = "city"
                    value = (disruptorDetail.city != nil) ? disruptorDetail.city! : ""
                } else if indexPath.row == 3 {
                    key = "leadCreationDate"
                    value = (disruptorDetail.leadCreationDate != nil) ? disruptorDetail.leadCreationDate! : ""
                } else if indexPath.row == 4 {
                    key = "leadAcceptanceDate"
                    value = (disruptorDetail.leadAcceptanceDate != nil) ? disruptorDetail.leadAcceptanceDate! : ""
                } else if indexPath.row == 5 {
                    key = "mortStatus"
                    value = (disruptorDetail.mortStatus != nil) ? disruptorDetail.mortStatus! : ""
                } else if indexPath.row == 6 {
                    key = "bed"
                    value = (disruptorDetail.bed != nil) ? disruptorDetail.bed! : ""
                } else if indexPath.row == 7 {
                    key = "bath"
                    value = (disruptorDetail.bath != nil) ? disruptorDetail.bath! : ""
                } else if indexPath.row == 8 {
                    key = "buyerCities"
                    value = (disruptorDetail.buyerCities != nil) ? disruptorDetail.buyerCities!.joined(separator: ",") : ""
                } else if indexPath.row == 9 {
                    key = "timeFrame"
                    value = (disruptorDetail.timeFrame != nil) ? disruptorDetail.timeFrame! : ""
                } else if indexPath.row == 10 {
                    key = "matchID"
                    value = (disruptorDetail.matchID != nil) ? disruptorDetail.matchID! : ""
                }
            } else {
                if indexPath.row == 0 {
                    key = "number"
                    value = (disruptorDetail.number != nil) ? disruptorDetail.number?.description : ""
                } else if indexPath.row == 1 {
                    key = "email"
                    value = (disruptorDetail.email != nil) ? disruptorDetail.email! : ""
                } else if indexPath.row == 2 {
                    key = "leadCreationDate"
                    value = (disruptorDetail.leadCreationDate != nil) ? disruptorDetail.leadCreationDate! : ""
                } else if indexPath.row == 3 {
                    key = "leadAcceptanceDate"
                    value = (disruptorDetail.leadAcceptanceDate != nil) ? disruptorDetail.leadAcceptanceDate! : ""
                } else if indexPath.row == 4 {
                    key = "mortStatus"
                    value = (disruptorDetail.mortStatus != nil) ? disruptorDetail.mortStatus! : ""
                } else if indexPath.row == 5 {
                    key = "bed"
                    value = (disruptorDetail.bed != nil) ? disruptorDetail.bed! : ""
                } else if indexPath.row == 6 {
                    key = "bath"
                    value = (disruptorDetail.bath != nil) ? disruptorDetail.bath! : ""
                } else if indexPath.row == 7 {
                    key = "buyerCities"
                    value = (disruptorDetail.buyerCities != nil) ? disruptorDetail.buyerCities!.joined(separator: ",") : ""
                } else if indexPath.row == 8 {
                    key = "reason"
                    value = (disruptorDetail.reason != nil) ? disruptorDetail.reason! : ""
                } else if indexPath.row == 9 {
                    key = "priceMin"
                    value = (disruptorDetail.priceMin != nil) ? disruptorDetail.priceMin?.description : ""
                } else if indexPath.row == 10 {
                    key = "timeFrame"
                    value = (disruptorDetail.timeFrame != nil) ? disruptorDetail.timeFrame! : ""
                } else if indexPath.row == 11 {
                    key = "matchID"
                    value = (disruptorDetail.matchID != nil) ? disruptorDetail.matchID! : ""
                }
            }
        }
        
        
        cell.keyLabel.text = key
        cell.valueLabel.text = value
        
        return cell
    }

}
