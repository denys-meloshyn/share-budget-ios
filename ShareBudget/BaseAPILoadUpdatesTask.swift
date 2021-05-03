//
//  BaseAPILoadUpdatesTask.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 28.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

class BaseAPILoadUpdatesTask: BaseAPITask {
    override func request() -> URLSessionTask {
        let task = entity.updates(resource, completionBlock)

        return task
    }
}
