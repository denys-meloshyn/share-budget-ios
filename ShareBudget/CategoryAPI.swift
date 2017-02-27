//
//  CategoryAPI.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 08.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData
import XCGLogger

class CategoryAPI: BaseAPI {
    override class func modelKeyID() -> String {
        return kCategoryID
    }
    
    override class func timestampStorageKey() -> String {
        return "category_timestamp"
    }
    
    override class func parseUpdates(items: [[String: AnyObject?]], in managedObjectContext: NSManagedObjectContext) {
        var category: Category?
        
        for item in items {
            if let modelID = item[self.modelKeyID()] as? Int {
                category = ModelManager.findEntity(Category.self, by: modelID, in: managedObjectContext) as? Category
            }
            
            if category == nil {
                category = Category(context: managedObjectContext)
            }
            
            category?.update(with: item, in: managedObjectContext)
        }
    }
    
    class func allChangedModels(completionBlock: APIResultBlock?) -> [URLSessionTask] {
        let managedObjectContext = ModelManager.managedObjectContext
        let fetchedResultsController = ModelManager.changedModels(Category.self ,managedObjectContext)
        
        var tasks = [URLSessionTask]()
        
        let sections = fetchedResultsController?.sections ?? []
        for i in 0..<sections.count {
            let section = sections[i]
            for j in 0..<section.numberOfObjects {
                let indexPath = IndexPath(row: i, section: j)
                guard let model = fetchedResultsController?.object(at: indexPath) as? Category else {
                    continue
                }
                
                if let task = CategoryAPI.upload("category", managedObjectContext, model, completionBlock) {
                    tasks.append(task)
                }
            }
        }
        
        return tasks
    }
}
