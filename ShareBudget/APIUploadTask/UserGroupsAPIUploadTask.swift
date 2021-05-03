//
// Created by Denys Meloshyn on 22/12/2019.
// Copyright (c) 2019 Denys Meloshyn. All rights reserved.
//

import CoreData
import Foundation

class UserGroupsAPIUploadTask: APIUploadTask, APIUploadTaskProtocol {
    var endpointURLBuilder: URL.Builder {
        restApiURLBuilder.appendPath("user").appendPath("group")
    }
}
