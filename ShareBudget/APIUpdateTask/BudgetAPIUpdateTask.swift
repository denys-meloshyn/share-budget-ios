//
// Created by Denys Meloshyn on 23/09/2019.
// Copyright (c) 2019 Denys Meloshyn. All rights reserved.
//

import Foundation

import CoreData

class BudgetAPIUpdateTask: APIUpdateTask, APIUpdateTaskProtocol {
    let timeStampStorageManager = TimeStampStorageManager(key: .budget)

    var endpointURLBuilder: URL.Builder {
        restApiURLBuilder.appendPath("group")
    }

    func parseUpdates(items: [[String: Any?]], in managedObjectContext: NSManagedObjectContext) {
        var budget: Budget?

        for item in items {
            if let internalID = item[Constants.key.json.internalID] as? Int {
                budget = ModelManager.findEntity(Budget.self, internal: internalID, in: managedObjectContext) as? Budget
            } else if let modelID = item[Budget.modelKeyID()] as? Int {
                budget = ModelManager.findEntity(Budget.self, by: modelID, in: managedObjectContext) as? Budget
            }

            if budget == nil {
                budget = Budget(context: managedObjectContext)
            }

            budget?.update(with: item, in: managedObjectContext)
        }
    }
}
