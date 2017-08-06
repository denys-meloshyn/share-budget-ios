//
//  FindOrCreateEntity.swift
//  ShareBudgetTests
//
//  Created by Denys Meloshyn on 04.08.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import XCTest
import Nimble
import CoreData
@testable import ShareBudget

class FindOrCreateEntity: XCTestCase {
    var managedObjectContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        self.managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)
    }
    
    override func tearDown() {
        ModelManager.dropAllEntities()
        
        super.tearDown()
    }
    
    func testEntityNotExistDataBaseEmptyResponseEmpty() {
        let result = ModelManager.findOrCreateEntity(Expense.self, response: [:], in: self.managedObjectContext)
        
        expect(result).notTo(beNil())
        expect(result.modelID).to(beNil())
    }
    
    func testEntityNotExistDataBaseEmpty() {
        let result = ModelManager.findOrCreateEntity(Expense.self,
                                                     response: [Expense.modelKeyID():1],
                                                     in: self.managedObjectContext)
        
        expect(result).notTo(beNil())
        expect(result.modelID).to(beNil())
    }
    
    func testEntityNotExistResponseEmpty() {
        let expense = Expense(context: self.managedObjectContext)
        expense.modelID = NSNumber(value: 1)
        ModelManager.saveContext(self.managedObjectContext)
        
        let result = ModelManager.findOrCreateEntity(Expense.self, response: [:], in: self.managedObjectContext)
        
        expect(result).notTo(beNil())
        expect(result.modelID).to(beNil())
    }
    
    func testEntityNotExist() {
        let expense = Expense(context: self.managedObjectContext)
        expense.modelID = NSNumber(value: 1)
        ModelManager.saveContext(self.managedObjectContext)
        
        let result = ModelManager.findOrCreateEntity(Expense.self,
                                                     response: [Expense.modelKeyID():2],
                                                     in: self.managedObjectContext)
        
        expect(result).notTo(beNil())
        expect(result.modelID).to(beNil())
    }
    
    func testEntityExist() {
        let expense = Expense(context: self.managedObjectContext)
        expense.modelID = NSNumber(value: 1)
        ModelManager.saveContext(self.managedObjectContext)
        
        let result = ModelManager.findOrCreateEntity(Expense.self,
                                                     response: [Expense.modelKeyID():1],
                                                     in: self.managedObjectContext)
        
        expect(result.modelID).notTo(beNil())
    }
}
