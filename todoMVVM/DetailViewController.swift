//
//  DetailViewController.swift
//  todoMVVM
//
//  Created by Matteo Comisso on 20/01/16.
//  Copyright © 2016 mcomisso. All rights reserved.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController {
    
    var todoNotes: UITextView?
    var todoTitle: UITextField?
    var doneAndDeleteButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.todoTitle = UITextField(frame: CGRectZero)
        self.todoNotes = UITextView(frame: CGRectZero)
        self.doneAndDeleteButton = UIButton(frame: CGRectZero)
        
        // Add action to edit current content
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editContentOfTodo")
    }
    
    func editContentOfTodo() {
        self.todoNotes?.editable = true
        self.todoNotes?.selectable = true
        self.todoTitle?.enabled = true
        
        // Make a button appear
        
        
    }
    
    func toggleDoneDeleteButton () {
        
    }
}