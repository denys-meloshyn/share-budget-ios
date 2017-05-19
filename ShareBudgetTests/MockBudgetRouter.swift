//
//  MockBudgetRouter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 18.05.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

@testable import ShareBudget
import CoreData

class MockBudgetRouter: BudgetRouter {
    let calledMethodManager = CalledMethodManager()
    
    override func openDetailPage(for budgetID: NSManagedObjectID?) {
        calledMethodManager.add("openDetailPage")
    }
}
