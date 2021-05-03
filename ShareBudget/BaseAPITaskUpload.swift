//
//  BaseAPITaskUpload.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 27.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData

class BaseAPITaskUpload: BaseAPITask {
    var modelID: NSManagedObjectID

    init(resource: String, entity: BaseAPI, modelID: NSManagedObjectID, completionBlock: APIResultBlock?) {
        self.modelID = modelID

        super.init(resource: resource, entity: entity, completionBlock: completionBlock)
    }

    override func request() -> URLSessionTask {
        let task = entity.upload(resource, modelID, completionBlock)

        return task
    }
}
