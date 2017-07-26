//
//  UserGroup+CoreDataClass.swift
//  
//
//  Created by Denys Meloshyn on 25.07.17.
//
//

import Foundation
import CoreData

@objc(UserGroup)
public class UserGroup: BaseModel {
    override class func modelKeyID() -> String {
        return kUserGroupID
    }
    
    override func update(with dict: [String: AnyObject?], in managedObjectContext: NSManagedObjectContext) {
        super.update(with: dict, in: managedObjectContext)
        self.configureModelID(dict: dict, for: kExpenseID)
        
    }
    
    override func uploadProperties() -> [String : String] {
        var result = super.uploadProperties()
        
        
        return result
    }
}
