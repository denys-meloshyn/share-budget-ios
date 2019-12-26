//
//  GroupLimitAPIUploadTask.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 26/12/2019.
//  Copyright © 2019 Denys Meloshyn. All rights reserved.
//

import CoreData

class GroupLimitAPIUploadTask: APIUploadTask, APIUploadTaskProtocol {
    var endpointURLBuilder: URL.Builder {
        restApiURLBuilder.appendPath("budget").appendPath("limit")
    }
}
