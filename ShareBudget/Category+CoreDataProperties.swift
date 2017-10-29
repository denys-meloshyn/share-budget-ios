//
//  Category+CoreDataProperties.swift
//  
//
//  Created by Denys Meloshyn on 28.07.17.
//
//

import Foundation
import CoreData

extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String?
    @NSManaged public var budget: Budget?
    @NSManaged public var expenses: NSSet?
    @NSManaged public var limits: NSSet?

}

// MARK: Generated accessors for expenses
extension Category {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: Expense)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: Expense)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}

// MARK: Generated accessors for limits
extension Category {

    @objc(addLimitsObject:)
    @NSManaged public func addToLimits(_ value: CategoryLimit)

    @objc(removeLimitsObject:)
    @NSManaged public func removeFromLimits(_ value: CategoryLimit)

    @objc(addLimits:)
    @NSManaged public func addToLimits(_ values: NSSet)

    @objc(removeLimits:)
    @NSManaged public func removeFromLimits(_ values: NSSet)

}
