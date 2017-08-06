//
//  CategoryLimit+CoreDataProperties.swift
//  
//
//  Created by Denys Meloshyn on 28.07.17.
//
//

import Foundation
import CoreData


extension CategoryLimit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryLimit> {
        return NSFetchRequest<CategoryLimit>(entityName: "CategoryLimit")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var limit: NSNumber?
    @NSManaged public var category: Category?

}
