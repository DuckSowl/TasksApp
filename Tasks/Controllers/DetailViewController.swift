//
//  DetailViewController.swift
//  Tasks
//
//  Created by Anton Tolstov on 10.02.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, TaskRepresentable {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    // MARK: - Properties
    
    var taskManager: TaskManager!
    var index: Int!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populate(task: taskManager.getTask(at: index)!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditTask"  {
            guard let destination = segue.destination as? CreateEditTaskViewController else {
                print("Can not find CreateEditTaskViewController destination")
                return
            }
            
            destination.taskManager = self.taskManager
            destination.index = index
        }
    }
}
