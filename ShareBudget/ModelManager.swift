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
    
    static private var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.denys.meloshyn.TeamExpenses" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    static private var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "ShareBudget", withExtension: "momd")!
        
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    static private var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: ModelManager.managedObjectModel)
        let url = ModelManager.applicationDocumentsDirectory.appendingPathComponent(ModelManager.dataBaseName())
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: Any]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            XCGLogger.error("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
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
    
    class func saveChildren(_ childrenManagedObjectContext: NSManagedObjectContext, block: (() -> Swift.Void)?) {
        guard let parentManagedObjectContext = childrenManagedObjectContext.parent else {
            XCGLogger.error("Parent managed object context is missed")
            return
        }
        
        childrenManagedObjectContext.perform { () -> Void in
            ModelManager.saveContext(childrenManagedObjectContext)
            
            parentManagedObjectContext.perform({() -> Void in
                ModelManager.saveContext(parentManagedObjectContext)
                
                block?()
            })
        }
    }
    
    private class func dataBaseName() -> String {
        if let testPath = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"]  {
            let url = URL(fileURLWithPath: testPath)
            
            if url.pathExtension == "xctestconfiguration" {
                return "ShareBudgetTest"
            }
        }
        
        return "ShareBudget"
    }
    
    private class func dropEntity(_ entity: BaseModel.Type) {
        let fetchRequest: NSFetchRequest<BaseModel> = entity.fetchRequest()
        fetchRequest.includesPropertyValues = false
        
        let sortDescriptor = NSSortDescriptor(key: "modelID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let managedObjectContext = ModelManager.managedObjectContext
        let fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchController.performFetch()
        }
        catch {
            XCGLogger.error("Error drop entity \(entity) \(error)")
        }
        
        let sections = fetchController.sections ?? []
        for sectionIndex in 0..<sections.count {
            let section = sections[sectionIndex]
            for rowIndex in 0..<section.numberOfObjects {
                let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                let model = fetchController.object(at: indexPath)
                managedObjectContext.delete(model)
            }
        }
        
        ModelManager.saveContext(managedObjectContext)
    }
    
    static var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = ModelManager.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Public methods
    
    class func dropAllEntities() {
        ModelManager.dropEntity(BaseModel.self)
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
    
    class func expenseFetchController(_ managedObjectContext: NSManagedObjectContext, for budgetID: NSManagedObjectID, categoryID: NSManagedObjectID? = nil) -> NSFetchedResultsController<Expense> {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        fetchRequest.fetchBatchSize = 30
        
        let budget = managedObjectContext.object(with: budgetID)
        let predicate: NSPredicate
        
        if let categoryID = categoryID {
            let category = managedObjectContext.object(with: categoryID)
            predicate = NSPredicate(format: "%@ == budget AND isRemoved == NO AND category == %@", budget, category)
        } else {
            predicate = NSPredicate(format: "%@ == budget AND isRemoved == NO", budget)
        }
        
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
        
        let categoryNameSortDescriptor = NSSortDescriptor(key: "category.name", ascending: true)
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [categoryNameSortDescriptor, sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: "category.name", cacheName: nil)
        
        return fetchedResultsController
    }
}
