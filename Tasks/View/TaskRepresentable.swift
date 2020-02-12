//
//  TaskRepresentable.swift
//  Tasks
//
//  Created by Anton Tolstov on 10.02.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import UIKit

protocol TaskRepresentable {
    var titleLabel: UILabel! { get }
    var dateLabel: UILabel! { get }
    var statusLabel: UILabel! { get }
    var commentLabel: UILabel! { get }
        
    func populate(task: Task)
}

extension TaskRepresentable {
    func populate(task: Task) {
        titleLabel.text = task.title
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateLabel.text = formatter.string(for: task.date)
    
        let today = Calendar.current.startOfDay(for: Date())
        dateLabel.textColor = task.status == .completed ? .black :
                              task.date < today ? .red : .black
        
        statusLabel.text = task.status.description        
        commentLabel.text = task.comment
    }
}

extension TaskStatus: CustomStringConvertible {
    var description: String {
        switch self {
        case .new:
            return "New"
        case .inProgress:
            return "In Progress"
        case .completed:
            return "Completed"
        }
    }
}

