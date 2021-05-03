//
//  EditExpenseInteraction.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 05.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData

class EditExpenseInteraction: BaseInteraction, BaseInteractionProtocol {
    var budget: Budget
    var expense: Expense
    let managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)

    private var expenseID: NSManagedObjectID?

    init(with budgetID: NSManagedObjectID, expenseID: NSManagedObjectID?) {
        self.expenseID = expenseID
        budget = managedObjectContext.object(with: budgetID) as! Budget

        if let expenseID = expenseID {
            expense = managedObjectContext.object(with: expenseID) as! Expense
        } else {
            expense = Expense(context: managedObjectContext)
            expense.creationDate = UtilityFormatter.roundToTwoSeconds(date: Date()) as NSDate?
            expense.budget = budget
            budget.addToExpenses(expense)
        }
    }

    var isExpenseNew: Bool {
        if expenseID == nil {
            return true
        }

        return false
    }

    func save() {
        expense.isChanged = true
        ModelManager.saveChildren(managedObjectContext, block: nil)
    }

    func updateCategory(_ categoryID: NSManagedObjectID) {
        expense.category = managedObjectContext.object(with: categoryID) as? Category
        expense.category?.addToExpenses(expense)
    }
}
