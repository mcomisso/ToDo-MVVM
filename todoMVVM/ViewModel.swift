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
    var todoDataSource: Array<ToDo>
    var todoCompleted: Array<ToDo>
    
    let demo1 = ToDo(withContent: "First Todo")
    let demo2 = ToDo(withContent: "Second Todo")
    
    override init() {
        self.todoDataSource = []
        self.todoCompleted = []
    }
    
    /**
     Set a bunch of demo data
     */
    func completeWithDemoData() {
        self.appendToDataSource(self.demo1)
        self.appendToDataSource(self.demo2)
    }
    
    /**
     Create new todos
     
     - parameter content: The content string of newly created Todo
     */
    func createNewTodo(content: String) {
        let newTodo = ToDo(withContent: content)
        self.appendToDataSource(newTodo)
    }
    
    /**
     Handle current completion status of todos
     
     - parameter todo: The item to handle
     */
    func addCompletedTodo(todo: ToDo) {
        todo.completed = true
        self.appedToCompleted(todo)
    }
    
    /**
     Removes the Todo item from the completed array
     
     - parameter todo: The item to remove
     */
    func removeCompletedTodo(todo: ToDo) {
        self.removeFromCompleted(todo)
    }
    
    /**
     Removes all completed Todos
     */
    func clearCompletedTodo() {
        for todo in self.todoCompleted {
            guard let index = self.todoDataSource.indexOf(todo) else {
                continue
            }
            self.todoDataSource.removeAtIndex(index)
        }
        
        self.todoCompleted.removeAll()
    }
    
    func isCompleted(todo: ToDo) -> Bool {
        return self.todoCompleted.contains(todo)
    }
    
    func handleTodoAtIndexPath(indexPath: NSIndexPath) {
        let todo = self.todoDataSource[indexPath.row]
        todo.completed ? self.removeCompletedTodo(todo) : self.addCompletedTodo(todo)
    }
    
    // Deletion
    func deleteTodoItem(todo: ToDo) {
        self.removeFromDataSource(todo)
        self.removeFromCompleted(todo)
    }
}

extension ToDoViewModel {
    
    private func appedToCompleted(todo: ToDo) {
        self.todoCompleted.append(todo)
    }
    
    private func appendToDataSource(todo: ToDo) {
        self.todoDataSource.append(todo)
    }
    
    private func removeFromDataSource(todo: ToDo) {
        guard let index = self.todoDataSource.indexOf(todo) else {
            return
        }
        self.todoDataSource.removeAtIndex(index)
    }
    
    private func removeFromCompleted(todo: ToDo) {
        defer { todo.completed = false }
        guard let index = self.todoCompleted.indexOf(todo) else {
            return
        }
        self.todoCompleted.removeAtIndex(index)
    }
}