//
//  BudgetPresenterTest.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 18.05.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//
import XCTest
import Nimble
import CoreData
@testable import ShareBudget

class BudgetPresenterTest: XCTestCase {
    var view: MockBudgetView!
    var router: MockBudgetRouter!
    var presenter: MockBudgetPresenter!
    var interaction: MockBudgetInteraction!
    var viewController: MockBudgetViewController!
    var managedObjectContext: NSManagedObjectContext!
    var createSearchTableViewHeader: CreateSearchTableViewHeader!
    
    override func setUp() {
        super.setUp()
        
        self.managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)
        self.createSearchTableViewHeader = R.nib.createSearchTableViewHeader().instantiate(withOwner: nil, options: nil).first as! CreateSearchTableViewHeader
        
        self.viewController = MockBudgetViewController()
        self.router = MockBudgetRouter(with: self.viewController)
        self.interaction = MockBudgetInteraction(managedObjectContext: self.managedObjectContext)
        self.presenter = MockBudgetPresenter(with: self.interaction, router: self.router)
        self.view = MockBudgetView(with: self.presenter, and: self.viewController)
        
        self.viewController.viperView = self.view
        
        self.viewController.tableView = UITableView()
        
        self.viewController.viewDidLoad()
    }
    
    override func tearDown() {
        ModelManager.dropAllEntities()
        
        super.tearDown()
    }
    
    func testStartListenKeyboardNotifications() {
        let hideKeyboard = #selector(MockBudgetPresenter.startListenKeyboardNotifications)
        
        self.viewController.viewWillAppear(false)
        expect(self.presenter.calledMethodManager.methods).to(contain(CalledMethod(hideKeyboard)))
    }
    
    func testStopListenKeyboardNotifications() {
        let hideKeyboard = #selector(MockBudgetPresenter.stopListenKeyboardNotifications)
        
        self.viewController.viewDidDisappear(false)
        expect(self.presenter.calledMethodManager.methods).to(contain(CalledMethod(hideKeyboard)))
    }
    
    func testViewDidLoadDelegateMethods() {
        let showPage = #selector(MockBudgetView.showPage(title:))
        let showTabBar = #selector(MockBudgetView.showTabBar(title:image:selected:))
        
        expect(self.view.calledMethodManager.methods).to(contain(CalledMethod(showPage)))
        expect(self.view.calledMethodManager.methods).to(contain(CalledMethod(showTabBar)))
    }
    
    func testHeaderModeSearch() {
        var model = Budget(context: self.managedObjectContext)
        model.name = "Name_A"
        model = Budget(context: self.managedObjectContext)
        model.name = "Name_B"
        ModelManager.saveContext(self.managedObjectContext)
        
        let result = BudgetHeaderMode.search
        let expected = self.presenter.headerMode()
        XCTAssertEqual(result, expected)
    }
    
    func testHeaderModeCreate() {
        let result = BudgetHeaderMode.create
        let expected = self.presenter.headerMode()
        XCTAssertEqual(result, expected)
    }
    
    func testUpdateSearchPlaceholderCreateNew() {
        self.presenter.updateSearchPlaceholder("")
        
        let expected = CalledMethod(#selector(MockBudgetView.showCreateNewGroupMessage(message:)))
        expect(self.view.calledMethodManager.methods).to(contain(expected))
    }
    
    func testUpdateSearchPlaceholderList() {
        let model = Budget(context: self.managedObjectContext)
        model.name = "Name_A"
        ModelManager.saveContext(self.managedObjectContext)
        
        self.presenter.updateSearchPlaceholder("")
        
        let expected = CalledMethod(#selector(MockBudgetView.showGroupList))
        expect(self.view.calledMethodManager.methods).to(contain(expected))
    }
    
    func testNumberOfGroupToShow() {
        for i in 0..<10 {
            let model = Budget(context: self.managedObjectContext)
            model.name = "Name_\(i)"
        }
        ModelManager.saveContext(self.managedObjectContext)
        
        let result = presenter.tableView(UITableView(), numberOfRowsInSection: 0)
        expect(result) == 10
    }
    
    func testRefreshDataWillChangeContent() {
        self.presenter.willChangeContent()
        
        let expected = CalledMethod("showPageWithTitle:")
        expect(self.view.calledMethodManager.methods).to(contain(expected))
    }
    
    func testRefreshDataDidChangeContent() {
        self.presenter.didChangeContent()
        
        let expected = CalledMethod("showPageWithTitle:")
        expect(self.view.calledMethodManager.methods).to(contain(expected))
    }
    
    func testCellCreated() {
        let model = Budget(context: self.managedObjectContext)
        model.name = "Name_A"
        ModelManager.saveContext(self.managedObjectContext)
        
        let cell = presenter.tableView(UITableView(), cellForRowAt: IndexPath(row: 0, section: 0))
        
        expect(cell.textLabel?.text).notTo(beNil())
    }
    
    func testHeaderCreated() {
        let header = self.presenter.tableView(UITableView(), viewForHeaderInSection: 0) as! CreateSearchTableViewHeader
        
        expect(header.textField?.text).notTo(beNil())
        expect(header.textField?.placeholder).notTo(beNil())
    }
    
    func testDetailPageOpened() {
        let model = Budget(context: self.managedObjectContext)
        model.name = "Name_A"
        ModelManager.saveContext(self.managedObjectContext)
        
        self.presenter.tableView(UITableView(), didSelectRowAt: IndexPath(row: 0, section: 0))
        
        let expected = CalledMethod("openDetailPage")
        expect(self.router.calledMethodManager.methods).to(contain(expected))
    }
    
    func testTableRowHeightNotZero() {
        expect(self.presenter.tableView(UITableView(), heightForHeaderInSection: 0)) > 0
    }
    
    func testSearchTextChangedWithoutWhiteSpaces() {
        self.createSearchTableViewHeader.textField?.text = "Test"
        
        self.presenter.textChanged(self.createSearchTableViewHeader, self.createSearchTableViewHeader.textField!.text!)
        
        expect(self.createSearchTableViewHeader.textField?.text) == "Test"
    }
    
    func testSearchTextChangedWithOneWhiteSpace() {
        createSearchTableViewHeader.textField?.text = "Test "
        
        self.presenter.textChanged(self.createSearchTableViewHeader, self.createSearchTableViewHeader.textField!.text!)
        
        expect(self.createSearchTableViewHeader.textField?.text) == "Test "
    }
    
    func testSearchTextChangedWithMoreThaOneWhiteSpace() {
        self.createSearchTableViewHeader.textField?.text = "Test    "
        
        self.presenter.textChanged(self.createSearchTableViewHeader, self.createSearchTableViewHeader.textField!.text!)
        
        expect(self.createSearchTableViewHeader.textField?.text) == "Test "
    }
    
    func testCreateNewBudgetEmptyName() {
        self.createSearchTableViewHeader.textField?.text = ""
        
        self.presenter.createNewItem(self.createSearchTableViewHeader, self.createSearchTableViewHeader.textField!.text)
        
        var expected = CalledMethod(#selector(MockBudgetView.cancelSearch))
        expect(self.view.calledMethodManager.methods).to(contain(expected))
        expected = CalledMethod(#selector(MockBudgetView.showGroupList))
        expect(self.view.calledMethodManager.methods).to(contain(expected))
    }
    
    func testCreateNewBudgetEmptyNameWithWhiteSpaces() {
        self.createSearchTableViewHeader.textField?.text = "      "
        
        self.presenter.createNewItem(self.createSearchTableViewHeader, self.createSearchTableViewHeader.textField!.text)
        
        var expected = CalledMethod(#selector(MockBudgetView.cancelSearch))
        expect(self.view.calledMethodManager.methods).to(contain(expected))
        expected = CalledMethod(#selector(MockBudgetView.showGroupList))
        expect(self.view.calledMethodManager.methods).to(contain(expected))
    }
    
    func testCreateNewBudgetEmptyNameValid() {
        self.createSearchTableViewHeader.textField?.text = "Test"
        
        self.presenter.createNewItem(self.createSearchTableViewHeader, self.createSearchTableViewHeader.textField!.text)
        ModelManager.saveContext(self.managedObjectContext)
        
        expect(self.interaction.numberOfRowsInSection()) == 1
        
        let model = interaction.budgetModel(for: IndexPath(row: 0, section: 0))
        expect(model.name) == "Test"
    }
}
