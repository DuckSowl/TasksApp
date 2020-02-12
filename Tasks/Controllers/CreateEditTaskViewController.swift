//
//  CreateEditTaskViewController.swift
//  Tasks
//
//  Created by Anton Tolstov on 10.02.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import UIKit
import CoreData

class CreateEditTaskViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var statusSegmentedControl: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var commentTextView: UITextView!
    
    // MARK: - Properties
    
    var taskManager: TaskManager!
    var index: Int?
    
    private let commentTextViewPlaceholder = "Type a comment to your task here"
    
    // MARK: - IBActions
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard titleTextField.text != "" else {
            let alert = UIAlertController(title: nil, message: "Enter title for your task", preferredStyle: .alert)
            alert.addTextField()
            alert.addAction(UIAlertAction(title: "Save", style: .default) { [unowned self] action in
                guard let textField = alert.textFields?.first else {
                    return
                }
                self.titleTextField.text = textField.text
                self.save(sender)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alert, animated: false)
            return
        }
        
        addTask()
        navigationController?.popToViewController(navigationController!.viewControllers[0],
                                                  animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.becomeFirstResponder()
        
        if let index = index {
            populate(with: taskManager.getTask(at: index)!)
            prepareCommentTextView(withPlaceholder: false)
        } else {
            prepareCommentTextView(withPlaceholder: true)
        }
    }
    
    // MARK: - Private methods
    
    private func addTask() {
        var comment = commentTextView.text ?? ""
        if comment == commentTextViewPlaceholder {
            comment = ""
        }
        
        let newOrEditedTask =
            Task(title: titleTextField.text!,
                 date: datePicker.date,
                 status: TaskStatus(rawValue: Int16(statusSegmentedControl.selectedSegmentIndex))!,
                 comment: comment)
        
        if let index = self.index {
            taskManager.updateTask(at: index, with: newOrEditedTask)
        } else {
            taskManager.add(task: newOrEditedTask)
        }
    }
    
    private func prepareCommentTextView(withPlaceholder: Bool) {
        if withPlaceholder {
            commentTextView.textColor = .lightGray
            commentTextView.text = commentTextViewPlaceholder
        }
        
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.lightGray.cgColor
        commentTextView.layer.cornerRadius = 5
    }
    
    private func populate(with task: Task) {
        titleTextField.text = task.title
        datePicker.date = task.date
        
        statusSegmentedControl.selectedSegmentIndex = Int(task.status.rawValue)
        commentTextView.text = task.comment
    }
    
}

// MARK: - UITextViewDelegate

extension CreateEditTaskViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
           if textView.textColor == .lightGray {
               textView.textColor = .black
               textView.text = nil
           }
       }
       
       func textViewDidEndEditing(_ textView: UITextView) {
           if textView.text == "" {
               textView.textColor = .lightGray
               textView.text = commentTextViewPlaceholder
           }
       }
}
