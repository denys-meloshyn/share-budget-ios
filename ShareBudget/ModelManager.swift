//
//  ModelManager.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 14.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

class ModelManager {
    static let sharedInstance = ModelManager()
    
    private static let fetchBatchSize = 30
    
    private init() {
        
    }
    
    // MARK: - Core Data stack
    
    static private let storeURL = ModelManager.applicationDocumentsDirectory.appendingPathComponent(Dependency.coreDataName)
    
    static private var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.denys.meloshyn.TeamExpenses" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }()
    
    static private var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "ShareBudget", withExtension: "momd")!
        var managedObjectModel: NSManagedObjectModel? = NSManagedObjectModel(contentsOf: modelURL)
        
        return managedObjectModel!
    }()
    
    static private var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: ModelManager.managedObjectModel)
        let url = ModelManager.applicationDocumentsDirectory.appendingPathComponent(Dependency.coreDataName)
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: Any]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            Dependency.logger.warning("Remove old persistentStoreCoordinator")
            
            do {
                try FileManager.default.removeItem(atPath: ModelManager.storeURL.path)
                try FileManager.default.removeItem(atPath: ModelManager.storeURL.path.appending("-shm"))
                try FileManager.default.removeItem(atPath: ModelManager.storeURL.path.appending("-wal"))
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
                Dependency.userCredentials.resetTimeStamps()
            } catch let removeError {
                Dependency.logger.error("\(removeError)")
                abort()
            }
        }
        
        return coordinator
    }()
    
    // MARK: - Core Data Saving support
    
    class func saveContext(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                Dependency.logger.error("Unresolved error \(nserror)", userInfo: ["error": nserror.userInfo])
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    class func saveChildren(_ childrenManagedObjectContext: NSManagedObjectContext, block: (() -> Swift.Void)?) {
        guard let parentManagedObjectContext = childrenManagedObjectContext.parent else {
            Dependency.logger.error("Parent managed object context is missed")
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
    
    private class func dropEntity(_ entity: BaseModel.Type) {
        let fetchRequest: NSFetchRequest<BaseModel> = entity.fetchRequest()
        fetchRequest.includesPropertyValues = false
        
        let sortDescriptor = NSSortDescriptor(key: "modelID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let managedObjectContext = ModelManager.managedObjectContext
        let fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchController.performFetch()
        } catch {
            Dependency.logger.error("Error drop entity \(entity) \(error)")
        }
        
        fetchController.iterate { (indexPath) -> Void in
            let model = fetchController.object(at: indexPath)
            managedObjectContext.delete(model)
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
    
    class func childrenManagedObjectContext(from parentContext: NSManagedObjectContext) -> NSManagedObjectContext {
        let childrenManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        childrenManagedObjectContext.parent = parentContext
        
        return childrenManagedObjectContext
    }
    
    class func findOrCreateEntity(_ entity: BaseModel.Type, response: [String: Any?], in managedObjectContext: NSManagedObjectContext) -> BaseModel {
        guard let modelID = response[entity.modelKeyID()] as? Int, let model = ModelManager.findEntity(entity, by: modelID, in: managedObjectContext) else {
            return entity.init(context: managedObjectContext)
        }
        
        return model
    }
    
    class func findEntity(_ entity: BaseModel.Type, by modelID: Int, in managedObjectContext: NSManagedObjectContext) -> BaseModel? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = entity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "modelID == %i", modelID)
        fetchRequest.fetchLimit = 1
        
        do {
            let items = try managedObjectContext.fetch(fetchRequest)
            return items.first as? BaseModel
        } catch {
            Dependency.logger.error("Finding model \(error)")
            return nil
        }
    }
    
    class func findEntity(_ entity: BaseModel.Type, internal internalID: Int, in managedObjectContext: NSManagedObjectContext) -> BaseModel? {
        let fetchRequest: NSFetchRequest<BaseModel> = entity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "internalID == %i", internalID)
        fetchRequest.fetchLimit = 1
        
        do {
            let items = try managedObjectContext.fetch(fetchRequest)
            return items.first
        } catch {
            Dependency.logger.error("Finding model with internal ID \(error)")
            return nil
        }
    }
    
    class func removePredicate() -> NSPredicate {
        return NSPredicate(format: "isRemoved == nil OR isRemoved == NO")
    }
    
    class func lastLimit(for budgetID: NSManagedObjectID, date: NSDate = NSDate(), _ managedObjectContext: NSManagedObjectContext) -> BudgetLimit? {
        let fetchRequest: NSFetchRequest<BudgetLimit> = BudgetLimit.fetchRequest()
        fetchRequest.fetchBatchSize = 1
        
        let budget = managedObjectContext.object(with: budgetID)
        
        var predicates = [NSPredicate]()
        var predicate = NSPredicate(format: "%@ == budget", budget)
        predicates.append(predicate)
        
        predicates.append(ModelManager.removePredicate())
        
        predicate = NSPredicate(format: "date <= %@", date)
        predicates.append(predicate)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var items = [BudgetLimit]()
        do {
            items = try managedObjectContext.fetch(fetchRequest)
        } catch {
            Dependency.logger.error("Error fetch budget limit \(error)")
        }
        
        return items.last
    }
    
    // MARK: - NSFetchedResultsController
    
    class func changedModels(_ entity: BaseModel.Type, _ managedObjectContext: NSManagedObjectContext) -> NSFetchedResultsController<NSFetchRequestResult>? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = entity.fetchRequest()
        fetchRequest.fetchBatchSize = ModelManager.fetchBatchSize
        
        fetchRequest.predicate = NSPredicate(format: "isChanged == YES")
        
        let sortDescriptor = NSSortDescriptor(key: "modelID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            return fetchedResultsController
        } catch {
            Dependency.logger.error("Error fetch changedModels \(error)")
            return nil
        }
    }
    
    class func changedTasks(modelEntity entity: BaseModel.Type, apiEntity entityAPI: BaseAPI, resource: String, managedObjectContext: NSManagedObjectContext, completionBlock: APIResultBlock?) -> [BaseAPITask] {
        let fetchedResultsController = ModelManager.changedModels(entity, managedObjectContext)
        
        var tasks = [BaseAPITask]()
        fetchedResultsController?.iterate(block: { indexPath in
            guard let model = fetchedResultsController?.object(at: indexPath) as? BaseModel else {
                return
            }
            
            let task = BaseAPITaskUpload(resource: resource, entity: entityAPI, modelID: model.objectID, completionBlock: completionBlock)
            tasks.append(task)
        })
        
        return tasks
    }
    
    class func budgetFetchController(_ managedObjectContext: NSManagedObjectContext, search text: String = "") -> NSFetchedResultsController<Budget> {
        let fetchRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
        fetchRequest.fetchBatchSize = ModelManager.fetchBatchSize
        
        var predicates = [NSPredicate]()
        if text.characters.count > 0 {
            let predicate = NSPredicate(format: "name CONTAINS[c] %@", text)
            predicates.append(predicate)
        }
        predicates.append(ModelManager.removePredicate())
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }
    
    class func budgetLimitFetchController(_ managedObjectContext: NSManagedObjectContext, for budgetID: NSManagedObjectID) -> NSFetchedResultsController<BudgetLimit> {
        let fetchRequest: NSFetchRequest<BudgetLimit> = BudgetLimit.fetchRequest()
        fetchRequest.fetchBatchSize = ModelManager.fetchBatchSize
        
        let budget = managedObjectContext.object(with: budgetID)
        
        var predicates = [NSPredicate]()
        let predicate = NSPredicate(format: "%@ == budget", budget)
        predicates.append(predicate)
        predicates.append(ModelManager.removePredicate())
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }
    
    class func categoryFetchController(_ managedObjectContext: NSManagedObjectContext) -> NSFetchedResultsController<Category> {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.fetchBatchSize = ModelManager.fetchBatchSize
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }
    
    class func expenseFetchController(_ managedObjectContext: NSManagedObjectContext, for budgetID: NSManagedObjectID, categoryID: NSManagedObjectID? = nil) -> NSFetchedResultsController<Expense> {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        fetchRequest.fetchBatchSize = ModelManager.fetchBatchSize
        
        let budget = managedObjectContext.object(with: budgetID)
        
        var predicates = [NSPredicate]()
        var tmpPredicate = ModelManager.removePredicate()
        predicates.append(tmpPredicate)
        
        tmpPredicate = NSPredicate(format: "%@ == budget", budget)
        predicates.append(tmpPredicate)
        
        if let categoryID = categoryID {
            let category = managedObjectContext.object(with: categoryID)
            tmpPredicate = NSPredicate(format: "category == %@", category)
            predicates.append(tmpPredicate)
        }
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        let sortDescriptorDate = NSSortDescriptor(key: "creationDate", ascending: false)
        let sortDescriptorName = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptorDate, sortDescriptorName]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: "sectionCreationDate", cacheName: nil)
        
        return fetchedResultsController
    }
    
    class func expenseFetchController(for budgetID: NSManagedObjectID, startDate: NSDate, finishDate: NSDate, managedObjectContext: NSManagedObjectContext) -> NSFetchedResultsController<Expense> {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        fetchRequest.fetchBatchSize = ModelManager.fetchBatchSize
        
        let budget = managedObjectContext.object(with: budgetID)
        
        var predicates = [NSPredicate]()
        var tmpPredicate = NSPredicate(format: "%@ == budget", budget)
        predicates.append(tmpPredicate)
        
        predicates.append(ModelManager.removePredicate())

        tmpPredicate = NSPredicate(format: "(creationDate >= %@) AND (creationDate <= %@)", startDate, finishDate)
        predicates.append(tmpPredicate)
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = predicate
        
        let categoryNameSortDescriptor = NSSortDescriptor(key: "category.name", ascending: true)
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [categoryNameSortDescriptor, sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: "category.name", cacheName: nil)
        
        return fetchedResultsController
    }
    
    class func teamMembersFetchController(_ managedObjectContext: NSManagedObjectContext, for budgetID: NSManagedObjectID) -> NSFetchedResultsController<UserGroup> {
        let fetchRequest: NSFetchRequest<UserGroup> = UserGroup.fetchRequest()
        fetchRequest.fetchBatchSize = ModelManager.fetchBatchSize
        
        let budget = managedObjectContext.object(with: budgetID)
        var predicates = [NSPredicate]()
        let tmpPredicate = NSPredicate(format: "%@ == group", budget)
        predicates.append(tmpPredicate)
        
        predicates.append(ModelManager.removePredicate())
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = predicate
        
        let sortDescriptorID = NSSortDescriptor(key: "modelID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptorID]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }
}
