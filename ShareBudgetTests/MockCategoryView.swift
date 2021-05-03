//
//  MockCategoryView.swift
//  ShareBudgetTests
//
//  Created by Denys Meloshyn on 31.08.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

@testable import ShareBudget
import UIKit

class MockCategoryView<T: CategoryPresenterProtocol>: CategoryView<T> {
    let calledMethodManager = CalledMethodManager()
}
