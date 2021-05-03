//
//  LastMonthLimitTest.swift
//  ShareBudgetTests
//
//  Created by Denys Meloshyn on 10.08.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData
import Nimble
@testable import ShareBudget
import XCTest

class LimitTest: XCTestCase {
    var budget: Budget!
    var managedObjectContext: NSManagedObjectContext!

    override func setUp() {
        super.setUp()

        Dependency.configure()
        managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)
        budget = Budget(context: managedObjectContext)
    }

    override func tearDown() {
        ModelManager.dropAllEntities()

        super.tearDown()
    }

    func testBudgetLimitNotExist() {
        ModelManager.saveContext(managedObjectContext)
        let result = ModelManager.lastLimit(for: budget.objectID, managedObjectContext)
        expect(result).to(beNil())
    }

    func testBudgetLimitOneExist() {
        let limit = BudgetLimit(context: managedObjectContext)
        limit.date = NSDate()
        limit.limit = NSNumber(value: 100.0)
        budget.addToLimits(limit)
        ModelManager.saveContext(managedObjectContext)

        let result = ModelManager.lastLimit(for: budget.objectID, managedObjectContext)
        expect(result?.limit) == 100.0
    }

    func testBudgetLimitMultipleExist() {
        var limit = BudgetLimit(context: managedObjectContext)
        limit.date = NSDate()
        limit.limit = NSNumber(value: 100.0)
        budget.addToLimits(limit)

        limit = BudgetLimit(context: managedObjectContext)
        limit.date = NSDate()
        limit.limit = NSNumber(value: 200.0)
        budget.addToLimits(limit)
        ModelManager.saveContext(managedObjectContext)

        let result = ModelManager.lastLimit(for: budget.objectID, managedObjectContext)
        expect(result?.limit) == 200.0
    }

    func testLimitForExistedDate() {
        var dateComponents = UtilityFormatter.calendarComponentTilDay()
        dateComponents.year = 2017
        dateComponents.day = 15

        dateComponents.month = 3
        var limit = BudgetLimit(context: managedObjectContext)
        limit.date = dateComponents.date as NSDate?
        limit.limit = 100.0
        budget.addToLimits(limit)

        dateComponents.month = 1
        limit = BudgetLimit(context: managedObjectContext)
        limit.date = dateComponents.date as NSDate?
        limit.limit = 200.0
        budget.addToLimits(limit)
        ModelManager.saveContext(managedObjectContext)

        dateComponents.month = 2
        let result = ModelManager.lastLimit(for: budget.objectID, date: dateComponents.date as! NSDate, managedObjectContext)
        expect(result?.limit) == 200.0
    }

    func testLastLimitRemoved() {
        var dateComponents = UtilityFormatter.calendarComponentTilDay()
        dateComponents.year = 2017
        dateComponents.day = 15

        dateComponents.month = 3
        var limit = BudgetLimit(context: managedObjectContext)
        limit.date = dateComponents.date as NSDate?
        limit.limit = 100.0
        budget.addToLimits(limit)

        dateComponents.month = 1
        limit = BudgetLimit(context: managedObjectContext)
        limit.date = dateComponents.date as NSDate?
        limit.limit = 200.0
        limit.isRemoved = true
        budget.addToLimits(limit)
        ModelManager.saveContext(managedObjectContext)

        dateComponents.month = 2
        let result = ModelManager.lastLimit(for: budget.objectID, date: dateComponents.date as! NSDate, managedObjectContext)
        expect(result).to(beNil())
    }
}
