//
//  BillEditViewController.swift
//  PPMS
//
//  Created by Jansen on 2/20/17.
//  Copyright © 2017 Jansen. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift

class BillEditViewController: FormViewController {
    
    var billObj: Bill? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if billObj == nil {
            billObj = Bill()
        }
        
        form +++ Section("Timing")
            <<< DateTimeInlineRow("CreateDate"){ row in
                row.title = "Create Date"
                row.value = billObj?.CreateDate as Date?
            }
            <<< DateTimeInlineRow("TransactionDate"){ row in
                row.title = "Transaction Date"
                row.value = billObj?.TransactionDate as Date?
            }
            <<< PushRow<String>("ProjectGID") {
                let projs = Project().GetAllProjectName()
                $0.title = "Project"
                $0.options = projs
                $0.value = Project().GetProjectNameByGuid(guid: (billObj?.ProjectGID)!)
                if projs.count == 0 {
                    $0.selectorTitle = "Please create Project first!"
                }else{
                    $0.selectorTitle = "Choose a Project"
                }
                
            }
            <<< PushRow<String>("CustomerGID") {
                let custs = Customer().GetAllName()
                $0.title = "Customer"
                $0.options = custs
                $0.value = Customer().GetByGUID(guid: (billObj?.CustomerGID)!).Company
                if custs.count == 0 {
                    $0.selectorTitle = "Please create customer!"
                }else{
                    $0.selectorTitle = "Choose a Customer"
                }
                
            }
            <<< DecimalRow("Amount"){ row in
                row.title = "Amount"
                row.placeholder = "What's your Amount?"
                row.value = billObj?.Amount
                
            }
            
            <<< SwitchRow("IsCompleted"){
                $0.title = "Is Completed?"
                $0.value = billObj?.IsCompleted
            }
            <<< TextAreaRow("Notes"){ row in
                row.title = "Notes"
                row.placeholder = "Notes"
                if (billObj?.Notes.characters.count)! > 0{
                    row.value = billObj?.Notes
                }
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
        if billObj == nil{
            billObj = Bill()
        }
        
        
        let valuesDictionary = form.values()
        
        var strVal = valuesDictionary["Notes"]
        
        if (strVal as? String != nil) {
            billObj?.Notes = strVal as! String
        }
        
        strVal = valuesDictionary["ProjectGID"]
        if (strVal as? String != nil) {
            strVal = Project().GetProjectGuidByName(name: strVal as! String)
            billObj?.ProjectGID = strVal as! String
        }
        strVal = valuesDictionary["CustomerGID"]
        if (strVal as? String != nil) {
            strVal = Customer().GetByName(name: strVal as! String).Guid
            billObj?.CustomerGID = strVal as! String
        }
        
        var dateVal = valuesDictionary["CreateDate"]
        
        if (dateVal as? Date != nil) {
            billObj?.CreateDate = (dateVal as? Date)!
        }
        
        dateVal = valuesDictionary["TransactionDate"]
        
        if (dateVal as? Date != nil) {
            billObj?.TransactionDate = (dateVal as? Date)!
        }
        
        billObj?.IsCompleted = valuesDictionary["IsCompleted"] as! Bool
        
        
        let doubleVal = valuesDictionary["Amount"]
        
        if (doubleVal as? Double != nil) {
            billObj?.Amount = doubleVal as! Double
        }
        
    }
    
    func Save() {
        updateObject()
        
        let realm = try! Realm()
        
        let dtls = realm.objects(Bill.self).filter("Guid = %@", (billObj?.Guid)!)
        if dtls.count > 0 {
            //existing history
            let theDtl = realm.objects(Bill.self).filter("Guid = %@", (billObj?.Guid)!).first
            try! realm.write {
                theDtl!.Guid = (billObj?.Guid)!
                theDtl!.CreateDate = (billObj?.CreateDate)!
                theDtl!.TransactionDate = (billObj?.TransactionDate)!
                theDtl!.Notes = (billObj?.Notes)!
                theDtl!.Amount = (billObj?.Amount)!
                theDtl!.IsCompleted = (billObj?.IsCompleted)!
                theDtl!.ProjectGID = (billObj?.ProjectGID)!
                theDtl!.CustomerGID = (billObj?.CustomerGID)!
            }
        }else{
            //insert a new one
            try! realm.write {
                let theDtl = Bill()
                theDtl.Guid = (billObj?.Guid)!
                theDtl.CreateDate = (billObj?.CreateDate)!
                theDtl.TransactionDate = (billObj?.TransactionDate)!
                theDtl.Notes = (billObj?.Notes)!
                theDtl.Amount = (billObj?.Amount)!
                theDtl.IsCompleted = (billObj?.IsCompleted)!
                theDtl.ProjectGID = (billObj?.ProjectGID)!
                theDtl.CustomerGID = (billObj?.CustomerGID)!
                realm.add(billObj!)
                
                
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
