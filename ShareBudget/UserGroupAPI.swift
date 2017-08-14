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
    
    override func parseUpdates(items: [[String: Any?]], in managedObjectContext: NSManagedObjectContext) {
        var userGroup: UserGroup?
        
        for item in items {
            userGroup = ModelManager.findOrCreateEntity(UserGroup.self, response: item, in: managedObjectContext) as? UserGroup
            userGroup?.update(with: item, in: managedObjectContext)
        }
    }
    
    override func allChangedModels(completionBlock: APIResultBlock?) -> [BaseAPITask] {
        let managedObjectContext = ModelManager.managedObjectContext
        let tasks = ModelManager.changedTasks(modelEntity: UserGroup.self,
                                              apiEntity: self,
                                              resource: "user/group",
                                              managedObjectContext: managedObjectContext,
                                              completionBlock: completionBlock)
        return tasks
    }
}
