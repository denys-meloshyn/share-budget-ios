//
//  DependencyTest.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 04.06.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import XCTest
import Nimble
import XCGLogger

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
    
    func testDevelopmentLocalBackendConnection() {
        MockDependency.mockEnvironment = .developmentLocal
        MockDependency.configure()
        
        let expectedComponents = NSURLComponents()
        expectedComponents.scheme = "http"
        expectedComponents.host = "127.0.0.1"
        expectedComponents.port = 5000
        
        let result = MockDependency.backendConnection
        
        expect(result.scheme) == expectedComponents.scheme
        expect(result.host) == expectedComponents.host
        expect(result.port) == expectedComponents.port
    }
    
    func testDevelopmentRemoteBackendConnection() {
        MockDependency.mockEnvironment = .developmentRemote
        MockDependency.configure()
        
        let expectedComponents = NSURLComponents()
        expectedComponents.scheme = "https"
        expectedComponents.host = "sharebudget-development.herokuapp.com"        
        
        let result = MockDependency.backendConnection
        
        expect(result.scheme) == expectedComponents.scheme
        expect(result.host) == expectedComponents.host
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
