//
//  CategoryLimit+CoreDataProperties.swift
//  
//
//  Created by Denys Meloshyn on 15.01.17.
//
//

import Foundation
import CoreData


extension CategoryLimit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryLimit> {
        return NSFetchRequest<CategoryLimit>(entityName: "CategoryLimit");
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var limit: Double
    @NSManaged public var category: Category?

}
