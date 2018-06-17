//
//  BaseRouterTest.swift
//  ShareBudgetTests
//
//  Created by Denys Meloshyn on 17.06.2018.
//  Copyright © 2018 Denys Meloshyn. All rights reserved.
//

import XCTest
import Nimble
@testable import ShareBudget

class BaseRouterTest: XCTestCase {
    func testClosePage() {
        let rootViewController = UIViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.pushViewController(UIViewController(), animated: false)
        
        let router = BaseRouter(with: rootViewController)
        expect(navigationController.viewControllers.count) == 2

        router.closePage()
        expect(navigationController.viewControllers.count) == 1
    }
}
