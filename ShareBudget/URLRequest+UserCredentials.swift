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
        self.setValue(UserCredentials.token, forHTTPHeaderField: kToken)
    }
    
    mutating func addUpdateCredentials() {
        self.addToken()
        self.setValue(UserCredentials.timestamp, forHTTPHeaderField: kTimeStamp)
        self.setValue(String(UserCredentials.userID), forHTTPHeaderField: kUserID)
    }
    
    mutating func addModelInfo(_ model: BaseModel) {
        self.setValue(String(model.internalID), forHTTPHeaderField: kInternalID)
        self.setValue(String(model.isRemoved), forHTTPHeaderField: kIsRemoved)
        self.setValue(String(model.modelID), forHTTPHeaderField: BaseAPI.modelKeyID())
    }
}
