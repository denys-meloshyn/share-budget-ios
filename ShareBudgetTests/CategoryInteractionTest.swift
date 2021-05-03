//
//  CategoryInteractionTest.swift
//  ShareBudgetTests
//
//  Created by Denys Meloshyn on 29.07.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData
import Nimble
@testable import ShareBudget
import XCTest

class CategoryInteractionTest: XCTestCase {
    var router: CategoryRouter!
    var interaction: CategoryInteraction!
    var viewController: MockCategoryViewController!
    var presenter: CategoryPresenter<CategoryInteraction, CategoryRouter>!
    var view: CategoryView<CategoryPresenter<CategoryInteraction, CategoryRouter>>!

    var budget: Budget!
    var expense: Expense!
    var managedObjectContext: NSManagedObjectContext!

    override func setUp() {
        super.setUp()

        managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)

        budget = Budget(context: managedObjectContext)
        budget.name = "Main budget"
        expense = Expense(context: managedObjectContext)
        budget.addToExpenses(expense)

        viewController = MockCategoryViewController()
        viewController.expenseID = expense.objectID
        viewController.managedObjectContext = managedObjectContext
        router = CategoryRouter(with: viewController)
        interaction = CategoryInteraction(with: expense.objectID, managedObjectContext: managedObjectContext)
        presenter = CategoryPresenter(with: interaction, router: router, delegate: nil)
        view = CategoryView(with: presenter, and: viewController)

        viewController.viperView = view
    }

    override func tearDown() {
        ModelManager.dropAllEntities()

        super.tearDown()
    }

    func testFilterRemoved() {
        var category = Category(context: managedObjectContext)
        category.name = "Category 1"
        category.isRemoved = NSNumber(value: true)
        budget.addToCategories(category)

        category = Category(context: managedObjectContext)
        category.name = "Category 2"
        category.isRemoved = NSNumber(value: true)
        budget.addToCategories(category)

        category = Category(context: managedObjectContext)
        category.name = "Category 3"
        category.isRemoved = NSNumber(value: true)
        budget.addToCategories(category)

        category = Category(context: managedObjectContext)
        category.name = "Category 4"
        category.isRemoved = NSNumber(value: false)
        budget.addToCategories(category)

        category = Category(context: managedObjectContext)
        category.name = "Category 5"
        category.isRemoved = NSNumber(value: true)
        budget.addToCategories(category)

        ModelManager.saveContext(managedObjectContext)

        interaction.updateWithSearch("")

        expect(self.interaction.numberOfCategories()) == 1
    }

    func testRemovedNotExist() {
        var category = Category(context: managedObjectContext)
        category.name = "Category 1"
        category.isRemoved = NSNumber(value: false)
        budget.addToCategories(category)

        category = Category(context: managedObjectContext)
        category.name = "Category 2"
        category.isRemoved = NSNumber(value: false)
        budget.addToCategories(category)

        category = Category(context: managedObjectContext)
        category.name = "Category 3"
        category.isRemoved = NSNumber(value: false)
        budget.addToCategories(category)

        category = Category(context: managedObjectContext)
        category.name = "Category 4"
        category.isRemoved = NSNumber(value: false)
        budget.addToCategories(category)

        ModelManager.saveContext(managedObjectContext)

        interaction.updateWithSearch("")

        expect(self.interaction.numberOfCategories()) == 4
    }

    func testCreateCategoryEmptyString() {
        let result = interaction.createCategory(with: "")

        expect(result.name) == ""
        expect(self.budget) == result.budget
        expect(result.isChanged?.boolValue).to(beTrue())
    }

    func testCreateCategoryNameNotEmpty() {
        let result = interaction.createCategory(with: "test")

        expect(result.name) == "test"
        expect(self.budget) == result.budget
        expect(result.isChanged?.boolValue).to(beTrue())
    }

    func testCategoryForIndex() {
        _ = interaction.createCategory(with: "Category 1")
        _ = interaction.createCategory(with: "Category 2")
        ModelManager.saveContext(managedObjectContext)

        let result = interaction.category(for: IndexPath(row: 1, section: 0))

        expect(result.name) == "Category 2"
    }
}
