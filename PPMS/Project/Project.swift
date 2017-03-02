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
    dynamic var StartDate = NSDate()
    dynamic var EndDate = NSDate()
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
            let list = realm.objects(Project.self)
            let projArr = Array(list)
            return projArr
        }else{
            let list = realm.objects(Project.self).filter("Status = 1")
            let projArr = Array(list)
            return projArr
        }
    }
    
    func GetAllProjectName() -> Array<String>{
        let realm = try! Realm()
        let projs = realm.objects(Project.self);
        var returnList = [String]()
        if projs.count > 0 {
            for i in 0..<projs.count{
                returnList.append((projs[i]).Name)
            }
        }
        return returnList
    }
    
    func GetProjectNameByGuid(guid: String) -> String{
        let obj = try! Realm().objects(Project.self).filter("Guid = %@", guid).first
        if (obj != nil){
            return (obj?.Name)!
        }else{
            return ""
        }
    }
    
    func GetProjectGuidByName(name: String) -> String{
        let obj = try! Realm().objects(Project.self).filter("Name = %@", name).first
        if (obj != nil){
            return (obj?.Guid)!
        }else{
            return ""
        }
    }
    
}


class PriorityModel{
    func getPriorityText(priority : Int) -> String{
        switch(priority){
        case 0:
            return "High"
            
        case 1:
            return "Medium"
            
        case 2:
            return "Low"
            
        default:
            return ""
            
        }
    }
}
