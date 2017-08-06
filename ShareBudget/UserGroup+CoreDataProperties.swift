//
//  UserGroup+CoreDataProperties.swift
//  
//
//  Created by Denys Meloshyn on 28.07.17.
//
//

import Foundation
import CoreData


extension UserGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserGroup> {
        return NSFetchRequest<UserGroup>(entityName: "UserGroup")
    }

    @NSManaged public var group: Budget?
    @NSManaged public var user: User?

}
