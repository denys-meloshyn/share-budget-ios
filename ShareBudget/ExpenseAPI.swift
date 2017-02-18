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
    
    class func allChangedModels(completionBlock: APIResultBlock?) -> [URLSessionTask] {
        let managedObjectContext = ModelManager.managedObjectContext
        let items = ModelManager.changedModels(Expense.self, managedObjectContext)
        
        var tasks = [URLSessionTask]()
        
        for model in items {
            if let task = ExpenseAPI.upload("expense", managedObjectContext, model, completionBlock) {
                tasks.append(task)
            }
        }
        
        return tasks
    }
}
