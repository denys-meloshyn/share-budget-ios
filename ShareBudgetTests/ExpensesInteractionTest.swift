//
//  ExpensesInteractionTest.swift
//  ShareBudgetTests
//
//  Created by Denys Meloshyn on 16.06.2018.
//  Copyright © 2018 Denys Meloshyn. All rights reserved.
//

import XCTest

import Nimble
import CoreData
import TimeIntervals
@testable import ShareBudget

class ExpensesInteractionTest: XCTestCase {
    var interaction: ExpensesInteraction!
    
    var router: ExpensesRouter!
    var presenter: ExpensesPresenter<ExpensesInteraction, ExpensesRouter>!

    var budget: Budget!
    var managedObjectContext: NSManagedObjectContext!

    override func setUp() {
        super.setUp()

        managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)

        budget = Budget(context: managedObjectContext)
        budget.name = "Test budget"

        router = ExpensesRouter(with: UIViewController())
        interaction = ExpensesInteraction(managedObjectContext: managedObjectContext,
                budgetID: budget.objectID,
                categoryID: nil,
                logger: MockLogger())
        presenter = ExpensesPresenter(with: interaction, router: router)
    }

    override func tearDown() {
        ModelManager.dropAllEntities()

        super.tearDown()
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
}
