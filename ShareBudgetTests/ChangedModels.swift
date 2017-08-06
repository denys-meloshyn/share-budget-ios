//
//  ChangedModels.swift
//  ShareBudgetTests
//
//  Created by Denys Meloshyn on 06.08.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import XCTest
import Nimble
import CoreData
@testable import ShareBudget

class ChangedModels: XCTestCase {
    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    override func setUp() {
        super.setUp()
        
        self.managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)
    }
    
    override func tearDown() {
        ModelManager.dropAllEntities()
        
        super.tearDown()
    }
    
    func testNoChanged() {
        let _ = Expense(context: self.managedObjectContext)
        let _ = Budget(context: self.managedObjectContext)
        
        ModelManager.saveContext(self.managedObjectContext)
        self.fetchedResultsController = ModelManager.changedModels(Expense.self, self.managedObjectContext)
        self.fetchedResultsController.performSilentFailureFetch()
        
        expect(self.fetchedResultsController.numberOfObjects()) == 0
    }
    
    func testOneChanged() {
        let expense = Expense(context: self.managedObjectContext)
        expense.isChanged = NSNumber(value: true)
        
        let _ = Budget(context: self.managedObjectContext)
        
        ModelManager.saveContext(self.managedObjectContext)
        self.fetchedResultsController = ModelManager.changedModels(Expense.self, self.managedObjectContext)
        self.fetchedResultsController.performSilentFailureFetch()
        
        expect(self.fetchedResultsController.numberOfObjects()) == 1
    }
}
