//
//  UserGroup+CoreDataProperties.swift
//
//
//  Created by Denys Meloshyn on 28.07.17.
//
//

import CoreData
import Foundation

public extension UserGroup {
    @nonobjc class func fetchRequest() -> NSFetchRequest<UserGroup> {
        return NSFetchRequest<UserGroup>(entityName: "UserGroup")
    }

    @NSManaged var group: Budget?
    @NSManaged var user: User?
}
