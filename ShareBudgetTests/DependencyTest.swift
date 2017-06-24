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
    override func setUp() {
        
    }
    
    override func tearDown() {
        MockDependency.logger = nil
    }
    
    func testDevelopmentLocalNoRemoteLogger() {
        MockDependency.mock_environment = .developmentLocal
        MockDependency.configure()
        
        let destination = MockDependency.logger.destination(withIdentifier: Dependency.loggerRemoteIdentifier)
        expect(destination).to(beNil())
    }
    
    func testDevelopmentLocalBackendConnection() {
        MockDependency.mock_environment = .developmentLocal
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
        MockDependency.mock_environment = .developmentRemote
        MockDependency.configure()
        
        let expectedComponents = NSURLComponents()
        expectedComponents.scheme = "https"
        expectedComponents.host = "sharebudget-development.herokuapp.com"        
        
        let result = MockDependency.backendConnection
        
        expect(result.scheme) == expectedComponents.scheme
        expect(result.host) == expectedComponents.host
    }
}
