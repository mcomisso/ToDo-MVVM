//
//  Model.swift
//  todoMVVM
//
//  Created by Matteo Comisso on 19/01/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import Foundation

class ToDo: NSObject {
    var content: String
    var completed: Bool
    var notes: String?
    
    init(withContent content: String) {
        self.content = content
        self.completed = false
    }
}