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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.todoTitle = UITextField(frame: CGRectZero)
        self.todoNotes = UITextView(frame: CGRectZero)
        
    }
}