//
//  BudgetPresenterTest.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 18.05.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//
import XCTest
@testable import ShareBudget
import Nimble

class BudgetPresenterTest: XCTestCase {
    var view: MockBudgetView!
    var router: MockBudgetRouter!
    var presenter: MockBudgetPresenter!
    var interaction: MockBudgetInteraction!
    var viewController: MockBudgetViewController!
    
    override func setUp() {
        super.setUp()
        
        viewController = MockBudgetViewController()
        router = MockBudgetRouter(with: viewController)
        interaction = MockBudgetInteraction()
        presenter = MockBudgetPresenter(with: interaction, router: router)
        view = MockBudgetView(with: presenter, and: viewController)
        
        viewController.viperView = view
        
        viewController.tableView = UITableView()
        
        viewController.viewDidLoad()
    }
    
    func testViewDidLoadDelegateMethods() {
        let showPage = #selector(MockBudgetView.showPage(title:))
        let showTabBar = #selector(MockBudgetView.showTabBar(title:image:selected:))
        
        expect(self.view.calledMethodManager.methods).to(contain(CalledMethod(selector: showPage)))
        expect(self.view.calledMethodManager.methods).to(contain(CalledMethod(selector: showTabBar)))
    }
    
    func testHeaderModeSearch() {
        interaction.numberOfItems = 5
        
        let result = BudgetHeaderMode.search
        let expected = self.presenter.headerMode()
        XCTAssertEqual(result, expected)
    }
    
    func testHeaderModeCreate() {
        interaction.numberOfItems = 0
        
        let result = BudgetHeaderMode.create
        let expected = self.presenter.headerMode()
        XCTAssertEqual(result, expected)
    }
    
    func testUpdateSearchPlaceholderCreateNew() {
        interaction.numberOfItems = 0
        presenter.updateSearchPlaceholder("")
        
        let key = #selector(MockBudgetView.showCreateNewGroupMessage(message:))
        let expected = CalledMethod(selector: key)
        expect(self.view.calledMethodManager.methods).to(contain(expected))
    }
    
    func testUpdateSearchPlaceholderList() {
        interaction.numberOfItems = 7
        presenter.updateSearchPlaceholder("")
        
        let key = #selector(MockBudgetView.showGroupList)
        let expected = CalledMethod(selector: key)
        expect(self.view.calledMethodManager.methods).to(contain(expected))
    }
    
    func testNumberOfGroupToShow() {
        interaction.numberOfItems = 10
        
        let result = presenter.tableView(UITableView(), numberOfRowsInSection: 0)
        expect(result) == 10
    }
    
    func testRefreshDataWillChangeContent() {
        presenter.willChangeContent()
        
        let key = NSSelectorFromString("showPageWithTitle:")
        let expected = CalledMethod(selector: key)
        expect(self.view.calledMethodManager.methods).to(contain(expected))
    }
    
    func testRefreshDataDidChangeContent() {
        presenter.didChangeContent()
        
        let key = NSSelectorFromString("showPageWithTitle:")
        let expected = CalledMethod(selector: key)
        expect(self.view.calledMethodManager.methods).to(contain(expected))
    }
    
    func testCell() {
        let cell = presenter.tableView(UITableView(), cellForRowAt: IndexPath())
        
        expect(cell.textLabel?.text).to(equal("Test name"))
    }
}
