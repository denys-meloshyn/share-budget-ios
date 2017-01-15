//
//  Group+CoreDataProperties.swift
//  
//
//  Created by Denys Meloshyn on 15.01.17.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group");
    }

    @NSManaged public var name: String?
    @NSManaged public var categories: Category?
    @NSManaged public var expenses: NSSet?
    @NSManaged public var limits: NSSet?
    @NSManaged public var users: NSSet?

}

// MARK: Generated accessors for expenses
extension Group {

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
extension Group {

    @objc(addLimitsObject:)
    @NSManaged public func addToLimits(_ value: GroupLimit)

    @objc(removeLimitsObject:)
    @NSManaged public func removeFromLimits(_ value: GroupLimit)

    @objc(addLimits:)
    @NSManaged public func addToLimits(_ values: NSSet)

    @objc(removeLimits:)
    @NSManaged public func removeFromLimits(_ values: NSSet)

}

// MARK: Generated accessors for users
extension Group {

    @objc(addUsersObject:)
    @NSManaged public func addToUsers(_ value: User)

    @objc(removeUsersObject:)
    @NSManaged public func removeFromUsers(_ value: User)

    @objc(addUsers:)
    @NSManaged public func addToUsers(_ values: NSSet)

    @objc(removeUsers:)
    @NSManaged public func removeFromUsers(_ values: NSSet)

}
