//
//  Budget+CoreDataClass.swift
//  
//
//  Created by Denys Meloshyn on 29.01.17.
//
//

import Foundation
import CoreData

@objc(Budget)
public class Budget: BaseModel {
    override class func modelKeyID() -> String {
        return kGroupID
    }
    
    override func update(with dict: [String: AnyObject?], in managedObjectContext: NSManagedObjectContext) {
        super.update(with: dict, in: managedObjectContext)
        self.configureModelID(dict: dict, for: kGroupID)
        
        self.name = dict[kName] as? String
    }
    
    override func uploadProperties() -> [String : String] {
        var result = super.uploadProperties()
        
        if let modelID = self.modelID {
            result[kGroupID] = String(modelID.intValue)
        }
        
        if let name = self.name {
            result[kName] = name
        }
        
        return result
    }
}
