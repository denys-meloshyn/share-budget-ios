//
//  BudgetPresenterTest.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 18.05.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import XCTest
@testable import ShareBudget

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
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNumberOfGroupToShow() {
        viewController.viewDidLoad()
        interaction.numberOfItems = 10
        
        XCTAssertEqual(presenter.tableView(UITableView(), numberOfRowsInSection: 0), 10)
    }
}
