//
//  BudgetDetailInteraction.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 03.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData

class BudgetDetailInteraction: BaseInteraction {
    var budgetID: NSManagedObjectID?
    
    init(with budgetID: NSManagedObjectID?) {
        self.budgetID = budgetID
    }
}
