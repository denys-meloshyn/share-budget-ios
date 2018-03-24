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
    private var router: MockCategoryRouter!
    private var interaction: CategoryInteraction!
    private var viewController: MockCategoryViewController!
    private var presenter: CategoryPresenter<CategoryInteraction, MockCategoryRouter>!
    private var view: CategoryView<CategoryPresenter<CategoryInteraction, MockCategoryRouter>>!
    
    private var budget: Budget!
    private var expense: Expense!
    private var managedObjectContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)

        budget = Budget(context: managedObjectContext)
        budget.name = "Test budget"
        expense = Expense(context: managedObjectContext)
        budget.addToExpenses(expense)

        viewController = MockCategoryViewController()
        viewController.expenseID = expense.objectID
        viewController.managedObjectContext = managedObjectContext
        router = MockCategoryRouter(with: viewController)
        interaction = CategoryInteraction(with: expense.objectID, managedObjectContext: managedObjectContext)
        presenter = CategoryPresenter(with: interaction, router: router, delegate: nil)
        view = MockCategoryView(with: presenter, and: viewController)

        viewController.viperView = view
        viewController.tableView = UITableView()
        viewController.viewDidLoad()
    }
    
    override func tearDown() {
        ModelManager.dropAllEntities()
        
        super.tearDown()
    }
    
    private func addDefaultItems(number: Int = 1) {
        for i in 0..<number {
            let model = Category(context: managedObjectContext)
            model.name = "Name_\(i)"
            model.budget = budget
            budget.addToCategories(model)
        }

        ModelManager.saveContext(managedObjectContext)
    }

    // MARK: - Test

    func testHeaderModeCreate() {
        let result = BudgetHeaderMode.create
        let expected = presenter.headerMode()
        XCTAssertEqual(result, expected)
    }

    func testHeaderModeSearch() {
        self.addDefaultItems(number: 2)

        let result = BudgetHeaderMode.search
        let expected = presenter.headerMode()
        XCTAssertEqual(result, expected)
    }

    func testNumberOfRowsInSectionInTableView() {
        addDefaultItems(number: 10)

        let result = presenter.tableView(view.tableView!, numberOfRowsInSection: 0)
        expect(result) == 10
    }

    func testViewForHeaderInSectionNotEmpty() {
        addDefaultItems()

        let header = presenter.tableView(view.tableView!, viewForHeaderInSection: 0) as! CreateSearchTableViewHeader

        expect(header.textField?.text).notTo(beNil())
        expect(header.textField?.placeholder).notTo(beNil())
    }

    func testCellCreated() {
        addDefaultItems()

        let cell = presenter.tableView(view.tableView!, cellForRowAt: IndexPath(row: 0, section: 0))

        expect(cell.textLabel?.text).notTo(beNil())
    }

    func testBudgetPageOpened() {
        addDefaultItems()

        self.presenter.tableView(view.tableView!, didSelectRowAt: IndexPath(row: 0, section: 0))

        let expected = CalledMethod("closePage()")
        expect(self.router.calledMethodManager.methods).to(contain(expected))
    }

    func testTableRowHeightNotZero() {
        expect(self.presenter.tableView(UITableView(), heightForHeaderInSection: 0)) > 0
    }
}
