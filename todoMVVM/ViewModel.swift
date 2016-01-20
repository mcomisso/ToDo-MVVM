//
//  ViewModel.swift
//  todoMVVM
//
//  Created by Matteo Comisso on 19/01/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import Foundation
import UIKit

class ToDoViewModel: NSObject {
    var toDoDataSource: Array<ToDo>
    var toDoCompleted: Array<ToDo>

    let demo1 = ToDo(withContent: "Primo todo")
    let demo2 = ToDo(withContent: "Secondo")
    
    override init() {
        self.toDoDataSource = []
        self.toDoCompleted = []
    }

    // Demo data
    func completeWithDemoData() {
        self.toDoDataSource.append(self.demo1)
        self.toDoDataSource.append(self.demo2)
    }

    // Create new todos
    func createNewTodo(content: String) {
        let newTodo = ToDo(withContent: content)
        self.toDoDataSource.append(newTodo)
    }

    // Handle current completion status of todos
    func addCompletedTodo(todo: ToDo) {
        todo.completed = true
        self.toDoCompleted.append(todo)
    }

    func removeCompletedTodo(todo: ToDo) {
        todo.completed = false
        self.toDoCompleted.removeAtIndex(self.toDoCompleted.indexOf(todo)!)
    }

    func clearCompletedTodo() {
        for todo in self.toDoCompleted {
            todo.completed = false
        }

        self.toDoCompleted.removeAll()
    }

    func isCompleted(todo: ToDo) -> Bool {
        return self.toDoCompleted.contains(todo)
    }

    func handleToDoAtIndexPath(indexPath: NSIndexPath) {
        let todo = self.toDoDataSource[indexPath.row]
        todo.completed ? self.removeCompletedTodo(todo) : self.addCompletedTodo(todo)
    }
}