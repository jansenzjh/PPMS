//
//  Customer.swift
//  PPMS
//
//  Created by Jansen on 2/20/17.
//  Copyright © 2017 Jansen. All rights reserved.
//

import Foundation
import RealmSwift

class Customer: Object {
    
    dynamic var Guid: String = UUID().uuidString
    dynamic var Company = ""
    dynamic var ContactName = ""
    dynamic var Address1 = ""
    dynamic var Address2 = ""
    dynamic var City = ""
    dynamic var State = ""
    dynamic var Zip = ""
    dynamic var Email = ""
    dynamic var Phone = ""
    dynamic var Fax = ""
    dynamic var Memo = ""
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    func GetAll() -> [Customer]{
        
        let realm = try! Realm()
        
            let list = realm.objects(Customer.self)
            let custs = Array(list)
            return custs
    }

    func GetAllName() -> [String]{
        let realm = try! Realm()
        let custs = realm.objects(Customer.self);
        var returnList = [String]()
        if custs.count > 0 {
            for i in 0..<custs.count{
                returnList.append((custs[i]).Company)
            }
        }
        return returnList
    }
    
    func GetByGUID(guid: String) -> Customer{
        let obj = try! Realm().objects(Customer.self).filter("Guid = %@", guid).first
        if (obj != nil){
            return (obj)!
        }else{
            return Customer()
        }
    }
    
    func GetByName(name: String) -> Customer{
        let obj = try! Realm().objects(Customer.self).filter("Company == %@", name).first
        if (obj != nil){
            return (obj)!
        }else{
            return Customer()
        }
    }

}
