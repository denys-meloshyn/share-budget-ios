//
//  User+CoreDataProperties.swift
//
//
//  Created by Denys Meloshyn on 28.07.17.
//
//

import CoreData
import Foundation

public extension User {
    @nonobjc class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged var email: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var userGroup: NSSet?
}

// MARK: Generated accessors for userGroup

public extension User {
    @objc(addUserGroupObject:)
    @NSManaged func addToUserGroup(_ value: UserGroup)

    @objc(removeUserGroupObject:)
    @NSManaged func removeFromUserGroup(_ value: UserGroup)

    @objc(addUserGroup:)
    @NSManaged func addToUserGroup(_ values: NSSet)

    @objc(removeUserGroup:)
    @NSManaged func removeFromUserGroup(_ values: NSSet)
}
