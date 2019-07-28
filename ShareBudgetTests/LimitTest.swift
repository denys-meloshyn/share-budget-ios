//
//  LastMonthLimitTest.swift
//  ShareBudgetTests
//
//  Created by Denys Meloshyn on 10.08.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import XCTest
import Nimble
import CoreData
@testable import ShareBudget

class LimitTest: XCTestCase {
    var budget: Budget!
    var managedObjectContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        Dependency.configure()
        self.managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)
        self.budget = Budget(context: self.managedObjectContext)
    }
    
    override func tearDown() {
        ModelManager.dropAllEntities()
        
        super.tearDown()
    }
    
    func testBudgetLimitNotExist() {
        ModelManager.saveContext(self.managedObjectContext)
        let result = ModelManager.lastLimit(for: self.budget.objectID, self.managedObjectContext)
        expect(result).to(beNil())
    }
    
    func testBudgetLimitOneExist() {
        let limit = BudgetLimit(context: self.managedObjectContext)
        limit.date = NSDate()
        limit.limit = NSNumber(value: 100.0)
        self.budget.addToLimits(limit)
        ModelManager.saveContext(self.managedObjectContext)

        let result = ModelManager.lastLimit(for: self.budget.objectID, self.managedObjectContext)
        expect(result?.limit) == 100.0
    }

    func testBudgetLimitMultipleExist() {
        var limit = BudgetLimit(context: self.managedObjectContext)
        limit.date = NSDate()
        limit.limit = NSNumber(value: 100.0)
        self.budget.addToLimits(limit)

        limit = BudgetLimit(context: self.managedObjectContext)
        limit.date = NSDate()
        limit.limit = NSNumber(value: 200.0)
        self.budget.addToLimits(limit)
        ModelManager.saveContext(self.managedObjectContext)

        let result = ModelManager.lastLimit(for: self.budget.objectID, self.managedObjectContext)
        expect(result?.limit) == 200.0
    }
    
    func testLimitForExistedDate() {
        var dateComponents = UtilityFormatter.calendarComponentTilDay()
        dateComponents.year = 2017
        dateComponents.day = 15
        
        dateComponents.month = 3
        var limit = BudgetLimit(context: self.managedObjectContext)
        limit.date = dateComponents.date as NSDate?
        limit.limit = 100.0
        self.budget.addToLimits(limit)
        
        dateComponents.month = 1
        limit = BudgetLimit(context: self.managedObjectContext)
        limit.date = dateComponents.date as NSDate?
        limit.limit = 200.0
        self.budget.addToLimits(limit)
        ModelManager.saveContext(self.managedObjectContext)
        
        dateComponents.month = 2
        let result = ModelManager.lastLimit(for: self.budget.objectID, date: dateComponents.date as! NSDate, self.managedObjectContext)
        expect(result?.limit) == 200.0
    }
    
    func testLastLimitRemoved() {
        var dateComponents = UtilityFormatter.calendarComponentTilDay()
        dateComponents.year = 2017
        dateComponents.day = 15
        
        dateComponents.month = 3
        var limit = BudgetLimit(context: self.managedObjectContext)
        limit.date = dateComponents.date as NSDate?
        limit.limit = 100.0
        self.budget.addToLimits(limit)
        
        dateComponents.month = 1
        limit = BudgetLimit(context: self.managedObjectContext)
        limit.date = dateComponents.date as NSDate?
        limit.limit = 200.0
        limit.isRemoved = true
        self.budget.addToLimits(limit)
        ModelManager.saveContext(self.managedObjectContext)
        
        dateComponents.month = 2
        let result = ModelManager.lastLimit(for: self.budget.objectID, date: dateComponents.date as! NSDate, self.managedObjectContext)
        expect(result).to(beNil())
    }
}
