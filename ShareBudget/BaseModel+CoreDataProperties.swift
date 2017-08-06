//
//  BaseModel+CoreDataProperties.swift
//  
//
//  Created by Denys Meloshyn on 28.07.17.
//
//

import Foundation
import CoreData


extension BaseModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BaseModel> {
        return NSFetchRequest<BaseModel>(entityName: "BaseModel")
    }

    @NSManaged public var internalID: NSNumber?
    @NSManaged public var isChanged: NSNumber?
    @NSManaged public var isRemoved: NSNumber?
    @NSManaged public var modelID: NSNumber?
    @NSManaged public var timestamp: String?

}
