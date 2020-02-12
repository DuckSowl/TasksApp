//
//  TodayViewController.swift
//  NearestTask
//
//  Created by Anton Tolstov on 10.02.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding, TaskRepresentable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var taskRepresentationView: UIView!
    @IBOutlet weak var noTasksLabel: UILabel!
    
    private let model = TaskManager(forExtention: true)
    
    override func viewDidLoad() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.openTasksApp))
        self.view.addGestureRecognizer(tapGesture)
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        guard let nearestTask = model.getNearest() else {
            presentView(withTask: false)
            return
        }
        
        presentView(withTask: true)
        populate(task: nearestTask)
        completionHandler(.newData)
    }
    
    private func presentView(withTask: Bool) {
        taskRepresentationView.isHidden = !withTask
        noTasksLabel.isHidden = withTask
    }
    
    @objc func openTasksApp() {
        let tasksAppUrl = URL(string: "task-detail:")!
        extensionContext?.open(tasksAppUrl, completionHandler: { (success) in
            if (!success) {
                print("error: failed to open app from Today Extension")
            }
        })
    }
}
