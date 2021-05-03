//
//  Expense+CoreDataProperties.swift
//
//
//  Created by Denys Meloshyn on 10.06.2018.
//
//

import CoreData
import Foundation

public extension Expense {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged var creationDate: NSDate?
    @NSManaged var name: String?
    @NSManaged var price: NSNumber?
    @NSManaged var sectionCreationDate: String?
    @NSManaged var creationDateSearch: String?
    @NSManaged var budget: Budget?
    @NSManaged var category: Category?
}
