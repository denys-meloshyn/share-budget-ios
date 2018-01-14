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
    var view: MockBudgetView<MockBudgetPresenter<BudgetInteraction>>!
    var router: MockBudgetRouter!
    var presenter: MockBudgetPresenter<BudgetInteraction>!
    var interaction: BudgetInteraction!
    var viewController: MockBudgetViewController!
    var managedObjectContext: NSManagedObjectContext!
    var createSearchTableViewHeader: CreateSearchTableViewHeader!
    
    override func setUp() {
        super.setUp()
        
        managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)
        createSearchTableViewHeader = R.nib.createSearchTableViewHeader().instantiate(withOwner: nil, options: nil).first as! CreateSearchTableViewHeader
        
        viewController = MockBudgetViewController()
        router = MockBudgetRouter(with: viewController)
        interaction = BudgetInteraction(managedObjectContext: managedObjectContext)
        presenter = MockBudgetPresenter(with: interaction, router: router)
        view = MockBudgetView(with: presenter, and: viewController)

        viewController.viperView = view
        viewController.tableView = UITableView()
        _ = viewController.view
    }
    
    override func tearDown() {
        ModelManager.dropAllEntities()
        
        super.tearDown()
    }
    
    func testStartListenKeyboardNotifications() {
        viewController.viewWillAppear(false)
        expect(self.presenter.calledMethodManager.methods).to(contain(CalledMethod("startListenKeyboardNotifications")))
    }

    func testStopListenKeyboardNotifications() {
        viewController.viewDidDisappear(false)
        expect(self.presenter.calledMethodManager.methods).to(contain(CalledMethod("stopListenKeyboardNotifications")))
    }

    func testViewDidLoadDelegateMethods() {
        expect(self.view.calledMethodManager.methods).to(contain(CalledMethod("showPage(title:)")))
        expect(self.view.calledMethodManager.methods).to(contain(CalledMethod("showTabBar(title:image:selected:)")))
    }

    func testHeaderModeSearch() {
        var model = Budget(context: managedObjectContext)
        model.name = "Name_A"
        model = Budget(context: managedObjectContext)
        model.name = "Name_B"
        ModelManager.saveContext(managedObjectContext)

        let result = BudgetHeaderMode.search
        let expected = presenter.headerMode()
        XCTAssertEqual(result, expected)
    }

    func testHeaderModeCreate() {
        let result = BudgetHeaderMode.create
        let expected = presenter.headerMode()
        XCTAssertEqual(result, expected)
    }

    func testUpdateSearchPlaceholderCreateNew() {
        presenter.updateSearchPlaceholder("")

        let expected = CalledMethod("showCreateNewGroupMessage(message:)")
        expect(self.view.calledMethodManager.methods).to(contain(expected))
    }

    func testUpdateSearchPlaceholderList() {
        let model = Budget(context: managedObjectContext)
        model.name = "Name_A"
        ModelManager.saveContext(managedObjectContext)

        presenter.updateSearchPlaceholder("")

        let expected = CalledMethod("showGroupList")
        expect(self.view.calledMethodManager.methods).to(contain(expected))
    }

    func testNumberOfGroupToShow() {
        for i in 0..<10 {
            let model = Budget(context: managedObjectContext)
            model.name = "Name_\(i)"
        }
        ModelManager.saveContext(managedObjectContext)

        let result = presenter.tableView(UITableView(), numberOfRowsInSection: 0)
        expect(result) == 10
    }

    func testRefreshDataWillChangeContent() {
        presenter.willChangeContent()

        let expected = [CalledMethod("showTabBar(title:image:selected:)"), CalledMethod("showPage(title:)"), CalledMethod("showGroupList")]
        expect(self.view.calledMethodManager.methods).to(contain(expected))
    }

    func testRefreshDataDidChangeContent() {
        presenter.didChangeContent()

        let expected = [CalledMethod("showTabBar(title:image:selected:)"), CalledMethod("showPage(title:)"), CalledMethod("showGroupList")]
        expect(self.view.calledMethodManager.methods).to(contain(expected))
    }

    func testCellCreated() {
        let model = Budget(context: managedObjectContext)
        model.name = "Name_A"
        ModelManager.saveContext(managedObjectContext)

        let cell = presenter.tableView(view.tableView!, cellForRowAt: IndexPath(row: 0, section: 0))

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

        var expected = CalledMethod("cancelSearch")
        expect(self.view.calledMethodManager.methods).to(contain(expected))
        expected = CalledMethod("showGroupList")
        expect(self.view.calledMethodManager.methods).to(contain(expected))
    }

    func testCreateNewBudgetEmptyNameWithWhiteSpaces() {
        self.createSearchTableViewHeader.textField?.text = "      "

        self.presenter.createNewItem(self.createSearchTableViewHeader, self.createSearchTableViewHeader.textField!.text)

        var expected = CalledMethod("cancelSearch")
        expect(self.view.calledMethodManager.methods).to(contain(expected))
        expected = CalledMethod("showGroupList")
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
