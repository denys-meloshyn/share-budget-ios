//
//  ChangedModels.swift
//  ShareBudgetTests
//
//  Created by Denys Meloshyn on 06.08.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData
import Nimble
@testable import ShareBudget
import XCTest

class ChangedModelsTest: XCTestCase {
    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!

    override func setUp() {
        super.setUp()

        managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)
    }

    override func tearDown() {
        ModelManager.dropAllEntities()

        super.tearDown()
    }

    func testNoChanged() {
        _ = Expense(context: managedObjectContext)
        _ = Budget(context: managedObjectContext)

        ModelManager.saveContext(managedObjectContext)
        fetchedResultsController = ModelManager.changedModels(Expense.self, managedObjectContext)
        fetchedResultsController.performSilentFailureFetch()

        expect(self.fetchedResultsController.numberOfObjects()) == 0
    }

    func testOneChanged() {
        let expense = Expense(context: managedObjectContext)
        expense.isChanged = true

        _ = Budget(context: managedObjectContext)

        ModelManager.saveContext(managedObjectContext)
        fetchedResultsController = ModelManager.changedModels(Expense.self, managedObjectContext)
        fetchedResultsController.performSilentFailureFetch()

        expect(self.fetchedResultsController.numberOfObjects()) == 1
    }

    func testModelRemoved() {
        var expense = Expense(context: managedObjectContext)
        expense.isChanged = true
        expense.isRemoved = true

        expense = Expense(context: managedObjectContext)
        expense.isChanged = true

        expense = Expense(context: managedObjectContext)

        ModelManager.saveContext(managedObjectContext)
        fetchedResultsController = ModelManager.changedModels(Expense.self, managedObjectContext)
        fetchedResultsController.performSilentFailureFetch()

        expect(self.fetchedResultsController.numberOfObjects()) == 2
    }
}
