//
//  ShareBudgetUITests.swift
//  ShareBudgetUITests
//
//  Created by Denys Meloshyn on 13.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import XCTest
@testable import ShareBudget

class ShareBudgetUITests: XCTestCase {
    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        // Since UI tests are more expensive to run, it's
        // usually a good idea to exit if a failure was encountered
        continueAfterFailure = false
        
        app = XCUIApplication()
        
        // We send a command line argument to our app,
        // to enable it to reset its state
//        app.launchArguments.append("--uitesting")
    }
    
    // MARK: - Tests
    
    func testGoingThroughOnboarding() {
        self.app.launchEnvironment = ["klaunchViewControllerID": "BudgetViewController"]
        self.app.launch()
        
//        let elementsQuery = XCUIApplication().scrollViews.otherElements
//        let eMailTextField = elementsQuery.textFields["E-mail"]
//        eMailTextField.tap()
//
//        let passwordSecureTextField = elementsQuery.secureTextFields["Password"]
//        passwordSecureTextField.tap()
//        elementsQuery.buttons["Don't have an account?"].tap()
//
//        let repeatPasswordSecureTextField = elementsQuery.secureTextFields["Repeat password"]
//        repeatPasswordSecureTextField.tap()
//        passwordSecureTextField.tap()
//        elementsQuery.textFields["Last name"].tap()
//        eMailTextField.tap()
//        passwordSecureTextField.tap()
//        repeatPasswordSecureTextField.tap()

        
    }
}
