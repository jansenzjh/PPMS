//
//  Project.swift
//  PMS
//
//  Created by Jansen on 7/5/16.
//  Copyright © 2016 Jansen. All rights reserved.
//

import Foundation
import RealmSwift
//import SwiftDate

class Project: Object {
    dynamic var Guid: String = UUID().uuidString
    dynamic var Name = ""
    dynamic var StartDate = Date()
    dynamic var EndDate = Date()
    dynamic var Description = ""
    dynamic var Status = "Open"
    dynamic var CustomerGID = ""
    dynamic var Priority = "High"
    dynamic var Category = ""
    dynamic var Notes = ""
    dynamic var BillTypes = "Fixed Cost"
    dynamic var BillRatePerHour: Double = 0.0
    dynamic var FixedPrice: Double = 0.0
    
    func GetAllProjects(isActiveOnly: Bool) -> [Project]{
        
        let realm = try! Realm()
        if !isActiveOnly{
            let list = realm.objects(Project.self).sorted(byKeyPath: "EndDate", ascending: true)
            let projArr = Array(list)
            return projArr
        }else{
            let list = realm.objects(Project.self).filter("Status = %@", "Open").sorted(byKeyPath: "EndDate", ascending: true)
            let projArr = Array(list)
            return projArr
        }
    }
    
    func GetAllProjectName() -> Array<String>{
        let realm = try! Realm()
        let projs = realm.objects(Project.self).sorted(byKeyPath: "EndDate");
        var returnList = [String]()
        if projs.count > 0 {
            for i in 0..<projs.count{
                returnList.append((projs[i]).Name)
            }
        }
        return returnList
    }
    
    func GetProject(guid: String) -> Project{
        let obj = try! Realm().objects(Project.self).filter("Guid = %@", guid).first
        if (obj != nil){
            return (obj!)
        }else{
            return Project()
        }
    }
    
    func GetProjectNameByGuid(guid: String) -> String{
        return GetProject(guid: guid).Name
    }
    
    func GetProjectGuidByName(name: String) -> String{
        let obj = try! Realm().objects(Project.self).filter("Name = %@", name).first
        if (obj != nil){
            return (obj?.Guid)!
        }else{
            return ""
        }
    }
    
    func BillProject(projectGID: String){
        let proj = GetProject(guid: projectGID)
        proj.BillProject()
        
    }
    
    func Clone() -> Project{
        var theDtl = Project()
        theDtl.Name = (self.Name)
        theDtl.StartDate = (self.StartDate)
        theDtl.EndDate = (self.EndDate)
        theDtl.Description = (self.Description)
        theDtl.CustomerGID = (self.CustomerGID)
        theDtl.Priority = (self.Priority)
        theDtl.Category = (self.Category)
        theDtl.Notes = (self.Notes)
        theDtl.BillTypes = (self.BillTypes)
        theDtl.BillRatePerHour = (self.BillRatePerHour)
        theDtl.FixedPrice = (self.FixedPrice)
        return theDtl
    }
    
    func Update(){
        let realm = try! Realm()
        
        let dtls = realm.objects(Project.self).filter("Guid = %@", (self.Guid))
        if dtls.count > 0 {
            //existing history
            let theDtl = realm.objects(Project.self).filter("Guid = %@", (self.Guid)).first
            try! realm.write {
                
                theDtl!.Name = (self.Name)
                theDtl!.StartDate = (self.StartDate)
                theDtl!.EndDate = (self.EndDate)
                theDtl!.Status = self.Status
                theDtl!.Description = (self.Description)
                theDtl!.CustomerGID = (self.CustomerGID)
                theDtl!.Priority = (self.Priority)
                theDtl!.Category = (self.Category)
                theDtl!.Notes = (self.Notes)
                theDtl!.BillTypes = (self.BillTypes)
                theDtl!.BillRatePerHour = (self.BillRatePerHour)
                theDtl!.FixedPrice = (self.FixedPrice)
                
            }
        
        }
    }
    
    func Delete(guid: String){
        let realm = try! Realm()
        let obj = realm.objects(Project.self).filter("Guid = %@", guid).first
        if (obj != nil){
            try! realm.write{
                realm.delete(obj!)
            }
            let tasks = realm.objects(Task.self).filter("ProjectGID = %@", guid)
            try! realm.write{
                realm.delete(tasks)
            }
        }
    }
    func Count() -> Int{
        let realm = try! Realm()
        
        return realm.objects(Project.self).count
    }
    
    
    func BillProject(){
        //1. create bill
        let bill = Bill()
        bill.CreateDate = self.StartDate
        bill.TransactionDate = Date()
        bill.CustomerGID = self.CustomerGID
        bill.ProjectGID = self.Guid
        bill.TransactionType = "Invoice"
        bill.IsCompleted = true
        bill.Notes += "Invoiced on " + Date().string(custom: "MM/dd/yy hh:mm")
        if self.BillTypes == "Fixed Cost" {
            //1.1 if fixed get total
            bill.Amount = self.FixedPrice
        }else{
            //1.2 if by rate, get rate
            let timeClocks = TimeClock().GetAllByProjectGID(guid: self.Guid)
            var secondCount = 0
            for tc in timeClocks {
                secondCount += Int((tc.EndDate?.timeIntervalSince(tc.StartDate!))!)
            }
            let hours = Double(secondCount) / 3600
            bill.Amount = hours * self.BillRatePerHour
        }
        
        //1.4 save the bill
        Bill().Insert(billObj: bill)
        //2. mark project as complete
        let pj = self.Clone()
        pj.Status = "Close"
        pj.Update()
    }
}

