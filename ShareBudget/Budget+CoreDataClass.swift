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
        Constants.key.json.groupID
    }
    
    override func update(with dict: [String: Any?], in managedObjectContext: NSManagedObjectContext) {
        super.update(with: dict, in: managedObjectContext)
        self.configureModelID(dict: dict, for: Constants.key.json.groupID)
        
        self.name = dict[Constants.key.json.name] as? String
    }
    
    override func uploadProperties() -> [String: String] {
        var result = super.uploadProperties()
        
        if let modelID = self.modelID {
            result[Constants.key.json.groupID] = String(modelID.intValue)
        }
        
        if let name = self.name {
            result[Constants.key.json.name] = name
        }
        
        return result
    }
}
