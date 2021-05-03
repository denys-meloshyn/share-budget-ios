//
//  ValidatorTest.swift
//  ShareBudgetTests
//
//  Created by Denys Meloshyn on 17.06.2018.
//  Copyright © 2018 Denys Meloshyn. All rights reserved.
//

import XCTest

import Nimble
@testable import ShareBudget

class ValidatorTest: XCTestCase {
    func testEmailCorrect() {
        expect(Validator.email("denys@gmail.com")) == true
    }

    func testEmailWrong() {
        expect(Validator.email("denys@gmail.c")) == false
    }

    func testPasswordCorrect() {
        expect(Validator.password("111111")) == true
    }

    func testPasswordWrong() {
        expect(Validator.password("")) == false
    }

    func testRepeatPasswordCorrect() {
        expect(Validator.repeatPassword(password: "1", repeat: "1")) == true
    }

    func testRepeatPasswordWrong() {
        expect(Validator.repeatPassword(password: "1", repeat: "2")) == false
    }

    func testFirstNameCorrect() {
        expect(Validator.firstName("Test")) == true
    }

    func testFirstNameWrong() {
        expect(Validator.firstName("    ")) == false
    }

    func testIsNumberValidCorrect() {
        expect(Validator.isNumberValid("123.5")) == true
    }

    func testIsNumberValidWrong() {
        expect(Validator.isNumberValid("Test")) == false
    }

    func testRemoveWhiteSpaces() {
        expect(Validator.removeWhiteSpaces("      ")) == ""
    }

    func testIsNullOrBlankNull() {
        expect(Validator.isNullOrBlank(nil)) == true
    }

    func testIsNullOrBlankEmpty() {
        expect(Validator.isNullOrBlank("")) == true
    }

    func testIsNullOrBlankNotEmpty() {
        expect(Validator.isNullOrBlank("Test")) == false
    }
}
