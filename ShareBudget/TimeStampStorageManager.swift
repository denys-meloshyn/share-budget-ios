//
// Created by Denys Meloshyn on 23/09/2019.
// Copyright (c) 2019 Denys Meloshyn. All rights reserved.
//

import Foundation

class TimeStampStorageManager {
    private let key: String

    var timestamp: String? {
        get {
            UserDefaults.standard.string(forKey: key)
        }

        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }

    init(key: String) {
        self.key = key
    }
}
