//
//  BudgetLimitAPI.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 01.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData

class BudgetLimitAPI: BaseAPI {
    override class func modelKeyID() -> String {
        return kBudgetLimitID
    }
    
    override class func timestampStorageKey() -> String {
        return "budget_limit_timestamp"
    }
    
    override class func parseUpdates(items: [[String: AnyObject?]], in managedObjectContext: NSManagedObjectContext) {
        var limit: BudgetLimit?
        
        for item in items {
            guard let budgetID = item[BudgetAPI.modelKeyID()] as? Int else {
                continue
            }
            
            guard let budget = ModelManager.findEntity(Budget.self, by: budgetID, in: managedObjectContext) as? Budget else {
                continue
            }
            
            guard let limitID = item[BudgetLimitAPI.modelKeyID()] as? Int else {
                continue
            }
            
            limit = ModelManager.findEntity(BudgetLimit.self, by: limitID, in: managedObjectContext) as? BudgetLimit
            if limit == nil {
                let newLimit = BudgetLimit(context: managedObjectContext)
                
                newLimit.budget = budget
                budget.limits?.adding(newLimit)
                limit = newLimit
            }
            
            limit?.update(with: item, in: managedObjectContext)
        }
    }
    
    override class func allChangedModels(completionBlock: APIResultBlock?) -> [BaseAPITask] {
        let managedObjectContext = ModelManager.managedObjectContext
        let fetchedResultsController = ModelManager.changedModels(BudgetLimit.self, managedObjectContext)
        
        var tasks = [BaseAPITask]()
        
        let sections = fetchedResultsController?.sections ?? []
        for i in 0..<sections.count {
            let section = sections[i]
            for j in 0..<section.numberOfObjects {
                let indexPath = IndexPath(row: j, section: i)
                guard let model = fetchedResultsController?.object(at: indexPath) as? BudgetLimit else {
                    continue
                }
                
                let task = BaseAPITaskUpload(resource: "group/limit", entity: self, modelID: model.objectID, completionBlock: completionBlock)
                tasks.append(task)
            }
        }
        
        return tasks
    }
}
