//
//  MockCategoryRouter.swift
//  ShareBudgetTests
//
//  Created by Denys Meloshyn on 31.08.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
@testable import ShareBudget

class MockCategoryRouter: CategoryRouter {
    let calledMethodManager = CalledMethodManager()
    
    override func closePage() {
        super.closePage()
        
        calledMethodManager.add(#function)
    }
}
