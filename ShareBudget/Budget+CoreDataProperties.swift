//
//  Budget+CoreDataProperties.swift
//  
//
//  Created by Denys Meloshyn on 28.07.17.
//
//

import Foundation
import CoreData


extension Budget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Budget> {
        return NSFetchRequest<Budget>(entityName: "Budget")
    }

    @NSManaged public var name: String?
    @NSManaged public var categories: NSSet?
    @NSManaged public var expenses: NSSet?
    @NSManaged public var limits: NSSet?
    @NSManaged public var userGroup: NSSet?

}

// MARK: Generated accessors for categories
extension Budget {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: Category)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: Category)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}

// MARK: Generated accessors for expenses
extension Budget {

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
extension Budget {

    @objc(addLimitsObject:)
    @NSManaged public func addToLimits(_ value: BudgetLimit)

    @objc(removeLimitsObject:)
    @NSManaged public func removeFromLimits(_ value: BudgetLimit)

    @objc(addLimits:)
    @NSManaged public func addToLimits(_ values: NSSet)

    @objc(removeLimits:)
    @NSManaged public func removeFromLimits(_ values: NSSet)

}

// MARK: Generated accessors for userGroup
extension Budget {

    @objc(addUserGroupObject:)
    @NSManaged public func addToUserGroup(_ value: UserGroup)

    @objc(removeUserGroupObject:)
    @NSManaged public func removeFromUserGroup(_ value: UserGroup)

    @objc(addUserGroup:)
    @NSManaged public func addToUserGroup(_ values: NSSet)

    @objc(removeUserGroup:)
    @NSManaged public func removeFromUserGroup(_ values: NSSet)

}
