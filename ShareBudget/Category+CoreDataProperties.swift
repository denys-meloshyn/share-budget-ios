//
//  Category+CoreDataProperties.swift
//  
//
//  Created by Denys Meloshyn on 15.01.17.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category");
    }

    @NSManaged public var name: String?
    @NSManaged public var group: Group?
    @NSManaged public var limits: NSSet?

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
