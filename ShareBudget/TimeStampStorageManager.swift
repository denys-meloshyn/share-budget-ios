//
// Created by Denys Meloshyn on 23/09/2019.
// Copyright (c) 2019 Denys Meloshyn. All rights reserved.
//

import Foundation

enum TimeStampKey: String, CaseIterable {
    case user
    case budget
    case budgetLimit
    case userGroup
    case category
    case expense
}

class TimeStampStorageManager {
    private let key: TimeStampKey

    var timestamp: String? {
        get {
            UserDefaults.standard.string(forKey: key.rawValue + "_timestamp")
        }

        set {
            UserDefaults.standard.set(newValue, forKey: key.rawValue + "_timestamp")
        }
    }

    init(key: TimeStampKey) {
        self.key = key
    }
}
