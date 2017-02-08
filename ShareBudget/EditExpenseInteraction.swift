//
//  EditExpenseInteraction.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 05.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData

class EditExpenseInteraction: BaseInteraction {
    let managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)
    var budget: Budget
    var expense: Expense
    
    private var expenseID: NSManagedObjectID?
    
    init(with budgetID: NSManagedObjectID) {
        self.budget = self.managedObjectContext.object(with: budgetID) as! Budget
        self.expense = Expense(context: self.managedObjectContext)
        
        self.expense.budget = self.budget
        self.budget.addToExpenses(self.expense)
    }
    
    /*
    override init() {
        if let expenseID = self.expenseID {
            self.expense = self.managedObjectContext.object(with: expenseID) as! Expense
        }
        else {
            self.expense = Expense(context: self.managedObjectContext)
        }
        
        super.init()
    }
 */
}
