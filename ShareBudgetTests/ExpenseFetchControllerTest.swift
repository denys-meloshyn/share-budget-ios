//
//  ModelManagerTest.swift
//  ShareBudgetTests
//
//  Created by Denys Meloshyn on 01.08.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import XCTest
import Nimble
import CoreData
@testable import ShareBudget

class ExpenseFetchControllerTest: XCTestCase {
    var budget: Budget!
    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<Expense>!
    
    override func setUp() {
        super.setUp()
        
        self.managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)
        self.fetchedResultsController = nil
        self.budget = Budget(context: self.managedObjectContext)
        self.budget.name = "Test budget"
    }
    
    override func tearDown() {
        ModelManager.dropAllEntities()
        
        super.tearDown()
    }
    
    private func createExpense() -> Expense {
        let expense = Expense(context: self.managedObjectContext)
        expense.budget = self.budget
        expense.isRemoved = NSNumber(value: false)
        self.budget.addToExpenses(expense)
        
        let category = Category(context: self.managedObjectContext)
        category.name = "Test category"
        category.budget = self.budget
        category.addToExpenses(expense)
        expense.category = category
        self.budget.addToCategories(category)
        
        return expense
    }
    
    private func createFetchedResultsController(startDate: Date = UtilityFormatter.firstMonthDay(),
                                                finishDate: Date = UtilityFormatter.lastMonthDay()) {
        self.fetchedResultsController = ModelManager.expenseFetchController(for: self.budget.objectID,
                                                                            startDate: startDate as NSDate,
                                                                            finishDate: finishDate as NSDate,
                                                                            managedObjectContext: self.managedObjectContext)
    }
    
    // MARK: - Tests
    
    func testNoExpenses() {
        self.createFetchedResultsController()
        self.fetchedResultsController.performSilentFailureFetch()
        
        expect(self.fetchedResultsController.numberOfObjects()) == 0
    }
    
    func testOneExpense() {
        var expense = self.createExpense()
        expense.name = "Expense 1"
        expense.creationDate = NSDate()
        
        expense = self.createExpense()
        expense.name = "Expense 2"
        expense.isRemoved = NSNumber(value: true)
        expense.creationDate = NSDate()
        
        ModelManager.saveContext(self.managedObjectContext)
        
        self.createFetchedResultsController()
        self.fetchedResultsController.performSilentFailureFetch()
        
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
        
        var expense = self.createExpense()
        expense.name = "Expense 1"
        expense.creationDate = dateComponents.date! as NSDate
        
        dateComponents.hour = 23
        dateComponents.minute = 59
        expense = self.createExpense()
        expense.name = "Expense 2"
        expense.creationDate = dateComponents.date! as NSDate
        
        ModelManager.saveContext(self.managedObjectContext)
        self.createFetchedResultsController(startDate: startDate, finishDate: finishDate)
        self.fetchedResultsController.performSilentFailureFetch()
        
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
        
        var expense = self.createExpense()
        expense.name = "Expense 1"
        expense.creationDate = dateComponents.date! as NSDate
        
        dateComponents.hour = 0
        dateComponents.minute = 0
        expense = self.createExpense()
        expense.name = "Expense 2"
        expense.creationDate = dateComponents.date! as NSDate
        
        ModelManager.saveContext(self.managedObjectContext)
        self.createFetchedResultsController(startDate: startDate, finishDate: finishDate)
        self.fetchedResultsController.performSilentFailureFetch()
        
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
        var expense = self.createExpense()
        expense.name = "Expense 1"
        expense.creationDate = dateComponents.date! as NSDate
        
        dateComponents.day = 2
        expense = self.createExpense()
        expense.name = "Expense 2"
        expense.creationDate = dateComponents.date! as NSDate
        
        dateComponents.day = 31
        expense = self.createExpense()
        expense.name = "Expense 3"
        expense.creationDate = dateComponents.date! as NSDate
        
        ModelManager.saveContext(self.managedObjectContext)
        self.createFetchedResultsController(startDate: startDate, finishDate: finishDate)
        self.fetchedResultsController.performSilentFailureFetch()
        
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
        var expense = self.createExpense()
        expense.name = "Expense 1"
        expense.creationDate = dateComponents.date! as NSDate
        
        dateComponents.day = 2
        expense = self.createExpense()
        expense.name = "Expense 2"
        expense.creationDate = dateComponents.date! as NSDate
        
        dateComponents.day = 31
        expense = self.createExpense()
        expense.name = "Expense 3"
        expense.creationDate = dateComponents.date! as NSDate
        
        dateComponents.month = 3
        dateComponents.day = 1
        expense = self.createExpense()
        expense.name = "Expense 4"
        expense.creationDate = dateComponents.date! as NSDate
        
        ModelManager.saveContext(self.managedObjectContext)
        self.createFetchedResultsController(startDate: startDate, finishDate: finishDate)
        self.fetchedResultsController.performSilentFailureFetch()
        
        expect(self.fetchedResultsController.numberOfObjects()) == 0
    }
}
