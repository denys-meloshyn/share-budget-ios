//
//  ExpensesInteractionTest.swift
//  ShareBudgetTests
//
//  Created by Denys Meloshyn on 16.06.2018.
//  Copyright © 2018 Denys Meloshyn. All rights reserved.
//

import XCTest

import CoreData
import Nimble
@testable import ShareBudget
import TimeIntervals

class ExpensesInteractionTest: XCTestCase {
    private var interaction: ExpensesInteraction!

    private var budget: Budget!
    private var managedObjectContext: NSManagedObjectContext!

    override func setUp() {
        super.setUp()

        managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)

        budget = Budget(context: managedObjectContext)
        budget.name = "Test budget"

        interaction = try! ExpensesInteraction(managedObjectContext: managedObjectContext,
                                               budgetID: budget.objectID,
                                               categoryID: nil,
                                               logger: MockLogger())
    }

    override func tearDown() {
        ModelManager.dropAllEntities()

        super.tearDown()
    }

    func testNumberOfSectionNoExpenses() {
        expect(self.interaction.numberOfSections()) == 0
    }

    func testOneSectionWhenAllExpensesInSameMonth() {
        let expense = Expense(context: managedObjectContext)
        expense.name = "Test expense"
        expense.creationDate = NSDate()
        budget.addToExpenses(expense)

        ModelManager.saveContext(managedObjectContext)

        interaction.updateFilter(with: nil)
        expect(self.interaction.numberOfSections()) == 1
    }

    func testTwoSectionsWhenExpensesInDifferentMonths() {
        var expense = Expense(context: managedObjectContext)
        expense.name = "Test expense"
        expense.creationDate = NSDate()
        budget.addToExpenses(expense)

        expense = Expense(context: managedObjectContext)
        expense.name = "Test expense previous month"
        expense.creationDate = Date() - 60.days as NSDate
        budget.addToExpenses(expense)

        ModelManager.saveContext(managedObjectContext)

        interaction.updateFilter(with: nil)
        expect(self.interaction.numberOfSections()) == 2
    }

    func testRestOfMoneyForEachExpense() {
        var result = [[String: Double]]()
        var rowDict = [String: Double]()

        let budgetLimit = BudgetLimit(context: managedObjectContext)
        budgetLimit.date = NSDate()
        budgetLimit.limit = 1000
        budgetLimit.budget = budget

        let expense = Expense(context: managedObjectContext)
        expense.name = "Test expense"
        expense.price = 100
        expense.modelID = 1
        expense.creationDate = NSDate()
        budget.addToExpenses(expense)

        rowDict[expense.modelID!.stringValue] = 900.0

        result.append(rowDict)
        ModelManager.saveContext(managedObjectContext)

        expect(self.interaction.calculateBudgetRestForExpenses()) == result
    }

    func testCategoryNotExistOrReceivedWrongObject() {
        expect {
            try ExpensesInteraction(managedObjectContext: self.managedObjectContext,
                                    budgetID: self.budget.objectID,
                                    categoryID: self.budget.objectID,
                                    logger: MockLogger())
        }.to(throwError { (error: Error) in
            guard case let ShareBudgetError.runtime(value) = error else {
                fail("Wrong error type \(error)")
                return
            }

            expect(value) == "Wrong category object"
        })
    }

    func testBudgetNotExistOrReceivedWrongObject() {
        let expense = Expense(context: managedObjectContext)

        expect {
            try ExpensesInteraction(managedObjectContext: self.managedObjectContext,
                                    budgetID: expense.objectID,
                                    categoryID: nil,
                                    logger: MockLogger())
        }.to(throwError { (error: Error) in
            guard case let ShareBudgetError.runtime(value) = error else {
                fail("Wrong error type \(error)")
                return
            }

            expect(value) == "Wrong budget object"
        })
    }

    func testNumberOfRowsAllExpensesInSameMonth() {
        let expense = Expense(context: managedObjectContext)
        expense.name = "Test expense"
        expense.creationDate = NSDate()
        budget.addToExpenses(expense)

        ModelManager.saveContext(managedObjectContext)

        interaction.updateFilter(with: nil)
        expect(self.interaction.numberOfRows(inSection: 0)) == 1
    }

    func testNumberOfRowsExpensesInDifferentMonths() {
        var expense = Expense(context: managedObjectContext)
        expense.name = "Test expense"
        expense.creationDate = NSDate()
        budget.addToExpenses(expense)

        expense = Expense(context: managedObjectContext)
        expense.name = "Test expense"
        expense.creationDate = NSDate()
        budget.addToExpenses(expense)

        expense = Expense(context: managedObjectContext)
        expense.name = "Test expense previous month"
        expense.creationDate = Date() - 60.days as NSDate
        budget.addToExpenses(expense)

        ModelManager.saveContext(managedObjectContext)

        interaction.updateFilter(with: nil)
        expect(self.interaction.numberOfRows(inSection: 0)) == 2
        expect(self.interaction.numberOfRows(inSection: 1)) == 1
    }

    func testObjectAtIndexPath() {
        let expense = Expense(context: managedObjectContext)
        expense.name = "Test expense"
        expense.creationDate = NSDate()
        budget.addToExpenses(expense)

        ModelManager.saveContext(managedObjectContext)

        interaction.updateFilter(with: nil)
        expect(self.interaction.object(at: IndexPath(row: 0, section: 0))) == expense
    }

    func testDateForSection() {
        let date = NSDate()

        let expense = Expense(context: managedObjectContext)
        expense.name = "Test expense"
        expense.creationDate = date
        budget.addToExpenses(expense)

        ModelManager.saveContext(managedObjectContext)

        interaction.updateFilter(with: nil)
        expect(self.interaction.date(for: 0)) == date
    }

    func testTotalExpenseForSection() {
        var expense = Expense(context: managedObjectContext)
        expense.name = "Test expense"
        expense.price = 100
        expense.creationDate = NSDate()
        budget.addToExpenses(expense)

        expense = Expense(context: managedObjectContext)
        expense.name = "Test expense"
        expense.price = 50
        expense.creationDate = NSDate()
        budget.addToExpenses(expense)

        ModelManager.saveContext(managedObjectContext)

        interaction.updateFilter(with: nil)
        expect(self.interaction.totalExpense(for: 0)) == 150
    }
}
