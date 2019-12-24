//
// Created by Denys Meloshyn on 22/12/2019.
// Copyright (c) 2019 Denys Meloshyn. All rights reserved.
//

import Foundation
import CoreData

class UserAPIUploadTask: APIUploadTask, APIUploadTaskProtocol {
    var endpointURLBuilder: URL.Builder {
        restApiURLBuilder.appendPath("user")
    }

    func parseUpdate(item: [String: Any?], in managedObjectContext: NSManagedObjectContext) {
        guard let modelID = item[User.modelKeyID()] as? Int else {
            return
        }

        let user = User.findOrCreate(modelID: modelID, managedObjectContext: managedObjectContext)
        user.update(with: item, in: managedObjectContext)
    }
}
