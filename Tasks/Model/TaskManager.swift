//
//  TaskManager.swift
//  Tasks
//
//  Created by Anton Tolstov on 10.02.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import UIKit
import CoreData

protocol Managable {
    var count: Int { get }
    
    func getTask(at index: Int) -> Task?
    func add(task: Task)
    func removeTask(at index: Int)
    func updateTask(at index: Int, with task: Task)
}

class TaskManager {
    
    // MARK: - Private properties
    
    private var tasks = [TaskEntity]()
    private var filter: TaskStatus? {
        didSet {
            fetch()
        }
    }
    private let context: NSManagedObjectContext
    
    private subscript (at index: Int) -> TaskEntity? {
        guard (0 ..< count).contains(index) else {
            return nil
        }
        return tasks[index]
    }
    
    // MARK: - Initializers
    
    init (forExtention: Bool = false) {
        context = CoreDataStack.shared.persistentContainer.viewContext
        
        if !forExtention {
            fetch()
        }
    }
    
    // MARK: - Private methods
    
    private func getTask(from taskEntity: TaskEntity) -> Task {
        return Task(title: taskEntity.title!,
                    date: taskEntity.date!,
                    status: TaskStatus(rawValue: taskEntity.status)!,
                    comment: taskEntity.comment!)
    }
    
    private func fetch(nearest: Bool = false) {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TaskEntity.date, ascending: true)]
        
        if let filter = self.filter {
            request.predicate = NSPredicate(format: "status == \(filter.rawValue)")
        }
        
        tasks = (try? context.fetch(request)) ?? []
    }
    
    private func saveAndFetch() {
        try? context.save()
        fetch()
    }
}

// MARK: - Managable

extension TaskManager: Managable {
    var count: Int {
        return tasks.count
    }

    func getTask(at index: Int) -> Task? {
        guard let taskEntity = self[at: index] else {
            return nil
        }
        
        return getTask(from: taskEntity)
    }
    
    func add(task: Task) {
        let taskEntity = TaskEntity(context: context)
        taskEntity.id = UUID()
        taskEntity.title = task.title
        taskEntity.date = task.date
        taskEntity.status = task.status.rawValue
        taskEntity.comment = task.comment
        
        self.saveAndFetch()
    }
    
    func removeTask(at index: Int) {
        guard let taskEntity = self[at: index] else {
            return
        }
        
        context.delete(taskEntity)
        self.saveAndFetch()
    }
    
    func updateTask(at index: Int, with task: Task) {
        guard let taskEntity = self[at: index] else {
            return
        }
        
        context.delete(taskEntity)
        self.add(task: task)
        
        self.saveAndFetch()
    }
    
    func set(filter: TaskStatus?) {
        self.filter = filter
    }
}

// MARK: - NearestTask for today-extention

extension TaskManager {
    private func getNearestEntity() -> TaskEntity? {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TaskEntity.date, ascending: true)]
        request.predicate = NSPredicate(format: "(status == \(TaskStatus.new.rawValue)) OR (status == \(TaskStatus.inProgress.rawValue))")
        request.fetchLimit = 1
        
        return try? context.fetch(request).first
    }
    
    func getNearest() -> Task? {
        guard let nearestTaskEntity = getNearestEntity() else {
            return nil
        }
        
        return getTask(from: nearestTaskEntity)
    }
    
    func getNearestIndex() -> Int? {
        guard let nearestTaskEntity = getNearestEntity() else {
            return nil
        }
        
        return tasks.firstIndex(of: nearestTaskEntity)
    }
}
