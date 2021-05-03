//
//  BudgetDetailInteractionTest.swift
//  ShareBudgetTests
//
//  Created by Denys Meloshyn on 09.08.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData
import Nimble
@testable import ShareBudget
import XCTest

class BudgetDetailInteractionTest: XCTestCase {
    var budget: Budget!
    var managedObjectContext: NSManagedObjectContext!
    var budgetDetailInteraction: BudgetDetailInteraction!

    override func setUp() {
        super.setUp()

        managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)
        budget = Budget(context: managedObjectContext)
        budgetDetailInteraction = BudgetDetailInteraction(with: budget.objectID, managedObjectContext: managedObjectContext)
    }

    override func tearDown() {
        ModelManager.dropAllEntities()

        super.tearDown()
    }

    private func createExpense() -> Expense {
        let expense = Expense(context: managedObjectContext)
        expense.budget = budget
        expense.isRemoved = false
        expense.creationDate = NSDate()
        budget.addToExpenses(expense)

        return expense
    }

    // MARK: - Tests

    func testInit() {
        expect(self.budgetDetailInteraction.budgetID).notTo(beNil())
        expect(self.budgetDetailInteraction.budget) == budget
    }

    func testNoExpenses() {
        expect(self.budgetDetailInteraction.isEmpty()).to(beTrue())
        expect(self.budgetDetailInteraction.numberOfCategoryExpenses()) == 0
    }

    func testExpensesExist() {
        _ = createExpense()
        ModelManager.saveContext(managedObjectContext)

        expect(self.budgetDetailInteraction.isEmpty()) == false
    }

    func testAllExpensesRemoved() {
        var expense = createExpense()
        expense.name = "Expense 1"
        expense.isRemoved = NSNumber(value: true)
        expense.price = NSNumber(value: 100)

        expense = createExpense()
        expense.name = "Expense 2"
        expense.isRemoved = NSNumber(value: true)
        expense.price = NSNumber(value: 95.5)
        ModelManager.saveContext(managedObjectContext)

        expect(self.budgetDetailInteraction.isEmpty()).to(beTrue())
        expect(self.budgetDetailInteraction.totalExpenses()) == 0.0
        expect(self.budgetDetailInteraction.numberOfCategoryExpenses()) == 0
    }

    func testTotalSum() {
        var expense = createExpense()
        expense.name = "Expense 1"
        expense.price = NSNumber(value: 100)

        expense = createExpense()
        expense.name = "Expense 2"
        expense.price = NSNumber(value: 95.5)

        expense = createExpense()
        expense.name = "Expense 3"
        expense.price = NSNumber(value: 0.5)

        expense = createExpense()
        expense.name = "Expense 4"
        expense.price = NSNumber(value: 36.4)

        ModelManager.saveContext(managedObjectContext)
        expect(self.budgetDetailInteraction.totalExpenses()) == 232.4
    }

    func testTotalSumRemovedExpensesExist() {
        var expense = createExpense()
        expense.name = "Expense 1"
        expense.price = NSNumber(value: 100)

        expense = createExpense()
        expense.name = "Expense 2"
        expense.isRemoved = NSNumber(value: true)
        expense.price = NSNumber(value: 95.5)

        expense = createExpense()
        expense.name = "Expense 3"
        expense.price = NSNumber(value: 0.5)

        expense = createExpense()
        expense.name = "Expense 4"
        expense.price = NSNumber(value: 36.4)

        ModelManager.saveContext(managedObjectContext)
        expect(self.budgetDetailInteraction.totalExpenses()) == 136.9
    }

    func testNumberOfCategoryExpenses() {
        var category = Category(context: managedObjectContext)
        category.name = "Category 1"

        var expense = createExpense()
        expense.name = "Expense 1"
        expense.price = NSNumber(value: 100)
        expense.category = category
        category.addToExpenses(expense)

        expense = createExpense()
        expense.name = "Expense 2"
        expense.price = NSNumber(value: 95.5)
        expense.category = category
        category.addToExpenses(expense)

        category = Category(context: managedObjectContext)
        category.name = "Category 2"

        expense = createExpense()
        expense.name = "Expense 3"
        expense.price = NSNumber(value: 95.5)
        expense.category = category
        category.addToExpenses(expense)

        ModelManager.saveContext(managedObjectContext)
        expect(self.budgetDetailInteraction.numberOfCategoryExpenses()) == 2
    }

    func testBudgetLimitNotExist() {
        expect(self.budgetDetailInteraction.lastMonthLimit()).to(beNil())
    }

    func testBudgetLimitOneExist() {
        let limit = BudgetLimit(context: managedObjectContext)
        limit.date = NSDate()
        limit.limit = NSNumber(value: 100.0)
        budget.addToLimits(limit)
        ModelManager.saveContext(managedObjectContext)

        let result = budgetDetailInteraction.lastMonthLimit()
        expect(result?.limit) == 100.0
    }

    func testBudgetLimitMultipleExist() {
        var limit = BudgetLimit(context: managedObjectContext)
        limit.date = NSDate()
        limit.limit = NSNumber(value: 100.0)
        budget.addToLimits(limit)

        limit = BudgetLimit(context: managedObjectContext)
        limit.date = NSDate()
        limit.limit = NSNumber(value: 200.0)
        budget.addToLimits(limit)
        ModelManager.saveContext(managedObjectContext)

        let result = budgetDetailInteraction.lastMonthLimit()
        expect(result?.limit) == 200.0
    }
}
