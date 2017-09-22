//
//  MockBudgetPresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 18.05.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//
import UIKit
@testable import ShareBudget

class MockBudgetPresenter: BudgetPresenter {
    let calledMethodManager = CalledMethodManager()
    
    @objc override func startListenKeyboardNotifications() {
        let key = #selector(MockBudgetPresenter.startListenKeyboardNotifications)
        calledMethodManager.add(key)
    }
    
    @objc override func stopListenKeyboardNotifications() {
        let key = #selector(MockBudgetPresenter.stopListenKeyboardNotifications)
        calledMethodManager.add(key)
    }
}
