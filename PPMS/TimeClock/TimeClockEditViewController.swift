//
//  TimeClockEditViewController.swift
//  PPMS
//
//  Created by Jansen on 2/20/17.
//  Copyright © 2017 Jansen. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift

class TimeClockEditViewController: FormViewController {
    
    var timeClockObj: TimeClock? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if timeClockObj == nil {
            timeClockObj = TimeClock()
        }
        
        form +++ Section("Timing")
            <<< DateTimeInlineRow("StartDate"){ row in
                row.title = "Start"
                row.value = timeClockObj?.StartDate as Date?
            }
            <<< DateTimeInlineRow("EndDate"){ row in
                row.title = "End"
                row.value = timeClockObj?.EndDate as Date?
            }
            <<< PushRow<String>("ProjectGID") {
                let projs = Project().GetAllProjectName()
                $0.title = "Project"
                $0.options = projs
                $0.value = Project().GetProjectNameByGuid(guid: (timeClockObj?.ProjectGID)!)
                if projs.count == 0 {
                    $0.selectorTitle = "Please create Project first!"
                }else{
                    $0.selectorTitle = "Choose a Project"
                }
                
            }
            <<< SwitchRow("IsClockIn"){
                $0.title = "Is Clock In?"
                $0.value = timeClockObj?.IsClockIn
            }
            <<< TextAreaRow("Description"){ row in
                row.title = "Description"
                row.placeholder = "Description"
                if (timeClockObj?.Description.characters.count)! > 0{
                    row.value = timeClockObj?.Description
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
        if timeClockObj == nil{
            timeClockObj = TimeClock()
        }
        
        
        let valuesDictionary = form.values()
        
        var strVal = valuesDictionary["Description"]
        
        if (strVal as? String != nil) {
            timeClockObj?.Description = strVal as! String
        }
        
        strVal = valuesDictionary["ProjectGID"]
        if (strVal as? String != nil) {
            strVal = Project().GetProjectGuidByName(name: strVal as! String)
            timeClockObj?.ProjectGID = strVal as! String
        }
        
        var dateVal = valuesDictionary["StartDate"]
        
        if (dateVal as? Date != nil) {
            timeClockObj?.StartDate = dateVal as? Date
        }
        
        dateVal = valuesDictionary["EndDate"]
        
        if (dateVal as? Date != nil) {
            timeClockObj?.StartDate = dateVal as? Date
        }
        
        timeClockObj?.IsClockIn = valuesDictionary["IsClockIn"] as! Bool
        
        
    }
    
    func Save() {
        updateObject()
        
        let realm = try! Realm()
        
        let dtls = realm.objects(TimeClock.self).filter("Guid = %@", (timeClockObj?.Guid)!)
        if dtls.count > 0 {
            //existing history
            let theDtl = realm.objects(TimeClock.self).filter("Guid = %@", (timeClockObj?.Guid)!).first
            try! realm.write {
                theDtl!.StartDate = (timeClockObj?.StartDate)!
                theDtl!.EndDate = (timeClockObj?.EndDate)!
                theDtl!.Description = (timeClockObj?.Description)!
                theDtl!.IsClockIn = (timeClockObj?.IsClockIn)!
                theDtl!.ProjectGID = (timeClockObj?.ProjectGID)!
            }
        }else{
            //insert a new one
            try! realm.write {
                let theDtl = TimeClock()
                theDtl.StartDate = (timeClockObj?.StartDate)!
                theDtl.EndDate = (timeClockObj?.EndDate)!
                theDtl.Description = (timeClockObj?.Description)!
                theDtl.IsClockIn = (timeClockObj?.IsClockIn)!
                theDtl.ProjectGID = (timeClockObj?.ProjectGID)!
                realm.add(timeClockObj!)
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
