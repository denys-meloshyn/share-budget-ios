//
//  ModelManager.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 14.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData
import XCGLogger

class ModelManager {
    static let sharedInstance = ModelManager()
    
    private init() {
        
    }
    
    // MARK: - Core Data stack
    
    private static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ShareBudget")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    class func saveContext (_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    class func saveChildren(_ childrenManagedObjectContext: NSManagedObjectContext) {
        guard let parentManagedObjectContext = childrenManagedObjectContext.parent else {
            XCGLogger.error("Parent managed object context is missed")
            return
        }
        
        childrenManagedObjectContext.perform { () -> Void in
            ModelManager.saveContext(childrenManagedObjectContext)
            
            parentManagedObjectContext.perform({() -> Void in
                ModelManager.saveContext(parentManagedObjectContext)
            })
        }
    }
    
    // MARK: - Public methods
    
    class var managedObjectContext:NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    class func childrenManagedObjectContext(from parentContext: NSManagedObjectContext?) -> NSManagedObjectContext {
        let childrenManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        childrenManagedObjectContext.parent = parentContext
        
        return childrenManagedObjectContext
    }
    
    class func findEntity(fetchRequest: NSFetchRequest<NSFetchRequestResult>, in managedObjectContext: NSManagedObjectContext) -> BaseModel? {
        return nil
    }
    
    class func findEntity(_ entity: BaseModel.Type, by modelID: Int, in managedObjectContext: NSManagedObjectContext) -> BaseModel? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = entity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "modelID==%i", modelID)
        fetchRequest.fetchLimit = 1
        
        do {
            let items = try managedObjectContext.fetch(fetchRequest)
            return items.first as? BaseModel
        }
        catch {
            XCGLogger.error("Finding model \(error)")
            return nil
        }
    }
    
    class func findEntity(_ entity: BaseModel.Type, internal internalID: Int, in managedObjectContext: NSManagedObjectContext) -> BaseModel? {
        let fetchRequest: NSFetchRequest<BaseModel> = entity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "internalID==%i", internalID)
        fetchRequest.fetchLimit = 1
        
        do {
            let items = try managedObjectContext.fetch(fetchRequest)
            return items.first
        }
        catch {
            XCGLogger.error("Finding model with internal ID \(error)")
            return nil
        }
    }
    
    class func changedModels(_ entity: BaseModel.Type, _ managedObjectContext: NSManagedObjectContext) -> NSFetchedResultsController<NSFetchRequestResult>? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = entity.fetchRequest()
        fetchRequest.fetchBatchSize = 30
        
        fetchRequest.predicate = NSPredicate(format: "isChanged == YES")
        
        let sortDescriptor = NSSortDescriptor(key: "modelID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            return fetchedResultsController
        }
        catch {
            XCGLogger.error("Error fetch changedModels \(error)")
            return nil
        }
    }
    
    class func budgetFetchController(_ managedObjectContext: NSManagedObjectContext, search text: String = "") -> NSFetchedResultsController<Budget> {
        let fetchRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
        fetchRequest.fetchBatchSize = 30
        
        if text.characters.count > 0 {
            let predicate = NSPredicate(format: "name CONTAINS[c] %@", text)
            fetchRequest.predicate = predicate
        }
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }
    
    class func budgetLimitFetchController(_ managedObjectContext: NSManagedObjectContext, for budgetID: NSManagedObjectID) -> NSFetchedResultsController<BudgetLimit> {
        let fetchRequest: NSFetchRequest<BudgetLimit> = BudgetLimit.fetchRequest()
        fetchRequest.fetchBatchSize = 30
        
        let budget = managedObjectContext.object(with: budgetID)
        let predicate = NSPredicate(format: "%@ == budget", budget)
        fetchRequest.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }
    
    class func categoryFetchController(_ managedObjectContext: NSManagedObjectContext) -> NSFetchedResultsController<Category> {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.fetchBatchSize = 30
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }
    
    class func expenseFetchController(_ managedObjectContext: NSManagedObjectContext, for budgetID: NSManagedObjectID) -> NSFetchedResultsController<Expense> {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        fetchRequest.fetchBatchSize = 30
        
        let budget = managedObjectContext.object(with: budgetID)
        let predicate = NSPredicate(format: "%@ == budget AND isRemoved == NO", budget)
        fetchRequest.predicate = predicate
        
        let sortDescriptorDate = NSSortDescriptor(key: "creationDate", ascending: false)
        let sortDescriptorName = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptorDate, sortDescriptorName]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: "sectionCreationDate", cacheName: nil)
        
        return fetchedResultsController
    }
    
    class func expenseFetchController(for budgetID: NSManagedObjectID, _ date: NSDate, _ managedObjectContext: NSManagedObjectContext) -> NSFetchedResultsController<Expense> {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        fetchRequest.fetchBatchSize = 30
        
        let budget = managedObjectContext.object(with: budgetID)
        
        var predicates = [NSPredicate]()
        var tmpPredicate = NSPredicate(format: "%@ == budget", budget)
        predicates.append(tmpPredicate)
        
        tmpPredicate = NSPredicate(format: "isRemoved == NO")
        predicates.append(tmpPredicate)

        tmpPredicate = NSPredicate(format: "creationDate >= %@", date)
        predicates.append(tmpPredicate)
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: "category", cacheName: nil)
        
        return fetchedResultsController
    }
}
