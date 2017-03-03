//
//  Bill.swift
//  PPMS
//
//  Created by Jansen on 2/28/17.
//  Copyright © 2017 Jansen. All rights reserved.
//

import Foundation
import RealmSwift

class Bill: Object {
    
    dynamic var Guid: String = UUID().uuidString
    dynamic var CreateDate = Date()
    dynamic var TransactionDate = Date()
    dynamic var CustomerGID = ""
    dynamic var ProjectGID = ""
    dynamic var Amount = 0.0
    dynamic var TransactionType = ""
    dynamic var IsCompleted = false
    dynamic var Notes = ""
    
    func Insert(billObj: Bill){
        
        let realm = try! Realm()
        
        try! realm.write {
            let theDtl = Bill()
            theDtl.Guid = (billObj.Guid)
            theDtl.CreateDate = (billObj.CreateDate)
            theDtl.TransactionDate = (billObj.TransactionDate)
            theDtl.Notes = (billObj.Notes)
            theDtl.Amount = (billObj.Amount)
            theDtl.IsCompleted = (billObj.IsCompleted)
            theDtl.ProjectGID = (billObj.ProjectGID)
            theDtl.CustomerGID = (billObj.CustomerGID)
            theDtl.TransactionType = (billObj.TransactionType)
            realm.add(billObj)
        }
    }
    
    func Delete(guid: String){
        let realm = try! Realm()
        let obj = realm.objects(Bill.self).filter("Guid = %@", guid).first
        if (obj != nil){
            try! realm.write{
                realm.delete(obj!)
            }
        }
    }
    
    func Count() -> Int{
        let realm = try! Realm()
        
        return realm.objects(Bill.self).count
    }
    
    func TotalEarn() -> Double{
        let realm = try! Realm()
        
        return realm.objects(Bill.self).sum(ofProperty: "Amount")
    }
}
