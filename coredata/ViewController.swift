//
//  ViewController.swift
//  coredata
//
//  Created by Javid Poornasir on 8/15/17.
//  Copyright © 2017 Javid Poornasir. All rights reserved.
//

import UIKit
//import SwiftyJSON
import CoreData

class DisruptorModel {
    var name  = ""
    var delay_interval_in_seconds  = 0
    var type = ""
}




class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var disruptorName: String?
    var disruptorType: String?
    var disruptorDelayInterval: Int?
    var dateDisruptorWasShown: Date?
    
    var dataArray = [ "String" : ["1", "2", "3"], "String2" : ["A", "B", "C"], "String3" : ["X", "Y", "Z"] ]
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let newDisruptor = NSEntityDescription.insertNewObject(forEntityName: "Disruptors", into: context)
    let newGlobalWrite = NSEntityDescription.insertNewObject(forEntityName: "Disruptors", into: context)
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Disruptors")
    let grequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GlobalWrite")
    
    var arrDis = [DisruptorModel]()
    
    var arrayDisruptorDetails = [DisruptorDetails]()
    
    var dropDownSelectedKey: String = ""
    var dropDownSelectedValue: String = ""
    // MARK: view methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 1000
        
        self.readJson {
            fetchResultsFromCoreData()
        }
    }
    
    func readJson(_:()->()) {
        do {
            arrDis.removeAll()
            if let file = Bundle.main.url(forResource: "JSON", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    if let arr = object["disruptors"] as? NSArray {
                        for dict in arr {
                            if let dictRecord = dict as? NSDictionary {
                                var record = DisruptorModel()
                                if let name = dictRecord["name"] as? String {
                                    record.name = name
                                }
                                if let second = dictRecord["delay_interval_in_seconds"] as? Int {
                                    record.delay_interval_in_seconds = second
                                }
                                if let type = dictRecord["type"] as? String {
                                    record.type = type
                                }
                                self.arrDis.append(record)
                            }
                        }
                    }
                    self.tableView.reloadData()
                    print(object)
                } else if let object = json as? [Any] {
                    // json is an array
                    print(object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getDisrDataDetailsFromAPI() {
        
        guard let token = LocalStore.getToken(), !token.isEmpty, let agentUuid = LocalStore.getAgentUuid(), !agentUuid.isEmpty else { return }
        ApiManager.sharedInstance.callDisrDataDetailsAPI(agentUuid) { response in
            
            switch response.result {
                
            case .success(let json):
                self.disrArray = [Disruptor]()
                self.disrArray?.removeAll()
                
                let response = SwiftyJSON.JSON(json)
                
                
               
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        
    }
    
    
    func fetchDisruptors() {
        
        guard let token = LocalStore.getToken(), !token.isEmpty, let agentUuid = LocalStore.getAgentUuid(), !agentUuid.isEmpty else { return }
        ApiManager.sharedInstance.callPermissionsAPI(agentUuid) { response in
            
            switch response.result {
                
            case .success(let json):
                self.disrArray = [Disruptor]()
                self.disrArray?.removeAll()
                
                let response = SwiftyJSON.JSON(json); print(response)
                
                // if there is a disruptor then we take it and check the disruptor type
                // we check whether we have the type in CD already or not; if yes then check the timeStamp on it
                // if we don't already have the type in CD; then create an object of that type in core data
                if let dict = response["disruptor"].dictionary {
                    var disruptor = Disruptor()
                    guard let seconds = dict["delay_interval_in_seconds"]?.int else { return }
                    guard let type = dict["type"]?.string else { return }
                    disruptor.type = type
                    disruptor.delay_interval_in_seconds = seconds
                    self.disrArray?.append(disruptor)
                    fetchGlobalTimeStampFromCoreData()
                }
                //                guard let disrType = response["disruptor"]["type"].string else { return }
                //                guard let disrDelayInt = response["disruptor"]["delay_interval_in_seconds"].int else { return }
            //                self.disruptorType = disrType; self.disruptorDelayInterval = disrDelayInt
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    func saveDataIntoDB() {
        if #available(iOS 10.0, *) {
            let context =  appDelegate.persistentContainer.viewContext
            for disruptor in disrArray! {
                let newDisr = NSEntityDescription.insertNewObject(forEntityName: "Disruptors", into: context)
                newDisr.setValue(Date().addingTimeInterval(disruptor.time_interval_inseconds), forKey: "timeStamp")
                newDisr.setValue(disruptor.type, forKey: "type")
                
                let newDisr2 = NSEntityDescription.insertNewObject(forEntityName: "GlobalTimeStamp", into: context)
                newDisr2.setValue(Date(), forKey: "timeStamp")
                
            }
            appDelegate.saveContext()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func fetchGlobalTimeStampFromCoreData() {
        if #available(iOS 10.0, *) {
            let context = appDelegate.persistentContainer.viewContext
            let newDisr2 = NSEntityDescription.insertNewObject(forEntityName: "GlobalTimeStamp", into: context)
            let request2 = NSFetchRequest<NSFetchRequestResult>(entityName: "GlobalTimeStamp")
            
            do {
                
                let results2 = try context.fetch(request2)
                print("RESULTS2 COUNT: \(results2.count)")
                
                if results2.count > 0 {
                    
                    for result2 in results2 as! [NSManagedObject] {
                        var timeStamp = result2.value(forKey: "globalTimeStamp") as? Date
                        if timeStamp == nil {
                            
                        }
                        
                        let currentDate = Date()
                        let seconds = currentDate.seconds(from: timeStamp)
                        if seconds >= 3600 {
                            
                            if results.count > 1 {
                                print("PRINTING RESULTS: \(results)")
                                for result in results as! [NSManagedObject] {
                                    
                                    guard let type = result.value(forKey: "type") as? String else { continue }
                                    for disruptor in self.disrArray! {
                                        if disruptor.type == type {
                                            
                                            switch type {
                                            case "progress_report":
                                                
                                                // anytime we make a write to ANY entity then we update a global timestamp
                                                if let timeStamp = result.value(forKey: "timeStamp") as? Date {
                                                    
                                                    let currentDate = NSDate()
                                                    if currentDate >= timeStamp {
                                                        
                                                        let timeDisruptorIsAllowedToBeShown = currentDate.addingTimeInterval(disruptor.delay_interval_in_seconds)
                                                        
                                                        result2.setValue(Date(), forKey: "globalTimeStamp")
                                                        result.setValue(timeDisruptorIsAllowedToBeShown, forKey: "timeStamp")
                                                        result.setValue(disruptor.type, forKey: "type")
                                                        
                                                        
                                                        do {
                                                            try appDelegate.persistentContainer.viewContext.save()
                                                            print("saved!")
                                                        } catch let error as NSError  {
                                                            print("Could not save \(error)")
                                                        } catch {
                                                            
                                                        }
                                                    }
                                                    
                                                    
                                                } else { // ------ If no timeStamp is available (meaning, no reference to having shown any disruptor before)
                                                    
                                                    guard let delayInt = result.value(forKey: "delayInterval") as? Int else { continue }
                                                    guard let type = result.value(forKey: "type") as? String else { continue }
                                                    
                                                    updateTimeStamp(newDisr, context, {
                                                        presentDisruptorVC(type, delayInt)
                                                    })
                                                }
                                                
                                            default:
                                                break
                                            }
                                            
                                            
                                        }
                                    }
                                }
                                
                            } else {
                                
                            }
                            
                        }
                    }
                } else {
                    // add the object to core data
                    saveDataIntoDB()
                }
                
            } catch { print("Error retrieving data from core data") }
        } else {
            // Revert to older versions
            print("Fallback on earlier versions. Error saving disruptor data into core data; need to implement code for older OS.")
        }
    }
    
    func fetchDisruptorFromCD() {
        
        let context = appDelegate.persistentContainer.viewContext
        let newDisr = NSEntityDescription.insertNewObject(forEntityName: "Disruptors", into: context)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Disruptors")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            let results2 = try context.fetch(request2)
            print("RESULTS COUNT: \(results.count)")
            print("RESULTS2 COUNT: \(results2.count)")
            
            if results2.count > 0 {
                
                for result2 in results2 as! [NSManagedObject] {
                    var timeStamp = result2.value(forKey: "globalTimeStamp") as? Date
                    if timeStamp == nil {
                        
                    }
                    
                    let currentDate = Date()
                    let seconds = currentDate.seconds(from: timeStamp)
                    if seconds >= 3600 {
                        
                        if results.count > 1 {
                            print("PRINTING RESULTS: \(results)")
                            for result in results as! [NSManagedObject] {
                                
                                guard let type = result.value(forKey: "type") as? String else { continue }
                                for disruptor in self.disrArray! {
                                    if disruptor.type == type {
                                        
                                        switch type {
                                        case "progress_report":
                                            
                                            // anytime we make a write to ANY entity then we update a global timestamp
                                            if let timeStamp = result.value(forKey: "timeStamp") as? Date {
                                                
                                                let currentDate = NSDate()
                                                if currentDate >= timeStamp {
                                                    
                                                    let timeDisruptorIsAllowedToBeShown = currentDate.addingTimeInterval(disruptor.delay_interval_in_seconds)
                                                    
                                                    result2.setValue(Date(), forKey: "globalTimeStamp")
                                                    result.setValue(timeDisruptorIsAllowedToBeShown, forKey: "timeStamp")
                                                    result.setValue(disruptor.type, forKey: "type")
                                                    
                                                    
                                                    do {
                                                        try appDelegate.persistentContainer.viewContext.save()
                                                        print("saved!")
                                                    } catch let error as NSError  {
                                                        print("Could not save \(error)")
                                                    } catch {
                                                        
                                                    }
                                                }
                                                
                                                
                                            } else { // ------ If no timeStamp is available (meaning, no reference to having shown any disruptor before)
                                                
                                                guard let delayInt = result.value(forKey: "delayInterval") as? Int else { continue }
                                                guard let type = result.value(forKey: "type") as? String else { continue }
                                                
                                                updateTimeStamp(newDisr, context, {
                                                    presentDisruptorVC(type, delayInt)
                                                })
                                            }
                                            
                                        default:
                                            break
                                        }
                                        
                                        
                                    }
                                }
                            }
                            
                        } else {
                            
                        }
                        
                    }
                }
            } else {
                // add the object to core data
                saveDataIntoDB()
            }
            
        } catch { print("Error retrieving data from core data") }
        
    }
    
    func updateTimeStamp(_ newDisruptor: NSManagedObject, _ context: NSManagedObjectContext, _ : () -> ()) {
        
        do {
            self.dateDisruptorWasShown = Date()
            newDisruptor.setValue(String(describing: self.dateDisruptorWasShown), forKey: "timeStamp")
            try context.save()
        } catch {
            print("Error updating timeStamp")
        }
    }
    
    func presentDisruptorVC(_ type: String, _ delayInt: Int) {
        let vc = DisruptorViewController.instantiate(fromAppStoryboard: .disruptor)
        vc.lblText = "\(delayInt)"
        vc.typeText = "\(type)"
        let nc = UINavigationController(rootViewController: vc)
        self.present(nc, animated: true, completion: nil)
    }
    
    func saveDisruptorToCoreData(_ newDisruptor: NSManagedObject, _ disrType: String, _ disrDelayInt: Int, _ context: NSManagedObjectContext) {
        do {
            updateTimeStamp(newDisruptor, context, {})
            newDisruptor.setValue(disrType, forKey: "type")
            newDisruptor.setValue(disrDelayInt, forKey: "delayInterval")
            try context.save()
        } catch {
            print("Error saving disruptor data into core data")
        }
    }
    
    
    // MARK: - Table View Delegate and Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayDisruptorDetails.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dataObj = self.arrayDisruptorDetails[indexPath.section]
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! DisruptorCell1
            
            cell.nameLabel.text = dataObj.firstName!
            cell.cityPriceLbl.text = "\(dataObj.city!), \(dataObj.priceMax!)"
            
            if dataObj.leadType == "Buyer" {
                cell.img.image = UIImage(named: "buyerimage")
            } else {
                cell.img.image = UIImage(named: "sellerimage")
            }
            
            return cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! DisruptorCell2
            cell.lbl1.text = dropDownSelectedKey
            cell.lbl2.text = dropDownSelectedValue
            
            return cell
            
        } else if indexPath.row < (2 + dataArray.count) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! DisruptorCell2
            
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! DisruptorCell3
            
            
            return cell
            
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let dataObj = self.arrayDisruptorDetails[indexPath.section]
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vC = storyBoard.instantiateViewController(withIdentifier: "DisruptorDetailsVC") as DisruptorDetailsVC
            vC.disruptorDetail = dataObj
            self.present(vC, animated: true, completion: nil)
            
        } else if indexPath.row == 1 {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vC = storyBoard.instantiateViewController(withIdentifier: "DropDownViewController") as DropDownViewController
            vC.delegate = self
            self.present(vC, animated: true, completion: nil)
        }
    }
    
}




extension ViewController: DropDownDelegate {
    func dropDownValueSelected(key: String, value: String) {
        dropDownSelectedKey = key
        dropDownSelectedValue = value
    }
}








