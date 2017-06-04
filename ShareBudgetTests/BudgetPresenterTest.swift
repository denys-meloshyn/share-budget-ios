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
    var createSearchTableViewHeader: CreateSearchTableViewHeader!
    
    override func setUp() {
        super.setUp()
        
        ModelManager.dropAllEntities()
        createSearchTableViewHeader = R.nib.createSearchTableViewHeader().instantiate(withOwner: nil, options: nil).first as! CreateSearchTableViewHeader
        
        viewController = MockBudgetViewController()
        router = MockBudgetRouter(with: viewController)
        interaction = MockBudgetInteraction()
        presenter = MockBudgetPresenter(with: interaction, router: router)
        view = MockBudgetView(with: presenter, and: viewController)
        
        viewController.viperView = view
        
        viewController.tableView = UITableView()
        
        viewController.viewDidLoad()
    }
    
    func testStartListenKeyboardNotifications() {
        let hideKeyboard = #selector(MockBudgetPresenter.startListenKeyboardNotifications)
        
        viewController.viewWillAppear(false)
        expect(self.presenter.calledMethodManager.methods).to(contain(CalledMethod(hideKeyboard)))
    }
    
    func testStopListenKeyboardNotifications() {
        let hideKeyboard = #selector(MockBudgetPresenter.stopListenKeyboardNotifications)
        
        viewController.viewDidDisappear(false)
        expect(self.presenter.calledMethodManager.methods).to(contain(CalledMethod(hideKeyboard)))
    }
    
    func testViewDidLoadDelegateMethods() {
        let showPage = #selector(MockBudgetView.showPage(title:))
        let showTabBar = #selector(MockBudgetView.showTabBar(title:image:selected:))
        
        expect(self.view.calledMethodManager.methods).to(contain(CalledMethod(showPage)))
        expect(self.view.calledMethodManager.methods).to(contain(CalledMethod(showTabBar)))
    }
    
    func testHeaderModeSearch() {
        var model = Budget(context: ModelManager.managedObjectContext)
        model.name = "Name_A"
        model = Budget(context: ModelManager.managedObjectContext)
        model.name = "Name_B"
        ModelManager.saveContext(ModelManager.managedObjectContext)
        
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
        presenter.updateSearchPlaceholder("")
        
        let expected = CalledMethod(#selector(MockBudgetView.showCreateNewGroupMessage(message:)))
        expect(self.view.calledMethodManager.methods).to(contain(expected))
    }
    
    func testUpdateSearchPlaceholderList() {
        let model = Budget(context: ModelManager.managedObjectContext)
        model.name = "Name_A"
        ModelManager.saveContext(ModelManager.managedObjectContext)
        
        presenter.updateSearchPlaceholder("")
        
        let expected = CalledMethod(#selector(MockBudgetView.showGroupList))
        expect(self.view.calledMethodManager.methods).to(contain(expected))
    }
    
    func testNumberOfGroupToShow() {
        for i in 0..<10 {
            let model = Budget(context: ModelManager.managedObjectContext)
            model.name = "Name_\(i)"
        }
        ModelManager.saveContext(ModelManager.managedObjectContext)
        
        let result = presenter.tableView(UITableView(), numberOfRowsInSection: 0)
        expect(result) == 10
    }
    
    func testRefreshDataWillChangeContent() {
        presenter.willChangeContent()
        
        let expected = CalledMethod("showPageWithTitle:")
        expect(self.view.calledMethodManager.methods).to(contain(expected))
    }
    
    func testRefreshDataDidChangeContent() {
        presenter.didChangeContent()
        
        let expected = CalledMethod("showPageWithTitle:")
        expect(self.view.calledMethodManager.methods).to(contain(expected))
    }
    
    func testCellCreated() {
        let model = Budget(context: ModelManager.managedObjectContext)
        model.name = "Name_A"
        ModelManager.saveContext(ModelManager.managedObjectContext)
        
        let cell = presenter.tableView(UITableView(), cellForRowAt: IndexPath(row: 0, section: 0))
        
        expect(cell.textLabel?.text).notTo(beNil())
    }
    
    func testHeaderCreated() {
        let header = presenter.tableView(UITableView(), viewForHeaderInSection: 0) as? CreateSearchTableViewHeader
        
        expect(header?.textField?.text).notTo(beNil())
        expect(header?.textField?.placeholder).notTo(beNil())
    }
    
    func testDetailPageOpened() {
        let model = Budget(context: ModelManager.managedObjectContext)
        model.name = "Name_A"
        ModelManager.saveContext(ModelManager.managedObjectContext)
        
        presenter.tableView(UITableView(), didSelectRowAt: IndexPath(row: 0, section: 0))
        
        let expected = CalledMethod("openDetailPage")
        expect(self.router.calledMethodManager.methods).to(contain(expected))
    }
    
    func testTableRowHeightNotZero() {
        expect(self.presenter.tableView(UITableView(), heightForHeaderInSection: 0)) > 0
    }
    
    func testSearchTextChangedWithoutWhiteSpaces() {
        createSearchTableViewHeader.textField?.text = "Test"
        
        presenter.textChanged(createSearchTableViewHeader, createSearchTableViewHeader.textField!.text!)
        
        expect(self.createSearchTableViewHeader.textField?.text) == "Test"
    }
    
    func testSearchTextChangedWithOneWhiteSpace() {
        createSearchTableViewHeader.textField?.text = "Test "
        
        presenter.textChanged(createSearchTableViewHeader, createSearchTableViewHeader.textField!.text!)
        
        expect(self.createSearchTableViewHeader.textField?.text) == "Test "
    }
    
    func testSearchTextChangedWithMoreThaOneWhiteSpace() {
        createSearchTableViewHeader.textField?.text = "Test    "
        
        presenter.textChanged(createSearchTableViewHeader, createSearchTableViewHeader.textField!.text!)
        
        expect(self.createSearchTableViewHeader.textField?.text) == "Test "
    }
    
    func testCreateNewBudgetEmptyName() {
        createSearchTableViewHeader.textField?.text = ""
        
        presenter.createNewItem(createSearchTableViewHeader, createSearchTableViewHeader.textField?.text)
        
        var expected = CalledMethod(#selector(MockBudgetView.cancelSearch))
        expect(self.view.calledMethodManager.methods).to(contain(expected))
        expected = CalledMethod(#selector(MockBudgetView.showGroupList))
        expect(self.view.calledMethodManager.methods).to(contain(expected))
    }
    
    func testCreateNewBudgetEmptyNameWithWhiteSpaces() {
        createSearchTableViewHeader.textField?.text = "      "
        
        presenter.createNewItem(createSearchTableViewHeader, createSearchTableViewHeader.textField?.text)
        
        var expected = CalledMethod(#selector(MockBudgetView.cancelSearch))
        expect(self.view.calledMethodManager.methods).to(contain(expected))
        expected = CalledMethod(#selector(MockBudgetView.showGroupList))
        expect(self.view.calledMethodManager.methods).to(contain(expected))
    }
    
    func testCreateNewBudgetEmptyNameValid() {
        createSearchTableViewHeader.textField?.text = "Test"
        
        presenter.createNewItem(createSearchTableViewHeader, createSearchTableViewHeader.textField?.text)
        ModelManager.saveContext(ModelManager.managedObjectContext)
        
        expect(self.interaction.numberOfRowsInSection()) == 1
        
        let model = interaction.budgetModel(for: IndexPath(row: 0, section: 0))
        expect(model.name) == "Test"
    }
}
