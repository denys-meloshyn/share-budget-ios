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
        expense.creationDate = NSDate()
        self.budget.addToExpenses(expense)
        
        let category = Category(context: self.managedObjectContext)
        category.name = "Test category"
        category.budget = self.budget
        category.addToExpenses(expense)
        expense.category = category
        self.budget.addToCategories(category)
        
        return expense
    }
    
    func testInit() {
        expect(self.budgetDetailInteraction.budgetID).notTo(beNil())
        expect(self.budgetDetailInteraction.budget) == self.budget
    }
    
    func testNoExpenses() {
        expect(self.budgetDetailInteraction.isEmpty()).to(beTrue())
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
}
