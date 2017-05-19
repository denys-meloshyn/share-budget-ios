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
    
    override func showCreateNewGroupMessage(message: NSAttributedString) {
        let key = #selector(MockBudgetView.showCreateNewGroupMessage(message:))
        calledMethodManager.add(key)
    }
    
    override func showGroupList() {
        let key = #selector(MockBudgetView.showGroupList)
        calledMethodManager.add(key)
    }
    
    override func refreshData(for mode: BudgetHeaderMode) {
        let key = #selector(MockBudgetView.showGroupList)
        calledMethodManager.add(key)
    }
}
