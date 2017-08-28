//
//  CategoryPresenterTest.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 28.08.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import XCTest
import CoreData
import Nimble
@testable import ShareBudget

class CategoryPresenterTest: XCTestCase {
    var view: CategoryView!
    var router: CategoryRouter!
    var presenter: CategoryPresenter!
    var interaction: CategoryInteraction!
    var viewController: MockCategoryViewController!
    
    var budget: Budget!
    var expense: Expense!
    var managedObjectContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        self.managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)
        
        self.budget = Budget(context: self.managedObjectContext)
        self.budget.name = "Test budget"
        self.expense = Expense(context: self.managedObjectContext)
        self.budget.addToExpenses(expense)
        
        self.viewController = MockCategoryViewController()
        self.viewController.expenseID = self.expense.objectID
        self.viewController.managedObjectContext = self.managedObjectContext
        self.router = CategoryRouter(with: self.viewController)
        self.interaction = CategoryInteraction(with: expense.objectID, managedObjectContext: self.managedObjectContext)
        self.presenter = CategoryPresenter(with: interaction, router: router, delegate: nil)
        self.view = CategoryView(with: self.presenter, and: self.viewController)
        
        viewController.viperView = self.view
    }
    
    override func tearDown() {
        ModelManager.dropAllEntities()
        
        super.tearDown()
    }
    
    // MARK: - Test
    
    func testHeaderModeCreate() {
        let result = BudgetHeaderMode.create
        let expected = self.presenter.headerMode()
        XCTAssertEqual(result, expected)
    }
    
    func testHeaderModeSearch() {
        var model = Category(context: self.managedObjectContext)
        model.name = "Name_1"
        model.budget = self.budget
        self.budget.addToCategories(model)
        
        model = Category(context: self.managedObjectContext)
        model.name = "Name_2"
        model.budget = self.budget
        self.budget.addToCategories(model)
        
        ModelManager.saveContext(self.managedObjectContext)
        
        let result = BudgetHeaderMode.search
        let expected = self.presenter.headerMode()
        XCTAssertEqual(result, expected)
    }
}
