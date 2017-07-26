//
//  UserGroupAPI.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 21.07.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData

class UserGroupAPI: BaseAPI {
    override func timestampStorageKey() -> String {
        return "user_group_timestamp"
    }
    
    override func parseUpdates(items: [[String: AnyObject?]], in managedObjectContext: NSManagedObjectContext) {
        var user: User?
        var group: Budget?
        var userGroup: UserGroup?
        
        for item in items {
            if let modelID = item[UserGroup.modelKeyID()] as? Int {
                userGroup = ModelManager.findEntity(UserGroup.self, by: modelID, in: managedObjectContext) as? UserGroup
            }
            
            if userGroup == nil {
                userGroup = UserGroup(context: managedObjectContext)
            }
            
            if let userID = item[User.modelKeyID()] as? Int {
                user = ModelManager.findEntity(User.self, by: userID, in: managedObjectContext) as? User
            }
            
            if let groupID = item[Budget.modelKeyID()] as? Int {
                group = ModelManager.findEntity(Budget.self, by: groupID, in: managedObjectContext) as? Budget
            }
            
            guard let user = user, let group = group else {
                continue
            }
            
            
        }
    }
}
