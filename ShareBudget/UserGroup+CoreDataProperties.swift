//
//  UserGroup+CoreDataProperties.swift
//  
//
//  Created by Denys Meloshyn on 25.07.17.
//
//

import Foundation
import CoreData


extension UserGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserGroup> {
        return NSFetchRequest<UserGroup>(entityName: "UserGroup")
    }

    @NSManaged public var user: NSSet?
    @NSManaged public var group: NSSet?

}

// MARK: Generated accessors for user
extension UserGroup {

    @objc(addUserObject:)
    @NSManaged public func addToUser(_ value: User)

    @objc(removeUserObject:)
    @NSManaged public func removeFromUser(_ value: User)

    @objc(addUser:)
    @NSManaged public func addToUser(_ values: NSSet)

    @objc(removeUser:)
    @NSManaged public func removeFromUser(_ values: NSSet)

}

// MARK: Generated accessors for group
extension UserGroup {

    @objc(addGroupObject:)
    @NSManaged public func addToGroup(_ value: Budget)

    @objc(removeGroupObject:)
    @NSManaged public func removeFromGroup(_ value: Budget)

    @objc(addGroup:)
    @NSManaged public func addToGroup(_ values: NSSet)

    @objc(removeGroup:)
    @NSManaged public func removeFromGroup(_ values: NSSet)

}
