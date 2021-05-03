//
//  MockBudgetView.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 18.05.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//
@testable import ShareBudget
import UIKit

class MockBudgetView<T: BudgetPresenterProtocol>: BudgetView<T> {
    let calledMethodManager = CalledMethodManager()

    override func showTabBar(title _: String, image _: UIImage, selected _: UIImage) {
        calledMethodManager.add("showTabBar(title:image:selected:)")
    }

    override func showPage(title _: String?) {
        calledMethodManager.add("showPage(title:)")
    }

    override func showCreateNewGroupMessage(message _: NSAttributedString) {
        calledMethodManager.add("showCreateNewGroupMessage(message:)")
    }

    override func showGroupList() {
        calledMethodManager.add("showGroupList")
    }

    override func refreshData(for _: BudgetHeaderMode) {
        calledMethodManager.add("showGroupList")
    }

    override func cancelSearch() {
        calledMethodManager.add("cancelSearch")
    }
}
