//
//  BaseModel+CoreDataProperties.swift
//
//
//  Created by Denys Meloshyn on 28.07.17.
//
//

import CoreData
import Foundation

public extension BaseModel {
    @nonobjc class func fetchRequest() -> NSFetchRequest<BaseModel> {
        return NSFetchRequest<BaseModel>(entityName: "BaseModel")
    }

    @NSManaged var internalID: NSNumber?
    @NSManaged var isChanged: NSNumber?
    @NSManaged var isRemoved: NSNumber?
    @NSManaged var modelID: NSNumber?
    @NSManaged var timestamp: String?
}
