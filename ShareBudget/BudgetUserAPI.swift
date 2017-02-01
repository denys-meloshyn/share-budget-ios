//
//  BudgetUserAPI.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 01.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData

class BudgetUserAPI: BaseAPI {
    override class func timestampStorageKey() -> String {
        return "budget_user_timestamp"
    }
}
