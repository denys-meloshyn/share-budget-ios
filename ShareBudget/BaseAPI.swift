//
//  BaseAPI.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

extension URLRequest {
    mutating func addToken() {
        self.addValue(UserCredentials.token, forHTTPHeaderField: kToken)
    }
}

class BaseAPI {
    static func components() -> NSURLComponents {
        let components = NSURLComponents()
        components.scheme = "http"
        components.host = "127.0.0.1"
        components.port = 5000
        
        return components
    }
}
