//
//  ExpenseAPI.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData

class ExpenseAPI: BaseAPI {
    override class func modelKeyID() -> String {
        return kExpenseID
    }
    
    override class func timestampStorageKey() -> String {
        return "expense_timestamp"
    }
    
    override class func parseUpdates(items: [[String: AnyObject?]], in managedObjectContext: NSManagedObjectContext) {
        var expense: Expense?
        
        for item in items {
            if let modelID = item[self.modelKeyID()] as? Int {
                expense = ModelManager.findEntity(Expense.self, by: modelID, in: managedObjectContext) as? Expense
            }
            
            if expense == nil {
                expense = Expense(context: managedObjectContext)
            }
            
            expense?.update(with: item, in: managedObjectContext)
        }
    }
    
    override class func allChangedModels(completionBlock: APIResultBlock?) -> [BaseAPITask] {
        let managedObjectContext = ModelManager.managedObjectContext
        let fetchedResultsController = ModelManager.changedModels(Expense.self, managedObjectContext)
        
        var tasks = [BaseAPITask]()
        
        let sections = fetchedResultsController?.sections ?? []
        for i in 0..<sections.count {
            let section = sections[i]
            for j in 0..<section.numberOfObjects {
                let indexPath = IndexPath(row: i, section: j)
                guard let model = fetchedResultsController?.object(at: indexPath) as? Expense else {
                    continue
                }
                
                let task = BaseAPITaskUpload(resource: "expense", entity: ExpenseAPI.self, modelID: model.objectID, completionBlock: completionBlock)
                tasks.append(task)
            }
        }
        
        return tasks
    }
}
