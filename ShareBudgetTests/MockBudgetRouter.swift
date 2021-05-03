//
//  MockBudgetRouter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 18.05.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData
@testable import ShareBudget

class MockBudgetRouter: BudgetRouter {
    let calledMethodManager = CalledMethodManager()

    override func openDetailPage(for _: NSManagedObjectID?) {
        calledMethodManager.add("openDetailPage")
    }
}
