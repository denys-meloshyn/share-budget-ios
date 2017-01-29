//
//  BudgetLimit+CoreDataProperties.swift
//  
//
//  Created by Denys Meloshyn on 29.01.17.
//
//

import Foundation
import CoreData


extension BudgetLimit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BudgetLimit> {
        return NSFetchRequest<BudgetLimit>(entityName: "BudgetLimit");
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var limit: Double
    @NSManaged public var budget: Budget?

}
