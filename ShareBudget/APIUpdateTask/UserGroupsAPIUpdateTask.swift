//
// Created by Denys Meloshyn on 25/09/2019.
// Copyright (c) 2019 Denys Meloshyn. All rights reserved.
//

import Foundation

import CoreData

class UserGroupsAPIUpdateTask: APIUpdateTask, APIUpdateTaskProtocol {
    let timeStampStorageManager = TimeStampStorageManager(key: .userGroup)

    var endpointURLBuilder: URL.Builder {
        restApiURLBuilder.appendPath("user").appendPath("group")
    }

    func parseUpdates(items: [[String: Any?]], in managedObjectContext: NSManagedObjectContext) {
        for item in items {
            let userGroup = ModelManager.findOrCreateEntity(UserGroup.self, response: item, in: managedObjectContext) as? UserGroup
            userGroup?.update(with: item, in: managedObjectContext)
        }
    }
}
