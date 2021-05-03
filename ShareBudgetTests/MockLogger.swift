//
//  MockLogger.swift
//  ShareBudgetTests
//
//  Created by Denys Meloshyn on 16.06.2018.
//  Copyright © 2018 Denys Meloshyn. All rights reserved.
//

@testable import ShareBudget

class MockLogger: LoggerProtocol {
    func logError(_: String) {}
}
