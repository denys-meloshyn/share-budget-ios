//
//  BudgetLimit+CoreDataProperties.swift
//  
//
//  Created by Denys Meloshyn on 28.07.17.
//
//

import Foundation
import CoreData


extension BudgetLimit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BudgetLimit> {
        return NSFetchRequest<BudgetLimit>(entityName: "BudgetLimit")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var limit: NSNumber?
    @NSManaged public var budget: Budget?

}
