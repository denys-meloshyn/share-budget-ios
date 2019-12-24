//
// Created by Denys Meloshyn on 22/12/2019.
// Copyright (c) 2019 Denys Meloshyn. All rights reserved.
//

import Foundation
import CoreData

class UserGroupsAPIUploadTask: APIUploadTask, APIUploadTaskProtocol {
    var endpointURLBuilder: URL.Builder {
        restApiURLBuilder.appendPath("user").appendPath("group")
    }

    func parseUpdate(item: [String : Any?], in managedObjectContext: NSManagedObjectContext) {
        let userGroup = ModelManager.findOrCreateEntity(UserGroup.self, response: item, in: managedObjectContext) as? UserGroup
        userGroup?.update(with: item, in: managedObjectContext)
    }
}
