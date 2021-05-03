//
//  ModelManagerTest.swift
//  ShareBudgetTests
//
//  Created by Denys Meloshyn on 01.08.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData
import Nimble
@testable import ShareBudget
import XCTest

class ExpenseFetchControllerTest: XCTestCase {
    var budget: Budget!
    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<Expense>!

    override func setUp() {
        super.setUp()

        managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)
        fetchedResultsController = nil
        budget = Budget(context: managedObjectContext)
        budget.name = "Test budget"
    }

    override func tearDown() {
        ModelManager.dropAllEntities()

        super.tearDown()
    }

    private func createExpense() -> Expense {
        let expense = Expense(context: managedObjectContext)
        expense.budget = budget
        expense.isRemoved = NSNumber(value: false)
        budget.addToExpenses(expense)

        let category = Category(context: managedObjectContext)
        category.name = "Test category"
        category.budget = budget
        category.addToExpenses(expense)
        expense.category = category
        budget.addToCategories(category)

        return expense
    }

    private func createFetchedResultsController(startDate: Date = UtilityFormatter.firstMonthDay(),
                                                finishDate: Date = UtilityFormatter.lastMonthDay())
    {
        fetchedResultsController = ModelManager.expenseFetchController(for: budget.objectID,
                                                                       startDate: startDate as NSDate,
                                                                       finishDate: finishDate as NSDate,
                                                                       managedObjectContext: managedObjectContext)
    }

    // MARK: - Tests

    func testNoExpenses() {
        createFetchedResultsController()
        fetchedResultsController.performSilentFailureFetch()

        expect(self.fetchedResultsController.numberOfObjects()) == 0
    }

    func testOneExpense() {
        var expense = createExpense()
        expense.name = "Expense 1"
        expense.creationDate = NSDate()

        expense = createExpense()
        expense.name = "Expense 2"
        expense.isRemoved = NSNumber(value: true)
        expense.creationDate = NSDate()

        ModelManager.saveContext(managedObjectContext)

        createFetchedResultsController()
        fetchedResultsController.performSilentFailureFetch()

        expect(self.fetchedResultsController.numberOfObjects()) == 1
    }

    func testExpsensesCreatedInTheLastDay() {
        var dateComponents = UtilityFormatter.calendarComponentTilDay()
        dateComponents.year = 2017
        dateComponents.month = 8
        dateComponents.day = 31
        dateComponents.hour = 19
        dateComponents.minute = 11

        let startDate = UtilityFormatter.firstMonthDay(date: dateComponents.date!)
        let finishDate = UtilityFormatter.lastMonthDay(date: dateComponents.date!)

        var expense = createExpense()
        expense.name = "Expense 1"
        expense.creationDate = dateComponents.date! as NSDate

        dateComponents.hour = 23
        dateComponents.minute = 59
        expense = createExpense()
        expense.name = "Expense 2"
        expense.creationDate = dateComponents.date! as NSDate

        ModelManager.saveContext(managedObjectContext)
        createFetchedResultsController(startDate: startDate, finishDate: finishDate)
        fetchedResultsController.performSilentFailureFetch()

        expect(self.fetchedResultsController.numberOfObjects()) == 2
    }

    func testExpsensesCreatedInTheFirstDay() {
        var dateComponents = UtilityFormatter.calendarComponentTilDay()
        dateComponents.year = 2017
        dateComponents.month = 8
        dateComponents.day = 1
        dateComponents.hour = 19
        dateComponents.minute = 11

        let startDate = UtilityFormatter.firstMonthDay(date: dateComponents.date!)
        let finishDate = UtilityFormatter.lastMonthDay(date: dateComponents.date!)

        var expense = createExpense()
        expense.name = "Expense 1"
        expense.creationDate = dateComponents.date! as NSDate

        dateComponents.hour = 0
        dateComponents.minute = 0
        expense = createExpense()
        expense.name = "Expense 2"
        expense.creationDate = dateComponents.date! as NSDate

        ModelManager.saveContext(managedObjectContext)
        createFetchedResultsController(startDate: startDate, finishDate: finishDate)
        fetchedResultsController.performSilentFailureFetch()

        expect(self.fetchedResultsController.numberOfObjects()) == 2
    }

    func testAllExpensesInTheSameMonth() {
        var dateComponents = UtilityFormatter.calendarComponentTilDay()
        dateComponents.year = 2017
        dateComponents.month = 1
        dateComponents.day = 15

        let startDate = UtilityFormatter.firstMonthDay(date: dateComponents.date!)
        let finishDate = UtilityFormatter.lastMonthDay(date: dateComponents.date!)

        dateComponents.day = 1
        var expense = createExpense()
        expense.name = "Expense 1"
        expense.creationDate = dateComponents.date! as NSDate

        dateComponents.day = 2
        expense = createExpense()
        expense.name = "Expense 2"
        expense.creationDate = dateComponents.date! as NSDate

        dateComponents.day = 31
        expense = createExpense()
        expense.name = "Expense 3"
        expense.creationDate = dateComponents.date! as NSDate

        ModelManager.saveContext(managedObjectContext)
        createFetchedResultsController(startDate: startDate, finishDate: finishDate)
        fetchedResultsController.performSilentFailureFetch()

        expect(self.fetchedResultsController.numberOfObjects()) == 3
    }

    func testNoExpensesInCurrentMonth() {
        var dateComponents = UtilityFormatter.calendarComponentTilDay()
        dateComponents.year = 2017
        dateComponents.month = 2
        dateComponents.day = 15

        let startDate = UtilityFormatter.firstMonthDay(date: dateComponents.date!)
        let finishDate = UtilityFormatter.lastMonthDay(date: dateComponents.date!)

        dateComponents.month = 1
        dateComponents.day = 1
        var expense = createExpense()
        expense.name = "Expense 1"
        expense.creationDate = dateComponents.date! as NSDate

        dateComponents.day = 2
        expense = createExpense()
        expense.name = "Expense 2"
        expense.creationDate = dateComponents.date! as NSDate

        dateComponents.day = 31
        expense = createExpense()
        expense.name = "Expense 3"
        expense.creationDate = dateComponents.date! as NSDate

        dateComponents.month = 3
        dateComponents.day = 1
        expense = createExpense()
        expense.name = "Expense 4"
        expense.creationDate = dateComponents.date! as NSDate

        ModelManager.saveContext(managedObjectContext)
        createFetchedResultsController(startDate: startDate, finishDate: finishDate)
        fetchedResultsController.performSilentFailureFetch()

        expect(self.fetchedResultsController.numberOfObjects()) == 0
    }
}
