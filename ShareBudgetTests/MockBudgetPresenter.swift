//
//  MockBudgetPresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 18.05.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//
import UIKit
@testable import ShareBudget

class MockBudgetPresenter<I: BudgetInteractionProtocol, R: BudgetRouterProtocol>: BudgetPresenter<I, R> {
    let calledMethodManager = CalledMethodManager()
    
    override func startListenKeyboardNotifications() {
        calledMethodManager.add("startListenKeyboardNotifications")
    }

    override func stopListenKeyboardNotifications() {
        calledMethodManager.add("stopListenKeyboardNotifications")
    }
}
