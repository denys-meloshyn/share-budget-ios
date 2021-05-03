//
//  CategoryAPIUpdateTask.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 26/12/2019.
//  Copyright © 2019 Denys Meloshyn. All rights reserved.
//

import CoreData

class CategoryAPIUpdateTask: APIUpdateTask, APIUpdateTaskProtocol {
    let timeStampStorageManager = TimeStampStorageManager(key: .category)

    var endpointURLBuilder: URL.Builder {
        restApiURLBuilder.appendPath("category")
    }

    func parseUpdates(items: [[String: Any?]], in managedObjectContext: NSManagedObjectContext) {
        var category: Category?

        for item in items {
            if let modelID = item[Category.modelKeyID()] as? Int {
                category = ModelManager.findEntity(Category.self, by: modelID, in: managedObjectContext) as? Category
            }

            if category == nil {
                category = Category(context: managedObjectContext)
            }

            category?.update(with: item, in: managedObjectContext)
        }
    }
}
