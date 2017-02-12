//
//  Expense+CoreDataProperties.swift
//  
//
//  Created by Denys Meloshyn on 12.02.17.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense");
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var creationDate: NSDate?
    @NSManaged public var budget: Budget?

}
