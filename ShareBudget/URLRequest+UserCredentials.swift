//
//  URLRequest+UserCredentials.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 22.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

extension URLRequest {
    mutating func addToken() {
        self.setValue(Dependency.userCredentials.accessToken, forHTTPHeaderField: Constants.key.json.token)
    }
    
    mutating func addUpdateCredentials(timestamp: String) {
        self.addToken()
        
        if !timestamp.isEmpty {
            self.setValue(timestamp, forHTTPHeaderField: Constants.key.json.timeStamp)
        }
    }
}
