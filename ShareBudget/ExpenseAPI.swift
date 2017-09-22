//
//  ExpenseAPI.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData

class ExpenseAPI: BaseAPI {
    override func timestampStorageKey() -> String {
        return "expense_timestamp"
    }
    
    override func parseUpdates(items: [[String: Any?]], in managedObjectContext: NSManagedObjectContext) {
        var expense: Expense?
        
        for item in items {
            if let modelID = item[Expense.modelKeyID()] as? Int {
                expense = ModelManager.findEntity(Expense.self, by: modelID, in: managedObjectContext) as? Expense
            }
            
            if expense == nil {
                expense = Expense(context: managedObjectContext)
            }
            
            expense?.update(with: item, in: managedObjectContext)
        }
    }
    
    override func allChangedModels(completionBlock: APIResultBlock?) -> [BaseAPITask] {
        let managedObjectContext = ModelManager.managedObjectContext
        let fetchedResultsController = ModelManager.changedModels(Expense.self, managedObjectContext)
        
        var tasks = [BaseAPITask]()
        
        fetchedResultsController?.iterate(block: {indexPath in
            guard let model = fetchedResultsController?.object(at: indexPath) as? Expense else {
                return
            }
            
            let task = BaseAPITaskUpload(resource: "expense", entity: self, modelID: model.objectID, completionBlock: completionBlock)
            tasks.append(task)
        })
        
        return tasks
    }
}
