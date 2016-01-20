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
    
    let viewModel = ToDoViewModel()
    var tableView: UITableView?
    let cellIdentifier = "cellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Todo List"
        
        // Let's add some UI
        self.tableView = UITableView(frame: self.view.bounds)
        self.configureViewComponents()
    }
    
    func addToDo() {
        let alertController = UIAlertController(title: "Add", message: "Add your todo", preferredStyle: .Alert)
        
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


    func configureViewComponents() {
        guard let unwrappedTableView = self.tableView else {
            return
        }
        
        self.view.addSubview(unwrappedTableView)
        
        unwrappedTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        unwrappedTableView.dataSource = self
        unwrappedTableView.delegate = self
        self.viewModel.completeWithDemoData()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addToDo")
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
        self.viewModel.handleToDoAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
}


//
//  UITableViewDataSource discussion
//
//  There are two main ideas: UITableViewDataSource can be read primarly as "DataSource" or "UITableView".
//  Since tableView:cellForRowAtIndexPath: returns a UITableViewCell, the delegate should be the view itself.
//  General rule: /^UI[a-z]*$/ should be treated as view components.
//
extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.toDoDataSource.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath)
        
        let todo = self.viewModel.toDoDataSource[indexPath.row] as ToDo
        cell.textLabel?.text = todo.content
        cell.accessoryType = self.viewModel.isCompleted(todo) ? .Checkmark : .None
        cell.textLabel?.textColor = self.viewModel.isCompleted(todo) ? UIColor(white: 0, alpha: 0.4) : UIColor.blackColor()
        
        return cell
    }
}