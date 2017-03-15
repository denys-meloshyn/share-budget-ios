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
            if self.statusActivities <= 0 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        }
    }
    
    var visible = true {
        didSet {
            if self.visible {
                self.startActivity()
            }
            else {
                self.stopActivity()
            }
        }
    }
    
    private func startActivity() {
        self.lockQueue.sync() {
            self.statusActivities += 1
        }
    }
    
    private func stopActivity() {
        self.lockQueue.sync() {
            self.statusActivities -= 1
        }
    }
}
