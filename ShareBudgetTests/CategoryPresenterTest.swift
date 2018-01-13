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
    private var view: CategoryViewProtocol!
    private var router: MockCategoryRouter!
    private var presenter: CategoryPresenterProtocol!
    private var interaction: CategoryInteractionProtocol!
    private var viewController: MockCategoryViewController!
    
    private var budget: Budget!
    private var expense: Expense!
    private var managedObjectContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
//        self.managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)
//
//        self.budget = Budget(context: self.managedObjectContext)
//        self.budget.name = "Test budget"
//        self.expense = Expense(context: self.managedObjectContext)
//        self.budget.addToExpenses(expense)
//
//        self.viewController = MockCategoryViewController()
//        self.viewController.expenseID = expense.objectID
//        self.viewController.managedObjectContext = self.managedObjectContext
//        self.router = MockCategoryRouter(with: self.viewController)
//        self.interaction = CategoryInteraction(with: self.expense.objectID, managedObjectContext: self.managedObjectContext)
//        self.presenter = CategoryPresenter(with: self.interaction, router: self.router, delegate: nil)
////        self.view = MockCategoryView(with: self.presenter, and: self.viewController)
//
////        viewController.viperView = self.view
//
//        self.viewController.tableView = UITableView()
//        self.viewController.viewDidLoad()
    }
    
    override func tearDown() {
        ModelManager.dropAllEntities()
        
        super.tearDown()
    }
    
//    private func addDefaultItems(number: Int = 1) {
//        for i in 0..<number {
//            let model = Category(context: self.managedObjectContext)
//            model.name = "Name_\(i)"
//            model.budget = self.budget
//            self.budget.addToCategories(model)
//        }
//
//        ModelManager.saveContext(self.managedObjectContext)
//    }
//
//    // MARK: - Test
//
//    func testHeaderModeCreate() {
//        let result = BudgetHeaderMode.create
//        let expected = self.presenter.headerMode()
//        XCTAssertEqual(result, expected)
//    }
//
//    func testHeaderModeSearch() {
//        self.addDefaultItems(number: 2)
//
//        let result = BudgetHeaderMode.search
//        let expected = self.presenter.headerMode()
//        XCTAssertEqual(result, expected)
//    }
//
//    func testNumberOfRowsInSectionInTableView() {
//        self.addDefaultItems(number: 10)
//
//        let result = self.presenter.tableView(self.view.tableView!, numberOfRowsInSection: 0)
//        expect(result) == 10
//    }
//
//    func testViewForHeaderInSectionNotEmpty() {
//        self.addDefaultItems()
//
//        let header = self.presenter.tableView(self.view.tableView!, viewForHeaderInSection: 0) as! CreateSearchTableViewHeader
//
//        expect(header.textField?.text).notTo(beNil())
//        expect(header.textField?.placeholder).notTo(beNil())
//    }
//
//    func testCellCreated() {
//        self.addDefaultItems()
//
//        let cell = presenter.tableView(self.view.tableView!, cellForRowAt: IndexPath(row: 0, section: 0))
//
//        expect(cell.textLabel?.text).notTo(beNil())
//    }
//
//    func testBudgetPageOpened() {
//        self.addDefaultItems()
//
//        self.presenter.tableView(self.view.tableView!, didSelectRowAt: IndexPath(row: 0, section: 0))
//
//        let expected = CalledMethod("closePage()")
//        expect(self.router.calledMethodManager.methods).to(contain(expected))
//    }
//
//    func testTableRowHeightNotZero() {
//        expect(self.presenter.tableView(UITableView(), heightForHeaderInSection: 0)) > 0
//    }
}
