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
        self.budget = self.managedObjectContext.object(with: budgetID) as! Budget
        
        if let expenseID = expenseID {
            self.expense = self.managedObjectContext.object(with: expenseID) as! Expense
        } else {
            self.expense = Expense(context: self.managedObjectContext)
            self.expense.creationDate = UtilityFormatter.roundToTwoSeconds(date: Date()) as NSDate?
            self.expense.budget = self.budget
            self.budget.addToExpenses(self.expense)
        }
    }
    
    var isExpenseNew: Bool {
        if self.expenseID == nil {
            return true
        }
        
        return false
    }
    
    func save() {
        self.expense.isChanged = true
        ModelManager.saveChildren(self.managedObjectContext, block: nil)
    }
    
    func updateCategory(_ categoryID: NSManagedObjectID) {
        self.expense.category = self.managedObjectContext.object(with: categoryID) as? Category
        self.expense.category?.addToExpenses(self.expense)
    }
}
