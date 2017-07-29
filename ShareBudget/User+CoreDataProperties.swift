//
//  User+CoreDataProperties.swift
//  
//
//  Created by Denys Meloshyn on 28.07.17.
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
    @NSManaged public var userGroup: NSSet?

}

// MARK: Generated accessors for userGroup
extension User {

    @objc(addUserGroupObject:)
    @NSManaged public func addToUserGroup(_ value: UserGroup)

    @objc(removeUserGroupObject:)
    @NSManaged public func removeFromUserGroup(_ value: UserGroup)

    @objc(addUserGroup:)
    @NSManaged public func addToUserGroup(_ values: NSSet)

    @objc(removeUserGroup:)
    @NSManaged public func removeFromUserGroup(_ values: NSSet)

}
