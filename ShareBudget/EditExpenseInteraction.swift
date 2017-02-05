//
//  EditExpenseInteraction.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 05.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData

class EditExpenseInteraction: BaseInteraction {
    let managedObjectContext = ModelManager.managedObjectContext
    var expense: Expense?
    
    private var expenseID: NSManagedObjectID?
    
    override init() {
        super.init()
        
        if let expenseID = self.expenseID {
            self.expense = self.managedObjectContext.object(with: expenseID) as? Expense
        }
        else {
            self.expense = Expense(context: self.managedObjectContext)
        }
    }
}
