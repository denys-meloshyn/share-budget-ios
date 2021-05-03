//
//  PaginationAPI.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 20.05.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class PaginationAPI {
    var size = 0
    var start = 0
    var total = 0

    init(with dict: [String: Any]) {
        size = dict[Constants.key.json.paginationPageSize] as? Int ?? 0
        start = dict[Constants.key.json.paginationStart] as? Int ?? 0
        total = dict[Constants.key.json.paginationTotal] as? Int ?? 0
    }

    func hasNext() -> Bool {
        if start + size > total {
            return false
        }

        return true
    }
}
