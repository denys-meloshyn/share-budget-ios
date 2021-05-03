//
//  Category+CoreDataProperties.swift
//
//
//  Created by Denys Meloshyn on 28.07.17.
//
//

import CoreData
import Foundation

public extension Category {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged var name: String?
    @NSManaged var budget: Budget?
    @NSManaged var expenses: NSSet?
    @NSManaged var limits: NSSet?
}

// MARK: Generated accessors for expenses

public extension Category {
    @objc(addExpensesObject:)
    @NSManaged func addToExpenses(_ value: Expense)

    @objc(removeExpensesObject:)
    @NSManaged func removeFromExpenses(_ value: Expense)

    @objc(addExpenses:)
    @NSManaged func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged func removeFromExpenses(_ values: NSSet)
}

// MARK: Generated accessors for limits

public extension Category {
    @objc(addLimitsObject:)
    @NSManaged func addToLimits(_ value: CategoryLimit)

    @objc(removeLimitsObject:)
    @NSManaged func removeFromLimits(_ value: CategoryLimit)

    @objc(addLimits:)
    @NSManaged func addToLimits(_ values: NSSet)

    @objc(removeLimits:)
    @NSManaged func removeFromLimits(_ values: NSSet)
}
