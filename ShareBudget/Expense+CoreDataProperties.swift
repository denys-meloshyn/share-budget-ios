//
//  Expense+CoreDataProperties.swift
//  
//
//  Created by Denys Meloshyn on 28.07.17.
//
//

import Foundation
import CoreData

extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var creationDate: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var price: NSNumber?
    @NSManaged public var sectionCreationDate: String?
    @NSManaged public var budget: Budget?
    @NSManaged public var category: Category?

}
