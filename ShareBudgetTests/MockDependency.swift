//
//  MockDependency.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 04.06.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

@testable import ShareBudget

class MockDependency: Dependency {
    static var mockEnvironment = Environment.developmentLocal

    class func reset() {
        logger = nil
        coreDataName = nil
        userCredentials = nil
        backendURLComponents = nil
    }

    override class func environment() -> Environment {
        return mockEnvironment
    }
}
