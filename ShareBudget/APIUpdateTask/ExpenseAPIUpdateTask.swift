//
//  ExpenseAPIUpdateTask.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 26/12/2019.
//  Copyright © 2019 Denys Meloshyn. All rights reserved.
//

import CoreData

class ExpenseAPIUpdateTask: APIUpdateTask, APIUpdateTaskProtocol {
    let timeStampStorageManager = TimeStampStorageManager(key: .expense)

    var endpointURLBuilder: URL.Builder {
        restApiURLBuilder.appendPath("expense")
    }

    func parseUpdates(items: [[String: Any?]], in managedObjectContext: NSManagedObjectContext) {
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
}
