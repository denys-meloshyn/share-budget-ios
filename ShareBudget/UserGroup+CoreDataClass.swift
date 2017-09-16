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
        return Constants.key.json.userGroupID
    }
    
    override func update(with dict: [String: Any?], in managedObjectContext: NSManagedObjectContext) {
        super.update(with: dict, in: managedObjectContext)
        self.configureModelID(dict: dict, for: Constants.key.json.userGroupID)
        
        if let userID = dict[Constants.key.json.userID] as? Int {
            self.user = ModelManager.findEntity(User.self, by: userID, in: managedObjectContext) as? User
            self.user?.addToUserGroup(self)
        }
        
        if let groupID = dict[Constants.key.json.groupID] as? Int {
            self.group = ModelManager.findEntity(Budget.self, by: groupID, in: managedObjectContext) as? Budget
            self.group?.addToUserGroup(self)
        }
    }
    
    override func uploadProperties() -> [String : String] {
        var result = super.uploadProperties()
        
        if let modelID = self.modelID {
            result[Constants.key.json.userGroupID] = String(modelID.intValue)
        }
        
        if let modelID = self.user?.modelID {
            result[Constants.key.json.userID] = String(modelID.intValue)
        }
        
        if let modelID = self.group?.modelID {
            result[Constants.key.json.groupID] = String(modelID.intValue)
        }
        
        return result
    }
}
