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
}
