//
// Created by Denys Meloshyn on 25/09/2019.
// Copyright (c) 2019 Denys Meloshyn. All rights reserved.
//

import Foundation

import CoreData

class BudgetLimitAPIUpdateTask: APIUpdateTask, APIUpdateTaskProtocol {
    let timeStampStorageManager = TimeStampStorageManager(key: .budgetLimit)

    var endpointURLBuilder: URL.Builder {
        restApiURLBuilder.appendPath("group").appendPath("limit")
    }

    func parseUpdates(items: [[String: Any?]], in managedObjectContext: NSManagedObjectContext) {
        for item in items {
            guard let budgetID = item[Budget.modelKeyID()] as? Int,
                  let limitID = item[BudgetLimit.modelKeyID()] as? Int else {
                continue
            }

            let budget = Budget.findOrCreate(modelID: budgetID, managedObjectContext: managedObjectContext)
            let limit = BudgetLimit.find(modelID: limitID, managedObjectContext: managedObjectContext)

            if limit == nil {
                let newLimit = BudgetLimit(context: managedObjectContext)
                newLimit.budget = budget
                budget.limits?.adding(newLimit)

                newLimit.update(with: item, in: managedObjectContext)
            } else {
                limit?.update(with: item, in: managedObjectContext)
            }
        }
    }
}
