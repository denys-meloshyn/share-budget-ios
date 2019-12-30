//
// Created by Denys Meloshyn on 25/09/2019.
// Copyright (c) 2019 Denys Meloshyn. All rights reserved.
//

import Foundation

import CoreData

class UserAPIUpdateTask: APIUpdateTask, APIUpdateTaskProtocol {
    let timeStampStorageManager = TimeStampStorageManager(key: .user)

    var endpointURLBuilder: URL.Builder {
        restApiURLBuilder.appendPath("user")
    }

    func parseUpdates(items: [[String: Any?]], in managedObjectContext: NSManagedObjectContext) {
        for item in items {
            guard let modelID = item[User.modelKeyID()] as? Int else {
                continue
            }

            let user = User.findOrCreate(modelID: modelID, managedObjectContext: managedObjectContext)
            user.update(with: item, in: managedObjectContext)
        }
    }
}
