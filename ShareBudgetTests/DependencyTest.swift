//
//  DependencyTest.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 04.06.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import Nimble
import XCGLogger
import XCTest

@testable import ShareBudget

class DependencyTest: XCTestCase {
    override func tearDown() {
        MockDependency.reset()

        super.tearDown()
    }

    func testDevelopmentLocalNoRemoteLogger() {
        MockDependency.mockEnvironment = .developmentLocal
        MockDependency.configure()

        let destination = MockDependency.logger.destination(withIdentifier: Dependency.loggerRemoteIdentifier)
        expect(destination).to(beNil())
    }

    func testDataBaseNameTesting() {
        MockDependency.mockEnvironment = .testing
        MockDependency.configure()

        expect(MockDependency.coreDataName) == "ShareBudgetTest"
    }

    func testDataBaseNameProduction() {
        MockDependency.mockEnvironment = .production
        MockDependency.configure()

        expect(MockDependency.coreDataName) == "ShareBudget"
    }
}
