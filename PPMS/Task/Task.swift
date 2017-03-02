//
//  Task.swift
//  PPMS
//
//  Created by Jansen on 2/22/17.
//  Copyright © 2017 Jansen. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    
    dynamic var Guid: String = UUID().uuidString
    dynamic var EndDate = Date()
    dynamic var Description = ""
    dynamic var Completed = false
    dynamic var Priority = "Low"
    dynamic var ProjectGID = ""
    
    func GetAllByProjectGID(guid: String) -> [Task]{
        let obj = try! Realm().objects(Task.self).filter("ProjectGID = %@", guid).sorted(byKeyPath: "EndDate", ascending: false)
        if (obj != nil){
            return Array(obj)
        }else{
            return [Task()]
        }
    }
    
    func Delete(guid: String){
        let realm = try! Realm()
        let obj = realm.objects(Task.self).filter("Guid = %@", guid)
        try! realm.write {
            realm.delete(obj)
        }

    }
    
    func AddOrUpdate(toDoItem: ToDoItem){
        let realm = try! Realm()
        let obj = realm.objects(Task.self).filter("Guid = %@", toDoItem.guid).first
        if obj == nil {
            let newObj = Task()
            newObj.Completed = toDoItem.completed
            newObj.Description = toDoItem.text
            newObj.ProjectGID = toDoItem.projectGid
            try! realm.write{
                realm.add(newObj)
            }
            
            
        }else{
            try! realm.write {
                obj?.EndDate = Date()
                obj?.Completed = toDoItem.completed
                obj?.Description = toDoItem.text
            }
        }
        
    }
}
