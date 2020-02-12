//
//  TasksViewController.swift
//  Tasks
//
//  Created by Anton Tolstov on 10.02.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import UIKit
import CoreData

class TasksViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tasksTableView: UITableView!
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    
    // MARK: - Private fields
    
    private var taskManager = TaskManager()
    private let defaults = UserDefaults(suiteName: "group.shared")
    
    // MARK: - IBActions
    
    @IBAction func filter(_ sender: UISegmentedControl) {
        let taskStatusRawValue = sender.selectedSegmentIndex - 1
        let filter = TaskStatus(rawValue: Int16(taskStatusRawValue))
        taskManager.set(filter: filter)
        
        tasksTableView.reloadData()
    }
    
    // MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        tasksTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTask"  {
            guard let destination = segue.destination as? CreateEditTaskViewController else {
                print("CreateEditTaskViewController not found")
                return
            }
            destination.taskManager = self.taskManager
        }
        
        if segue.identifier == "ShowDetail"  {
            guard let destination = segue.destination as? DetailViewController else {
                print("TaskDetailViewController not found")
                return
            }
            destination.taskManager = self.taskManager
            destination.index = tasksTableView.indexPathForSelectedRow!.row
        }
    }
}

// MARK: - UITableViewDataSource

extension TasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskManager.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskCell
        cell.populate(task: taskManager.getTask(at: indexPath.row)!)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        taskManager.removeTask(at: indexPath.row)
        tableView.reloadData()
    }
}

// MARK: - NearestTask for today-extention

extension TasksViewController {
    func showNearestTask() {
        filterSegmentedControl.selectedSegmentIndex = 0
        filter(filterSegmentedControl)
    
        guard let nearestIndex = taskManager.getNearestIndex() else {
            return
        }
        
        self.tasksTableView.selectRow(at: IndexPath(row: nearestIndex, section: 0), animated: true, scrollPosition: .none)
        performSegue(withIdentifier: "ShowDetail", sender: self)
    }
}
