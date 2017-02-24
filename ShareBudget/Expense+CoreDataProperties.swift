//
//  Expense+CoreDataProperties.swift
//  
//
//  Created by Denys Meloshyn on 24.02.17.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense");
    }

    @NSManaged public var creationDate: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var budget: Budget?
    @NSManaged public var category: Category?

}
