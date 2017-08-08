//
//  BudgetLimitFetchController.swift
//  ShareBudgetTests
//
//  Created by Denys Meloshyn on 08.08.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import XCTest
import Nimble
import CoreData
@testable import ShareBudget

class BudgetLimitFetchController: XCTestCase {
    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<Budget>!
    
    override func setUp() {
        super.setUp()
        
        self.managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)
        self.fetchedResultsController = nil
    }
    
    override func tearDown() {
        ModelManager.dropAllEntities()
        
        super.tearDown()
    }
    
    func testNoBudgets() {
        let _ = Expense(context: self.managedObjectContext)
        let _ = Category(context: self.managedObjectContext)
        
        self.fetchedResultsController = ModelManager.budgetFetchController(self.managedObjectContext)
        self.fetchedResultsController.performSilentFailureFetch()
        expect(self.fetchedResultsController.numberOfObjects()) == 0
    }
    
    func testBudgetsExist() {
        let _ = Budget(context: self.managedObjectContext)
        let _ = Budget(context: self.managedObjectContext)
        
        self.fetchedResultsController = ModelManager.budgetFetchController(self.managedObjectContext)
        self.fetchedResultsController.performSilentFailureFetch()
        expect(self.fetchedResultsController.numberOfObjects()) == 2
    }
    
    func testExistedBudgetsWithRemoved() {
        let budget = Budget(context: self.managedObjectContext)
        budget.isRemoved = NSNumber(value: true)
        let _ = Budget(context: self.managedObjectContext)
        
        self.fetchedResultsController = ModelManager.budgetFetchController(self.managedObjectContext)
        self.fetchedResultsController.performSilentFailureFetch()
        
        expect(self.fetchedResultsController.numberOfObjects()) == 1
    }
    
    func testFilterWithEmptyString() {
        var budget = Budget(context: self.managedObjectContext)
        budget.name = "test"
        budget = Budget(context: self.managedObjectContext)
        budget.name = "test"
        
        self.fetchedResultsController = ModelManager.budgetFetchController(self.managedObjectContext, search: "")
        self.fetchedResultsController.performSilentFailureFetch()
        
        expect(self.fetchedResultsController.numberOfObjects()) == 2
    }
    
    func testFilter() {
        var budget = Budget(context: self.managedObjectContext)
        budget.name = "test"
        budget = Budget(context: self.managedObjectContext)
        budget.name = "test"
        budget = Budget(context: self.managedObjectContext)
        budget.name = "budget"
        
        self.fetchedResultsController = ModelManager.budgetFetchController(self.managedObjectContext, search: "test")
        self.fetchedResultsController.performSilentFailureFetch()
        
        expect(self.fetchedResultsController.numberOfObjects()) == 2
    }
    
    func testFilterItemRemoved() {
        var budget = Budget(context: self.managedObjectContext)
        budget.name = "test"
        budget.isRemoved = NSNumber(value: true)
        budget = Budget(context: self.managedObjectContext)
        budget.name = "test"
        budget = Budget(context: self.managedObjectContext)
        budget.name = "budget"
        
        self.fetchedResultsController = ModelManager.budgetFetchController(self.managedObjectContext, search: "test")
        self.fetchedResultsController.performSilentFailureFetch()
        
        expect(self.fetchedResultsController.numberOfObjects()) == 1
    }
    
    func testFilterContainsText() {
        var budget = Budget(context: self.managedObjectContext)
        budget.name = "test"
        budget = Budget(context: self.managedObjectContext)
        budget.name = "test"
        budget = Budget(context: self.managedObjectContext)
        budget.name = "budget_test_budget"
        
        self.fetchedResultsController = ModelManager.budgetFetchController(self.managedObjectContext, search: "test")
        self.fetchedResultsController.performSilentFailureFetch()
        
        expect(self.fetchedResultsController.numberOfObjects()) == 3
    }
}
