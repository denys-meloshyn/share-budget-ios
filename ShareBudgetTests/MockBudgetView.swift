//
//  MockBudgetView.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 18.05.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//
import UIKit
@testable import ShareBudget

class MockBudgetView: BudgetView {
    let calledMethodManager = CalledMethodManager()
    
    override func showTabBar(title: String, image: UIImage, selected: UIImage) {
        let key = #selector(MockBudgetView.showTabBar(title:image:selected:))
        calledMethodManager.add(key)
    }
    
    override func showPage(title: String?) {
        let key = #selector(MockBudgetView.showPage(title:))
        calledMethodManager.add(key)
    }
    
    @objc override func showCreateNewGroupMessage(message: NSAttributedString) {
        let key = #selector(MockBudgetView.showCreateNewGroupMessage(message:))
        calledMethodManager.add(key)
    }
    
    @objc override func showGroupList() {
        calledMethodManager.add(#selector(MockBudgetView.showGroupList))
    }
    
    override func refreshData(for mode: BudgetHeaderMode) {
        calledMethodManager.add(#selector(MockBudgetView.showGroupList))
    }
    
    @objc override func cancelSearch() {
        calledMethodManager.add(#selector(MockBudgetView.cancelSearch))
    }
}
