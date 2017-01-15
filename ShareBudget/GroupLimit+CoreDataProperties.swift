//
//  GroupLimit+CoreDataProperties.swift
//  
//
//  Created by Denys Meloshyn on 15.01.17.
//
//

import Foundation
import CoreData


extension GroupLimit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroupLimit> {
        return NSFetchRequest<GroupLimit>(entityName: "GroupLimit");
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var limit: Double
    @NSManaged public var group: Group?

}
