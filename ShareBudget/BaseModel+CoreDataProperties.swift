//
//  BaseModel+CoreDataProperties.swift
//  
//
//  Created by Denys Meloshyn on 02.03.17.
//
//

import Foundation
import CoreData


extension BaseModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BaseModel> {
        return NSFetchRequest<BaseModel>(entityName: "BaseModel");
    }

    @NSManaged public var internalID: Int64
    @NSManaged public var isChanged: Bool
    @NSManaged public var isRemoved: Bool
    @NSManaged public var modelID: NSNumber?
    @NSManaged public var timestamp: String?

}
