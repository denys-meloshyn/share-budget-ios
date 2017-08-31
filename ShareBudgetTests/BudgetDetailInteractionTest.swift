//
//  BudgetDetailInteractionTest.swift
//  ShareBudgetTests
//
//  Created by Denys Meloshyn on 09.08.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import XCTest
import CoreData
import Nimble
@testable import ShareBudget

class BudgetDetailInteractionTest: XCTestCase {
    var budget: Budget!
    var managedObjectContext: NSManagedObjectContext!
    var budgetDetailInteraction: BudgetDetailInteraction!
    
    override func setUp() {
        super.setUp()
     
        self.managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)
        self.budget = Budget(context: self.managedObjectContext)
        self.budgetDetailInteraction = BudgetDetailInteraction(with: self.budget.objectID, managedObjectContext: self.managedObjectContext)
    }
    
    override func tearDown() {
        ModelManager.dropAllEntities()
        
        super.tearDown()
    }
    
    private func createExpense() -> Expense {
        let expense = Expense(context: self.managedObjectContext)
        expense.budget = self.budget
        expense.isRemoved = false
        expense.creationDate = NSDate()
        self.budget.addToExpenses(expense)
        
        return expense
    }
    
    // MARK: - Tests
    
    func testInit() {
        expect(self.budgetDetailInteraction.budgetID).notTo(beNil())
        expect(self.budgetDetailInteraction.budget) == self.budget
    }
    
    func testNoExpenses() {
        expect(self.budgetDetailInteraction.isEmpty()).to(beTrue())
        expect(self.budgetDetailInteraction.numberOfCategoryExpenses()) == 0
    }
    
    func testExpensesExist() {
        let _ = self.createExpense()
        ModelManager.saveContext(self.managedObjectContext)
        
        expect(self.budgetDetailInteraction.isEmpty()) == false
    }
    
    func testAllExpensesRemoved() {
        var expense = self.createExpense()
        expense.name = "Expense 1"
        expense.isRemoved = NSNumber(value: true)
        expense.price = NSNumber(value: 100)
        
        expense = self.createExpense()
        expense.name = "Expense 2"
        expense.isRemoved = NSNumber(value: true)
        expense.price = NSNumber(value: 95.5)
        ModelManager.saveContext(self.managedObjectContext)
        
        expect(self.budgetDetailInteraction.isEmpty()).to(beTrue())
        expect(self.budgetDetailInteraction.totalExpenses()) == 0.0
        expect(self.budgetDetailInteraction.numberOfCategoryExpenses()) == 0
    }
    
    func testTotalSum() {
        var expense = self.createExpense()
        expense.name = "Expense 1"
        expense.price = NSNumber(value: 100)
        
        expense = self.createExpense()
        expense.name = "Expense 2"
        expense.price = NSNumber(value: 95.5)
        
        expense = self.createExpense()
        expense.name = "Expense 3"
        expense.price = NSNumber(value: 0.5)
        
        expense = self.createExpense()
        expense.name = "Expense 4"
        expense.price = NSNumber(value: 36.4)
        
        ModelManager.saveContext(self.managedObjectContext)
        expect(self.budgetDetailInteraction.totalExpenses()) == 232.4
    }
    
    func testTotalSumRemovedExpensesExist() {
        var expense = self.createExpense()
        expense.name = "Expense 1"
        expense.price = NSNumber(value: 100)
        
        expense = self.createExpense()
        expense.name = "Expense 2"
        expense.isRemoved = NSNumber(value: true)
        expense.price = NSNumber(value: 95.5)
        
        expense = self.createExpense()
        expense.name = "Expense 3"
        expense.price = NSNumber(value: 0.5)
        
        expense = self.createExpense()
        expense.name = "Expense 4"
        expense.price = NSNumber(value: 36.4)
        
        ModelManager.saveContext(self.managedObjectContext)
        expect(self.budgetDetailInteraction.totalExpenses()) == 136.9
    }
    
    func testNumberOfCategoryExpenses() {
        var category = Category(context: self.managedObjectContext)
        category.name = "Category 1"
        
        var expense = self.createExpense()
        expense.name = "Expense 1"
        expense.price = NSNumber(value: 100)
        expense.category = category
        category.addToExpenses(expense)
        
        expense = self.createExpense()
        expense.name = "Expense 2"
        expense.price = NSNumber(value: 95.5)
        expense.category = category
        category.addToExpenses(expense)
        
        category = Category(context: self.managedObjectContext)
        category.name = "Category 2"
        
        expense = self.createExpense()
        expense.name = "Expense 3"
        expense.price = NSNumber(value: 95.5)
        expense.category = category
        category.addToExpenses(expense)
        
        ModelManager.saveContext(self.managedObjectContext)
        expect(self.budgetDetailInteraction.numberOfCategoryExpenses()) == 2
    }
    
    func testBudgetLimitNotExist() {
        expect(self.budgetDetailInteraction.lastMonthLimit()).to(beNil())
    }
    
    func testBudgetLimitOneExist() {
        let limit = BudgetLimit(context: self.managedObjectContext)
        limit.date = NSDate()
        limit.limit = NSNumber(value: 100.0)
        self.budget.addToLimits(limit)
        ModelManager.saveContext(self.managedObjectContext)
        
        let result = self.budgetDetailInteraction.lastMonthLimit()
        expect(result?.limit) == 100.0
    }
    
    func testBudgetLimitMultipleExist() {
        var limit = BudgetLimit(context: self.managedObjectContext)
        limit.date = NSDate()
        limit.limit = NSNumber(value: 100.0)
        self.budget.addToLimits(limit)
        
        limit = BudgetLimit(context: self.managedObjectContext)
        limit.date = NSDate()
        limit.limit = NSNumber(value: 200.0)
        self.budget.addToLimits(limit)
        ModelManager.saveContext(self.managedObjectContext)
        
        let result = self.budgetDetailInteraction.lastMonthLimit()
        expect(result?.limit) == 200.0
    }
}
