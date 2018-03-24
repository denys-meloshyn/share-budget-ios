//
//  MockBudgetView.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 18.05.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//
import UIKit
@testable import ShareBudget

class MockBudgetView<T: BudgetPresenterProtocol>: BudgetView<T> {
    
    let calledMethodManager = CalledMethodManager()
    
    override func showTabBar(title: String, image: UIImage, selected: UIImage) {
        calledMethodManager.add("showTabBar(title:image:selected:)")
    }
    
    override func showPage(title: String?) {
        calledMethodManager.add("showPage(title:)")
    }
    
    override func showCreateNewGroupMessage(message: NSAttributedString) {
        calledMethodManager.add("showCreateNewGroupMessage(message:)")
    }
    
    override func showGroupList() {
        calledMethodManager.add("showGroupList")
    }
    
    override func refreshData(for mode: BudgetHeaderMode) {
        calledMethodManager.add("showGroupList")
    }
    
    override func cancelSearch() {
        calledMethodManager.add("cancelSearch")
    }
}
