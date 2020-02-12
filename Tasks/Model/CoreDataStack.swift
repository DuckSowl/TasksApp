//
//  CoreDataStack.swift
//  Tasks
//
//  Created by Anton Tolstov on 10.02.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = SharedPersistentContainer(name: "Tasks")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() { }

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

class SharedPersistentContainer: NSPersistentContainer {
    override open class func defaultDirectoryURL() -> URL {
        var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.shared")
        storeURL = storeURL?.appendingPathComponent("Tasks")
        return storeURL!
    }
}
