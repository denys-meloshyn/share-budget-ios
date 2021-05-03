//
//  URLRequestUserCredentialsTest.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.08.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import Nimble
@testable import ShareBudget
import XCTest

class URLRequestUserCredentialsTest: XCTestCase {
    var urlRequest: URLRequest!

    override func setUp() {
        super.setUp()

        Dependency.configure()
        Dependency.userCredentials.userID = "-100"

        urlRequest = URLRequest(url: URL(fileURLWithPath: "google.com"))
    }

    func testUserCredentialsNotAdded() {
        expect(self.urlRequest.allHTTPHeaderFields?[Constants.key.json.token]).to(beNil())
        expect(self.urlRequest.allHTTPHeaderFields?[Constants.key.json.userID]).to(beNil())
        expect(self.urlRequest.allHTTPHeaderFields?[Constants.key.json.timeStamp]).to(beNil())
    }
}
