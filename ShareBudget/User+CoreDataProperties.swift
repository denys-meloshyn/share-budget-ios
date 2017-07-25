//
//  User+CoreDataProperties.swift
//  
//
//  Created by Denys Meloshyn on 25.07.17.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var group: NSSet?
    @NSManaged public var userGroup: UserGroup?

}

// MARK: Generated accessors for group
extension User {

    @objc(addGroupObject:)
    @NSManaged public func addToGroup(_ value: Budget)

    @objc(removeGroupObject:)
    @NSManaged public func removeFromGroup(_ value: Budget)

    @objc(addGroup:)
    @NSManaged public func addToGroup(_ values: NSSet)

    @objc(removeGroup:)
    @NSManaged public func removeFromGroup(_ values: NSSet)

}
