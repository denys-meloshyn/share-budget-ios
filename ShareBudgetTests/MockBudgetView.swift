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
    var calledMethods = [String: Any]()
    
    override func showTabBar(title: String, image: UIImage, selected: UIImage) {
        let key = #selector(MockBudgetView.showTabBar(title:image:selected:))
        calledMethods[key.description] = [title, image, selected]
    }
    
    override func showPage(title: String?) {
        let key = #selector(MockBudgetView.showPage(title:))
        calledMethods[key.description] = [title ?? ""]
    }
    
    override func showCreateNewGroupMessage(message: NSAttributedString) {
        let key = #selector(MockBudgetView.showCreateNewGroupMessage(message:))
        calledMethods[key.description] = [message]
    }
    
    override func showGroupList() {
        let key = #selector(MockBudgetView.showGroupList)
        calledMethods[key.description] = []
    }
}
