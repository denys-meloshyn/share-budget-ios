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
        setValue("Bearer \(Dependency.userCredentials.accessToken)", forHTTPHeaderField: "Authorization")
    }

    mutating func addUserID() {
        setValue(UserCredentials.instance.userID, forHTTPHeaderField: Constants.key.json.userID)
    }

    mutating func addUpdateCredentials(timestamp: String?) {
        addToken()
        addUserID()

        if let timestamp = timestamp, !timestamp.isEmpty {
            setValue(timestamp, forHTTPHeaderField: Constants.key.json.timeStamp)
        }
    }

    mutating func addUploadCredentials() {
        addToken()
        addUserID()
    }
}
