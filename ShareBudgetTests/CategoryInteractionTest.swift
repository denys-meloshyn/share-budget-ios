//
//  CategoryInteractionTest.swift
//  ShareBudgetTests
//
//  Created by Denys Meloshyn on 29.07.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import XCTest
import CoreData
import Nimble
@testable import ShareBudget

class CategoryInteractionTest: XCTestCase {
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
        self.budget.name = "Main budget"
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
    
    func testFilterRemoved() {
        var category = Category(context: self.managedObjectContext)
        category.name = "Category 1"
        category.isRemoved = NSNumber(value: true)
        self.budget.addToCategories(category)
        
        category = Category(context: self.managedObjectContext)
        category.name = "Category 2"
        category.isRemoved = NSNumber(value: true)
        self.budget.addToCategories(category)
        
        category = Category(context: self.managedObjectContext)
        category.name = "Category 3"
        category.isRemoved = NSNumber(value: true)
        self.budget.addToCategories(category)
        
        category = Category(context: self.managedObjectContext)
        category.name = "Category 4"
        category.isRemoved = NSNumber(value: false)
        self.budget.addToCategories(category)
        
        category = Category(context: self.managedObjectContext)
        category.name = "Category 5"
        category.isRemoved = NSNumber(value: true)
        self.budget.addToCategories(category)
        
        ModelManager.saveContext(self.managedObjectContext)
        
        self.interaction.updateWithSearch("")
        
        expect(self.interaction.numberOfCategories()) == 1
    }
    
    func testRemovedNotExist() {
        var category = Category(context: self.managedObjectContext)
        category.name = "Category 1"
        category.isRemoved = NSNumber(value: false)
        self.budget.addToCategories(category)
        
        category = Category(context: self.managedObjectContext)
        category.name = "Category 2"
        category.isRemoved = NSNumber(value: false)
        self.budget.addToCategories(category)
        
        category = Category(context: self.managedObjectContext)
        category.name = "Category 3"
        category.isRemoved = NSNumber(value: false)
        self.budget.addToCategories(category)
        
        category = Category(context: self.managedObjectContext)
        category.name = "Category 4"
        category.isRemoved = NSNumber(value: false)
        self.budget.addToCategories(category)
        
        ModelManager.saveContext(self.managedObjectContext)
        
        self.interaction.updateWithSearch("")
        
        expect(self.interaction.numberOfCategories()) == 4
    }
    
    func testCreateCategoryEmptyString() {
        let result = self.interaction.createCategory(with: "")
        
        expect(result.name) == ""
        expect(self.budget) == result.budget
        expect(result.isChanged?.boolValue).to(beTrue())
    }
    
    func testCreateCategoryNameNotEmpty() {
        let result = self.interaction.createCategory(with: "test")
        
        expect(result.name) == "test"
        expect(self.budget) == result.budget
        expect(result.isChanged?.boolValue).to(beTrue())
    }
}
