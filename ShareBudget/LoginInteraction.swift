//
//  LoginInteraction.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class LoginInteraction: BaseInteraction {
    func login(email: String, password: String, completion: APIResultBlock?) {
        _ = AuthorisationAPI.login(email: email, password: password) { (data, response, error) -> (Void) in
            let errorType = self.checkResponse(data: data, response: response, error: error)
            
            completion?(data, errorType)
        }
    }
    
    func sendRegistrationEmail(_ email: String) {
        AuthorisationAPI.sendRegistrationEmail(email)
    }
}
