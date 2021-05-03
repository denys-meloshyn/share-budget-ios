//
//  BudgetLimit+CoreDataProperties.swift
//
//
//  Created by Denys Meloshyn on 28.07.17.
//
//

import CoreData
import Foundation

public extension BudgetLimit {
    @nonobjc class func fetchRequest() -> NSFetchRequest<BudgetLimit> {
        return NSFetchRequest<BudgetLimit>(entityName: "BudgetLimit")
    }

    @NSManaged var date: NSDate?
    @NSManaged var limit: NSNumber?
    @NSManaged var budget: Budget?
}
