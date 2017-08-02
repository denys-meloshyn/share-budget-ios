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

class ModelManagerTest: XCTestCase {
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
    
    private func performFetch() {
        do {
            try self.fetchedResultsController.performFetch()
        }
        catch {
            assertionFailure()
        }
    }
    
    private func numberOfObjects() -> Int {
        let result = self.fetchedResultsController.sections!.reduce(0, { (result: Int, item: NSFetchedResultsSectionInfo) -> Int in
            result + item.numberOfObjects
        })
        
        return result
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
    
    private func createFetchedResultsController() {
        self.fetchedResultsController = ModelManager.expenseFetchController(for: self.budget.objectID,
                                                                            startDate: UtilityFormatter.firstMonthDay() as NSDate,
                                                                            finishDate: UtilityFormatter.lastMonthDay() as NSDate,
                                                                            managedObjectContext: self.managedObjectContext)
    }
    
    func testNoExpenses() {
        self.createFetchedResultsController()
        self.performFetch()
        
        expect(self.numberOfObjects()) == 0
    }
    
    func testOneExpense() {
        var expense = self.createExpense()
        expense.name = "Expense 1"
        expense.creationDate = NSDate()
        
        expense = self.createExpense()
        expense.name = "Expense 2"
        expense.creationDate = NSDate()
        
        ModelManager.saveContext(self.managedObjectContext)
        
        self.createFetchedResultsController()
        self.performFetch()
        
        expect(self.numberOfObjects()) == self.budget.expenses!.count
    }
}
