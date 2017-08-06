//
//  MockDependency.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 04.06.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

@testable import ShareBudget

class MockDependency: Dependency {
    static var mock_environment = Environment.developmentLocal
    
    class func reset() {
        self.logger = nil
        self.coreDataName = nil
        self.userCredentials = nil
        self.backendURLComponents = nil
    }
    
    override class func environment() -> Environment {
        return mock_environment
    }
}
