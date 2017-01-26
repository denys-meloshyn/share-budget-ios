//
//  BaseInteraction.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

typealias APIResultBlock = (Any?, ErrorTypeAPI) -> (Void)

class BaseInteraction {
    private let router: BaseRouter
    
    init(with router: BaseRouter) {
        self.router = router
    }
    
    private func mapdErrorType(data: Any?) -> ErrorTypeAPI {
        if let errorMessage = data as? [String: String], let errorCode = errorMessage[kMessage] {
            switch errorCode {
            case kEmailNotApproved:
                return .emailNotApproved
            default:
                return .unknown
            }
        }
        
        return .unknown

    }
    
    func checkResponse(data: Any?, response: URLResponse?, error: Error?) -> ErrorTypeAPI {
        if let _ = error {
            return .unknown
        }
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            return self.mapdErrorType(data: data)
        }
        
        return .none
    }
}
