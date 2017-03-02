//
//  ToDoItem.swift
//  PPMS
//
//  Created by Jansen on 2/22/17.
//  Copyright © 2017 Jansen. All rights reserved.
//

import Foundation

class ToDoItem: NSObject{
    // A text description of this item.
    var text: String
    var guid: String
    // A Boolean value that determines the completed state of this item.
    var completed: Bool
    var projectGid: String
    
    // Returns a ToDoItem initialized with the given text and default completed value.
//    init(text: String, guid: String, isCompleted: Bool) {
//        self.text = text
//        self.guid = guid
//        self.completed = isCompleted
//    }
    
    init(task: Task){
        self.text = task.Description
        self.guid = task.Guid
        self.completed = task.Completed
        self.projectGid = task.ProjectGID
    }

}
