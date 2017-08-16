//
//  URLRequestUserCredentialsTest.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.08.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import XCTest
import Nimble
@testable import ShareBudget

class URLRequestUserCredentialsTest: XCTestCase {
    var urlRequest: URLRequest!
    
    override func setUp() {
        super.setUp()
        
        Dependency.configure()
        Dependency.userCredentials.userID = -100
        Dependency.userCredentials.token = "token"
        
        self.urlRequest = URLRequest(url: URL(fileURLWithPath: "google.com"))
    }
    
    func testUserCredentialsNotAdded() {
        expect(self.urlRequest.allHTTPHeaderFields?[kToken]).to(beNil())
        expect(self.urlRequest.allHTTPHeaderFields?[kUserID]).to(beNil())
        expect(self.urlRequest.allHTTPHeaderFields?[kTimeStamp]).to(beNil())
    }
    
    func testAddToken() {
        self.urlRequest.addToken()
        
        expect(self.urlRequest.allHTTPHeaderFields?[kToken]) == "token"
    }
    
    func testTokenAddedTwice() {
        self.urlRequest.addToken()
        self.urlRequest.addToken()
        
        expect(self.urlRequest.allHTTPHeaderFields?[kToken]) == "token"
    }
    
    func testAddUpdateCredentialsWithEmptyTimeStamp() {
        self.urlRequest.addUpdateCredentials(timestamp: "")
        
        expect(self.urlRequest.allHTTPHeaderFields?[kToken]) == "token"
        expect(Int(self.urlRequest.allHTTPHeaderFields![kUserID]!)) == -100
        expect(self.urlRequest.allHTTPHeaderFields?[kTimeStamp]).to(beNil())
    }
    
    func testAddUpdateCredentialsWithEmpty() {
        self.urlRequest.addUpdateCredentials(timestamp: "timestamp")
        
        expect(self.urlRequest.allHTTPHeaderFields?[kToken]) == "token"
        expect(Int(self.urlRequest.allHTTPHeaderFields![kUserID]!)) == -100
        expect(self.urlRequest.allHTTPHeaderFields?[kTimeStamp]) == "timestamp"
    }
}
