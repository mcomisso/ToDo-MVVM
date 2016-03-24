//
//  ViewController.swift
//  todoMVVM
//
//  Created by Matteo Comisso on 19/01/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//
//  DISCUSSION
//  MVVM should treat ViewControllers as "Views".
// 
//

import UIKit

class ViewController: UIViewController {
    
    // ViewModel Connection
    let viewModel = ToDoViewModel()
    
    // Interface and essentials
    var tableView: UITableView?
    var statusLabel: UILabel?
    let cellIdentifier = "cellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Let's add some UI
        self.tableView = UITableView(frame: self.view.bounds)
        self.statusLabel = UILabel(frame: self.view.bounds)
        self.configureViewComponents()

        self.title = "Todo List"
    }

    override func updateViewConstraints() {

        

        super.updateViewConstraints()
    }
    
    func configureViewComponents() {
        guard let unwrappedTableView = self.tableView else { return }
        guard let unwrappedStatusLabel = self.statusLabel else { return }
        
        unwrappedStatusLabel.text = "No more todos 🎉"
        unwrappedStatusLabel.textAlignment = .Center
        
        unwrappedTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        unwrappedTableView.dataSource = self
        unwrappedTableView.delegate = self
        //        self.viewModel.completeWithDemoData()
        
        self.view.addSubview(unwrappedStatusLabel)
        self.view.addSubview(unwrappedTableView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ViewController.addOrEditTodo(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: #selector(ViewController.clearCompleted))

        unwrappedTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//
// UITableViewDelegate Extension
extension ViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.viewModel.handleTodoAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}


//
//  UITableViewDataSource discussion
//
//  There are two main ideas: UITableViewDataSource can be read primarily as "DataSource" or "UITableView".
//  Since tableView:cellForRowAtIndexPath: returns a UITableViewCell, the delegate should be the view itself.
//  General rule: /^UI[a-z]*$/ should be treated as "view" components.
//
extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.viewModel.todoDataSource.isEmpty) {
            tableView.hidden = true
        } else {
            tableView.hidden = false
        }
        return self.viewModel.countAvailableTodos()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let quickEditAction = UITableViewRowAction(style: .Normal, title: "Edit") { (tableViewRowAction: UITableViewRowAction, indexPath: NSIndexPath) -> Void in
            //            let todoItem = self.viewModel.todoDataSource[indexPath.row]
        }
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { (tableViewRowAction:UITableViewRowAction, indexPath: NSIndexPath) -> Void in
            //            let todoItem = self.viewModel.todoDataSource[indexPath.row]
            //            self.viewModel.deleteTodoItem(todoItem)
        }
        
        // The order is inverted from right to left
        return [deleteAction, quickEditAction]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath)
        let todo = self.viewModel.todoAtIndex(indexPath.row)
        guard let unwrappedTodo = todo else { return cell }

        cell.textLabel?.text = unwrappedTodo.content
        cell.accessoryType = self.viewModel.isCompleted(unwrappedTodo) ? .Checkmark : .None
        cell.textLabel?.textColor = self.viewModel.isCompleted(unwrappedTodo) ? UIColor(white: 0, alpha: 0.4) : UIColor.blackColor()
        
        return cell
    }
}

// MARK: - Add and clear completed todos
extension ViewController {
    func clearCompleted() {
        self.viewModel.clearCompletedTodo()
        self.tableView?.reloadData()
    }
    
    func addOrEditTodo(todo: ToDo?) {
        var alertController: UIAlertController
        
        alertController = UIAlertController(title: "Add", message: "Add your todo", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
            textField.placeholder = "What do you need to do?"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (alertAction:UIAlertAction) -> Void in
            let todoContent = alertController.textFields?.first?.text
            if (todoContent?.isEmpty == false) {
                self.viewModel.createNewTodo(todoContent!)
                self.tableView?.reloadData()
            }
        }
        alertController.addAction(cancel)
        alertController.addAction(ok)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}