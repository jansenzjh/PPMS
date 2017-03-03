//
//  ProjectEditViewController.swift
//  PPMS
//
//  Created by Jansen on 2/19/17.
//  Copyright © 2017 Jansen. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift
import GSMessages

class ProjectEditViewController: FormViewController {

    
    var projectObj: Project? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let realm = try! Realm()
//        debugPrint("Path to realm file: " + realm.configuration.fileURL!.absoluteString)
        if projectObj == nil {
            projectObj = Project()
        }
        
        form +++ Section("Information")
            <<< TextRow("Name"){ row in
                row.title = "Name"
                row.placeholder = "Name"
                if (projectObj?.Name.characters.count)! > 0 {
                    row.value = projectObj?.Name
                }
                row.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .user, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
            }
            
            <<< DateRow("StartDate"){ row in
                row.title = "Start Date"
                row.value = projectObj?.StartDate as Date?
                row.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .calendar, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
                
            }
            <<< DateRow("EndDate"){ row in
                row.title = "End Date"
                row.value = projectObj?.EndDate as Date?
                row.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .calendar, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
            }
            
            <<< PushRow<String>("CustomerGID") {
                let custs = Customer().GetAllName()
                $0.title = "Customer"
                $0.options = custs
                $0.value = Customer().GetByGUID(guid: (projectObj?.CustomerGID)!).Company
                if custs.count == 0 {
                    $0.selectorTitle = "Please create customer!"
                }else{
                    $0.selectorTitle = "Choose a Customer"
                }
                $0.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .userCircle, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
            }
        
            <<< TextAreaRow("Description"){ row in
                row.title = "Description"
                row.placeholder = "Description"
                if (projectObj?.Description.characters.count)! > 0{
                    row.value = projectObj?.Description
                }
                
            }
            
            +++ Section("Status")
            
            <<< SegmentedRow<String>("Status"){
                $0.title = "Status"
                $0.options = ["Open", "Close"]
                $0.value = projectObj?.Status
                $0.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .thermometerHalf, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
                
            }
            
            <<< SegmentedRow<String>("Priority"){
                $0.title = "Priority"
                $0.options = ["Critical", "High", "Medium", "Low"]
                $0.value = projectObj?.Priority
                $0.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .arrowUp, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
            }
            <<< TextRow("Category"){ row in
                row.title = "Category"
                row.placeholder = "Category"
                if (projectObj?.Category.characters.count)! > 0{
                    row.value = projectObj?.Category
                }
                row.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .filesO, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
            }
            
            <<< TextAreaRow("Notes"){ row in
                row.title = "Notes"
                row.placeholder = "Please enter Notes here"
                if (projectObj?.Notes.characters.count)! > 0{
                    row.value = projectObj?.Notes
                }
            }

            +++ Section("Billing Information")
            <<< SegmentedRow<String>("BillTypes"){
                $0.title = "Bill Types"
                $0.options = ["Fixed Cost", "Hour Rate"]
                $0.value = projectObj?.BillTypes
                $0.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .money, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
                }

            <<< DecimalRow("BillRate"){ row in
                row.title = "Bill Rate per Hour"
                row.placeholder = "What's your rate?"
                row.value = projectObj?.BillRatePerHour
                
                row.hidden = Condition.function(["BillTypes"], { form in
                    let rowVal = (form.rowBy(tag: "BillTypes") as? SegmentedRow<String>)?.value
                    return !(rowVal == "Hour Rate")
                })
                row.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .creditCard, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
                
            }
            <<< DecimalRow("FixedPrice"){ row in
                row.title = "Price"
                row.placeholder = "What's your fixed rate?"
                row.value = projectObj?.FixedPrice
                row.hidden = Condition.function(["BillTypes"], { form in
                    return !((form.rowBy(tag: "BillTypes") as? SegmentedRow<String>)?.value != "Hour Rate")
                })
                row.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .creditCard, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
                
            }

            
            +++ Section("Actions")
            <<< ButtonRow("Save"){
                $0.title = "Save"
                }.onCellSelection { [weak self] (cell, row) in
                    self?.Save()
                    _ = self?.navigationController?.popViewController(animated: true)
            }
        
    }
    
    
    func updateObject() {
        if projectObj == nil{
            projectObj = Project()
        }
        
        
        let valuesDictionary = form.values()
        
        var strVal = valuesDictionary["Name"]
        
        if (strVal as? String != nil) {
            projectObj?.Name = strVal as! String
        }
        
        var dateVal = valuesDictionary["StartDate"]
        projectObj?.StartDate = (dateVal as! Date)
        
        dateVal = valuesDictionary["EndDate"]
        projectObj?.EndDate = dateVal as! Date
        
        strVal = valuesDictionary["Description"]
        if (strVal as? String != nil) {
            projectObj?.Description = strVal as! String
        }
        
        strVal = valuesDictionary["Status"]
        if (strVal as? String != nil) {
            projectObj?.Status = strVal as! String
        }
        
        strVal = valuesDictionary["CustomerGID"]
        if (strVal as? String != nil) {
            strVal = Customer().GetByName(name: strVal as! String).Guid
            projectObj?.CustomerGID = strVal as! String
        }
        
        strVal = valuesDictionary["Priority"]
        if (strVal as? String != nil) {
            projectObj?.Priority = strVal as! String
        }
        
        strVal = valuesDictionary["Category"]
        if (strVal as? String != nil) {
            projectObj?.Category = strVal as! String
        }
        
        strVal = valuesDictionary["Notes"]
        if (strVal as? String != nil) {
            projectObj?.Notes = strVal as! String
        }
        
        strVal = valuesDictionary["BillTypes"]
        if (strVal as? String != nil) {
            projectObj?.BillTypes = strVal as! String
        }
        
        var doubleVal = valuesDictionary["BillRate"]
        if (doubleVal as? Double != nil) {
            projectObj?.BillRatePerHour = doubleVal as! Double
        }
    
        doubleVal = valuesDictionary["FixedPrice"]
        if (doubleVal as? Double != nil) {
            projectObj?.FixedPrice = doubleVal as! Double
        }
        
    }
    
    func Save() {
        updateObject()
        
        let realm = try! Realm()
        
        let dtls = realm.objects(Project.self).filter("Guid = %@", (projectObj?.Guid)!)
        if dtls.count > 0 {
            //existing history
            let theDtl = realm.objects(Project.self).filter("Guid = %@", (projectObj?.Guid)!).first
            try! realm.write {
                
                
                theDtl!.Name = (projectObj?.Name)!
                theDtl!.StartDate = (projectObj?.StartDate)!
                theDtl!.EndDate = (projectObj?.EndDate)!
                theDtl!.Description = (projectObj?.Description)!
                theDtl!.CustomerGID = (projectObj?.CustomerGID)!
                theDtl!.Priority = (projectObj?.Priority)!
                theDtl!.Category = (projectObj?.Category)!
                theDtl!.Notes = (projectObj?.Notes)!
                theDtl!.BillTypes = (projectObj?.BillTypes)!
                theDtl!.BillRatePerHour = (projectObj?.BillRatePerHour)!
                theDtl!.FixedPrice = (projectObj?.FixedPrice)!
                
            }
        }else{
            //insert a new one
            try! realm.write {
                let theDtl = Project()
                theDtl.Name = (projectObj?.Name)!
                theDtl.StartDate = (projectObj?.StartDate)!
                theDtl.EndDate = (projectObj?.EndDate)!
                theDtl.Description = (projectObj?.Description)!
                theDtl.Priority = (projectObj?.Priority)!
                theDtl.Category = (projectObj?.Category)!
                theDtl.Notes = (projectObj?.Notes)!
                theDtl.BillTypes = (projectObj?.BillTypes)!
                theDtl.BillRatePerHour = (projectObj?.BillRatePerHour)!
                theDtl.FixedPrice = (projectObj?.FixedPrice)!
                
                
                realm.add(projectObj!)
            }
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segueUnwindToList
        if (segue.identifier == "segueUnwindToList") {
            
            //self.Save()
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    

}
