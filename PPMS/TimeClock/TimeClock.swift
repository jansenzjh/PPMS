//
//  TimeClock.swift
//  PPMS
//
//  Created by Jansen on 2/27/17.
//  Copyright © 2017 Jansen. All rights reserved.
//

import Foundation
import RealmSwift

class TimeClock: Object {
    
    dynamic var StartDate: Date? = Date()
    dynamic var EndDate: Date? = Date()
    dynamic var Description = ""
    dynamic var IsClockIn = false
    dynamic var ProjectGID = ""
    dynamic var Guid: String = UUID().uuidString

    func GetCurrentTimeClock() -> TimeClock{
        let obj = try! Realm().objects(TimeClock.self).filter("IsClockIn = %@", true)
            .sorted(byKeyPath: "EndDate", ascending: false).first
        if (obj != nil){
            let theDtl = TimeClock()
            theDtl.Guid = (obj?.Guid)!
            theDtl.StartDate = (obj?.StartDate)!
            theDtl.EndDate = (obj?.EndDate)!
            theDtl.Description = (obj?.Description)!
            theDtl.IsClockIn = (obj?.IsClockIn)!
            theDtl.ProjectGID = (obj?.ProjectGID)!
            return theDtl
        }else{
            return TimeClock()
        }
    }
    
    func Insert(timeClock: TimeClock){
        
        let realm = try! Realm()
        
        try! realm.write {
            let theDtl = TimeClock()
            theDtl.StartDate = (timeClock.StartDate)!
            theDtl.EndDate = (timeClock.EndDate)!
            theDtl.Description = (timeClock.Description)
            theDtl.IsClockIn = (timeClock.IsClockIn)
            theDtl.ProjectGID = (timeClock.ProjectGID)
            realm.add(timeClock)
        }
    }
    
    func Update(timeClock: TimeClock){
        let realm = try! Realm()
        
        let dtls = realm.objects(TimeClock.self).filter("Guid = %@", (timeClock.Guid))
        if dtls.count > 0 {
            //existing history
            let theDtl = realm.objects(TimeClock.self).filter("Guid = %@", (timeClock.Guid)).first
            try! realm.write {
                theDtl!.StartDate = (timeClock.StartDate)!
                theDtl!.EndDate = (timeClock.EndDate)!
                theDtl!.Description = (timeClock.Description)
                theDtl!.IsClockIn = (timeClock.IsClockIn)
                theDtl!.ProjectGID = (timeClock.ProjectGID)
            }
        }
    }
    func Delete(guid: String){
        let realm = try! Realm()
        let obj = realm.objects(TimeClock.self).filter("Guid = %@", guid).first
        if (obj != nil){
            try! realm.write{
                realm.delete(obj!)
            }
        }
    }
    func GetAllByProjectGID(guid: String) -> [TimeClock]{
        let obj = try! Realm().objects(TimeClock.self).filter("ProjectGID = %@", guid).sorted(byKeyPath: "EndDate", ascending: false)
        if (obj != nil){
            return Array(obj)
        }else{
            return [TimeClock()]
        }
    }
}
