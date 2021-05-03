//
//  FindOrCreateEntity.swift
//  ShareBudgetTests
//
//  Created by Denys Meloshyn on 04.08.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData
import Nimble
@testable import ShareBudget
import XCTest

class FindOrCreateEntityTest: XCTestCase {
    var managedObjectContext: NSManagedObjectContext!

    override func setUp() {
        super.setUp()

        managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)
    }

    override func tearDown() {
        ModelManager.dropAllEntities()

        super.tearDown()
    }

    func testEntityNotExistDataBaseEmptyResponseEmpty() {
        let result = ModelManager.findOrCreateEntity(Expense.self, response: [:], in: managedObjectContext)

        expect(result).notTo(beNil())
        expect(result.modelID).to(beNil())
    }

    func testEntityNotExistDataBaseEmpty() {
        let result = ModelManager.findOrCreateEntity(Expense.self,
                                                     response: [Expense.modelKeyID(): 1],
                                                     in: managedObjectContext)

        expect(result).notTo(beNil())
        expect(result.modelID).to(beNil())
    }

    func testEntityNotExistResponseEmpty() {
        let expense = Expense(context: managedObjectContext)
        expense.modelID = NSNumber(value: 1)
        ModelManager.saveContext(managedObjectContext)

        let result = ModelManager.findOrCreateEntity(Expense.self, response: [:], in: managedObjectContext)

        expect(result).notTo(beNil())
        expect(result.modelID).to(beNil())
    }

    func testEntityNotExist() {
        let expense = Expense(context: managedObjectContext)
        expense.modelID = NSNumber(value: 1)
        ModelManager.saveContext(managedObjectContext)

        let result = ModelManager.findOrCreateEntity(Expense.self,
                                                     response: [Expense.modelKeyID(): 2],
                                                     in: managedObjectContext)

        expect(result).notTo(beNil())
        expect(result.modelID).to(beNil())
    }

    func testAnotherEntityWithTheSameIDExist() {
        let budget = Budget(context: managedObjectContext)
        budget.modelID = NSNumber(value: 1)
        ModelManager.saveContext(managedObjectContext)

        let result = ModelManager.findOrCreateEntity(Expense.self,
                                                     response: [Expense.modelKeyID(): 1],
                                                     in: managedObjectContext)

        expect(result).notTo(beNil())
        expect(result.modelID).to(beNil())
    }

    func testEntityExist() {
        let expense = Expense(context: managedObjectContext)
        expense.modelID = NSNumber(value: 1)
        ModelManager.saveContext(managedObjectContext)

        let result = ModelManager.findOrCreateEntity(Expense.self,
                                                     response: [Expense.modelKeyID(): 1],
                                                     in: managedObjectContext)

        expect(result.modelID).notTo(beNil())
    }
}
