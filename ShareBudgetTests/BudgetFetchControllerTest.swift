//
//  BudgetLimitFetchController.swift
//  ShareBudgetTests
//
//  Created by Denys Meloshyn on 08.08.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData
import Nimble
@testable import ShareBudget
import XCTest

class BudgetFetchControllerTest: XCTestCase {
    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<Budget>!

    override func setUp() {
        super.setUp()

        managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)
        fetchedResultsController = nil
    }

    override func tearDown() {
        ModelManager.dropAllEntities()

        super.tearDown()
    }

    func testNoBudgets() {
        _ = Expense(context: managedObjectContext)
        _ = Category(context: managedObjectContext)

        fetchedResultsController = ModelManager.budgetFetchController(managedObjectContext)
        fetchedResultsController.performSilentFailureFetch()
        expect(self.fetchedResultsController.numberOfObjects()) == 0
    }

    func testBudgetsExist() {
        _ = Budget(context: managedObjectContext)
        _ = Budget(context: managedObjectContext)

        fetchedResultsController = ModelManager.budgetFetchController(managedObjectContext)
        fetchedResultsController.performSilentFailureFetch()
        expect(self.fetchedResultsController.numberOfObjects()) == 2
    }

    func testExistedBudgetsWithRemoved() {
        let budget = Budget(context: managedObjectContext)
        budget.isRemoved = NSNumber(value: true)
        _ = Budget(context: managedObjectContext)

        fetchedResultsController = ModelManager.budgetFetchController(managedObjectContext)
        fetchedResultsController.performSilentFailureFetch()

        expect(self.fetchedResultsController.numberOfObjects()) == 1
    }

    func testFilterWithEmptyString() {
        var budget = Budget(context: managedObjectContext)
        budget.name = "test"
        budget = Budget(context: managedObjectContext)
        budget.name = "test"

        fetchedResultsController = ModelManager.budgetFetchController(managedObjectContext, search: "")
        fetchedResultsController.performSilentFailureFetch()

        expect(self.fetchedResultsController.numberOfObjects()) == 2
    }

    func testFilter() {
        var budget = Budget(context: managedObjectContext)
        budget.name = "test"
        budget = Budget(context: managedObjectContext)
        budget.name = "test"
        budget = Budget(context: managedObjectContext)
        budget.name = "budget"

        fetchedResultsController = ModelManager.budgetFetchController(managedObjectContext, search: "test")
        fetchedResultsController.performSilentFailureFetch()

        expect(self.fetchedResultsController.numberOfObjects()) == 2
    }

    func testFilterItemRemoved() {
        var budget = Budget(context: managedObjectContext)
        budget.name = "test"
        budget.isRemoved = NSNumber(value: true)
        budget = Budget(context: managedObjectContext)
        budget.name = "test"
        budget = Budget(context: managedObjectContext)
        budget.name = "budget"

        fetchedResultsController = ModelManager.budgetFetchController(managedObjectContext, search: "test")
        fetchedResultsController.performSilentFailureFetch()

        expect(self.fetchedResultsController.numberOfObjects()) == 1
    }

    func testFilterContainsText() {
        var budget = Budget(context: managedObjectContext)
        budget.name = "test"
        budget = Budget(context: managedObjectContext)
        budget.name = "test"
        budget = Budget(context: managedObjectContext)
        budget.name = "budget_test_budget"

        fetchedResultsController = ModelManager.budgetFetchController(managedObjectContext, search: "test")
        fetchedResultsController.performSilentFailureFetch()

        expect(self.fetchedResultsController.numberOfObjects()) == 3
    }

    func testFilterCaseSensitive() {
        var budget = Budget(context: managedObjectContext)
        budget.name = "test"
        budget = Budget(context: managedObjectContext)
        budget.name = "tEsT"
        budget = Budget(context: managedObjectContext)
        budget.name = "TEST"

        fetchedResultsController = ModelManager.budgetFetchController(managedObjectContext, search: "Test")
        fetchedResultsController.performSilentFailureFetch()

        expect(self.fetchedResultsController.numberOfObjects()) == 3
    }
}
