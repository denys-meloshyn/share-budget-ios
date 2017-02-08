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
    
    class func upload(_ managedObjectContext: NSManagedObjectContext, _ budget: Budget, _ completion: APIResultBlock?) -> URLSessionTask? {
        return nil
    }
}
