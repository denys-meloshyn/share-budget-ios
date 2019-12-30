//
//  GroupAPIUploadTask.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 24/12/2019.
//  Copyright © 2019 Denys Meloshyn. All rights reserved.
//

import CoreData

class GroupAPIUploadTask: APIUploadTask, APIUploadTaskProtocol {
    var endpointURLBuilder: URL.Builder {
        restApiURLBuilder.appendPath("group")
    }
}
