//
//  BaseAPITask.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 28.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class BaseAPITask {
    var resource: String
    var entity: BaseAPI
    var completionBlock: APIResultBlock?
    
    init(resource: String, entity: BaseAPI, completionBlock: APIResultBlock?) {
        self.entity = entity
        self.resource = resource
        self.completionBlock = completionBlock
    }
    
    func request() -> URLSessionTask! {
        return nil
    }
}
