//
//  Budget+CoreDataProperties.swift
//
//
//  Created by Denys Meloshyn on 28.07.17.
//
//

import CoreData
import Foundation

public extension Budget {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Budget> {
        return NSFetchRequest<Budget>(entityName: "Budget")
    }

    @NSManaged var name: String?
    @NSManaged var categories: NSSet?
    @NSManaged var expenses: NSSet?
    @NSManaged var limits: NSSet?
    @NSManaged var userGroup: NSSet?
}

// MARK: Generated accessors for categories

public extension Budget {
    @objc(addCategoriesObject:)
    @NSManaged func addToCategories(_ value: Category)

    @objc(removeCategoriesObject:)
    @NSManaged func removeFromCategories(_ value: Category)

    @objc(addCategories:)
    @NSManaged func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged func removeFromCategories(_ values: NSSet)
}

// MARK: Generated accessors for expenses

public extension Budget {
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

public extension Budget {
    @objc(addLimitsObject:)
    @NSManaged func addToLimits(_ value: BudgetLimit)

    @objc(removeLimitsObject:)
    @NSManaged func removeFromLimits(_ value: BudgetLimit)

    @objc(addLimits:)
    @NSManaged func addToLimits(_ values: NSSet)

    @objc(removeLimits:)
    @NSManaged func removeFromLimits(_ values: NSSet)
}

// MARK: Generated accessors for userGroup

public extension Budget {
    @objc(addUserGroupObject:)
    @NSManaged func addToUserGroup(_ value: UserGroup)

    @objc(removeUserGroupObject:)
    @NSManaged func removeFromUserGroup(_ value: UserGroup)

    @objc(addUserGroup:)
    @NSManaged func addToUserGroup(_ values: NSSet)

    @objc(removeUserGroup:)
    @NSManaged func removeFromUserGroup(_ values: NSSet)
}
