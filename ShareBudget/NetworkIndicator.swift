//
//  NetworkIndicator.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 15.03.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class NetworkIndicator: NSObject {
    static let shared = NetworkIndicator()

    private let lockQueue = DispatchQueue(label: "NetworkIndicator")

    private var statusActivities = 0 {
        didSet {
            if statusActivities <= 0 {
            } else {}
        }
    }

    var visible = true {
        didSet {
            if visible {
                startActivity()
            } else {
                stopActivity()
            }
        }
    }

    private func startActivity() {
        lockQueue.sync {
            self.statusActivities += 1
        }
    }

    private func stopActivity() {
        lockQueue.sync {
            self.statusActivities -= 1
        }
    }
}
