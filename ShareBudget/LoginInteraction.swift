//
//  LoginInteraction.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import XCGLogger
import CoreData

class LoginInteraction: BaseInteraction {
    let managedObjectContext = ModelManager.sharedInstance.managedObjectContext
    
    func login(email: String, password: String, completion: APIResultBlock?) {
        _ = AuthorisationAPI.login(email: email, password: password) { (data, response, error) -> (Void) in
            let errorType = BaseAPI.checkResponse(data: data, response: response, error: error)
            
            guard errorType == .none else {
                completion?(data, errorType)
                return
            }
            
            guard let dict = data as? [String: AnyObject?] else {
                XCGLogger.error("Response has wrong structure")
                completion?(data, .unknown)
                return
            }
            
            guard let result = dict[kResult] as? [String: AnyObject?] else {
                XCGLogger.error("'result' has wrong structure")
                completion?(data, .unknown)
                return
            }
            
            guard let userID = result[kUserID] as? Int else {
                XCGLogger.error("'userID' missed")
                completion?(data, .unknown)
                return
            }
            
            guard let token = result[kToken] as? String else {
                XCGLogger.error("'token' missed")
                completion?(data, .unknown)
                return
            }
            
            var user = ModelManager.findUser(by: userID, in: self.managedObjectContext)
            if user == nil {
                user = User(context: self.managedObjectContext)
            }
            
            user?.update(with: result, in: self.managedObjectContext)
            ModelManager.saveContext(self.managedObjectContext)
            
            UserCredentials.token = token
            if let userID = user?.modelID {
                UserCredentials.userID = Int(userID)
            }
            
            completion?(user, .none)
        }
    }
    
    func singUp(email: String, password: String, firstName: String, lastName: String?, completion: APIResultBlock?) {
        _ = AuthorisationAPI.singUp(email: email, password: password, firstName: firstName, lastName: lastName, completion: { (data, response, error) -> (Void) in
            let errorType = BaseAPI.checkResponse(data: data, response: response, error: error)
            
            completion?(data, errorType)
        })
    }
    
    func sendRegistrationEmail(_ email: String) {
        AuthorisationAPI.sendRegistrationEmail(email)
    }
}
