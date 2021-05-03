//
//  CategoryLimit+CoreDataProperties.swift
//
//
//  Created by Denys Meloshyn on 28.07.17.
//
//

import CoreData
import Foundation

public extension CategoryLimit {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CategoryLimit> {
        return NSFetchRequest<CategoryLimit>(entityName: "CategoryLimit")
    }

    @NSManaged var date: NSDate?
    @NSManaged var limit: NSNumber?
    @NSManaged var category: Category?
}
