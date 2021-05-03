//
//  ChildrenManagedObjectContext.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 14.08.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData
import Nimble
@testable import ShareBudget
import XCTest

class ChildrenManagedObjectContext: XCTestCase {
    var primaryManagedObjectContext: NSManagedObjectContext!
    var secondaryManagedObjectContext: NSManagedObjectContext!

    override func setUp() {
        super.setUp()

        primaryManagedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)
        secondaryManagedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)
    }

    override func tearDown() {
        ModelManager.dropAllEntities()

        super.tearDown()
    }

    func testGetCopyInstanceFromAnotherContext() {
        let budget = Budget(context: secondaryManagedObjectContext)
        budget.name = "budget"

        let result = primaryManagedObjectContext.object(with: budget.objectID) as! Budget
        result.name = "result"

        expect(budget.managedObjectContext) != primaryManagedObjectContext
        expect(result) != budget
        expect(result).notTo(beNil())
        expect(budget.name) == "budget"
        expect(result.name) == "result"
    }
}
