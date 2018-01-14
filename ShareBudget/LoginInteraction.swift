//
//  LoginInteraction.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

protocol LoginInteractionProtocol: BaseInteractionProtocol {
    func sendRegistrationEmail(_ email: String)
    func login(email: String, password: String, completion: APIResultBlock?)
    func singUp(email: String, password: String, firstName: String, lastName: String?, completion: APIResultBlock?)
}

class LoginInteraction: BaseInteraction, LoginInteractionProtocol {
    let managedObjectContext = ModelManager.managedObjectContext
    
    func login(email: String, password: String, completion: APIResultBlock?) {
        _ = AuthorisationAPI.login(email: email, password: password, completion: completion)
    }
    
    func singUp(email: String, password: String, firstName: String, lastName: String?, completion: APIResultBlock?) {
        _ = AuthorisationAPI.singUp(email: email, password: password, firstName: firstName, lastName: lastName, completion: { (data, response, error) -> Void in
            let errorType = BaseAPI.checkResponse(data: data, response: response, error: error)
            
            completion?(data, errorType)
        })
    }
    
    func sendRegistrationEmail(_ email: String) {
        AuthorisationAPI.sendRegistrationEmail(email)
    }
}
