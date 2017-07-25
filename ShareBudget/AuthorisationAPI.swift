//
//  AuthorisationAPI.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 26.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import Foundation

class AuthorisationAPI: BaseAPI {
    class func login(email: String, password: String, completion: APIResultBlock?) -> URLSessionTask? {
        let components = AuthorisationAPI.components("login")
        
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(email, forHTTPHeaderField: kEmail)
        request.setValue(password, forHTTPHeaderField: kPassword)
        
        return AsynchronousURLConnection.run(request, completion: { (data, response, error) -> (Void) in
            let errorType = BaseAPI.checkResponse(data: data, response: response, error: error)
            
            guard errorType == .none else {
                completion?(data, errorType)
                return
            }
            
            guard let dict = data as? [String: AnyObject?] else {
                Dependency.logger.error("Response has wrong structure")
                completion?(data, .unknown)
                return
            }
            
            guard let result = dict[kResult] as? [String: AnyObject?] else {
                Dependency.logger.error("'result' has wrong structure")
                completion?(data, .unknown)
                return
            }
            
            guard let userID = result[kUserID] as? Int else {
                Dependency.logger.error("'userID' is missed")
                completion?(data, .unknown)
                return
            }
            
            guard let token = result[kToken] as? String else {
                Dependency.logger.error("'token' is missed")
                completion?(data, .unknown)
                return
            }
            
            Dependency.userCredentials.email = email
            Dependency.userCredentials.token = token
            Dependency.userCredentials.userID = userID
            Dependency.userCredentials.password = password
            
            var user = ModelManager.findEntity(User.self, by: userID, in: ModelManager.managedObjectContext)
            if user == nil {
                user = User(context: ModelManager.managedObjectContext)
            }
            
            user?.update(with: result, in: ModelManager.managedObjectContext)
            ModelManager.saveContext(ModelManager.managedObjectContext)
            
            completion?(user, .none)
        })
    }
    
    class func singUp(email: String, password: String, firstName: String, lastName: String?, completion: APICompletionBlock?) -> URLSessionTask? {
        let components = AuthorisationAPI.components("user")
        
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(email, forHTTPHeaderField: kEmail)
        request.setValue(password, forHTTPHeaderField: kPassword)
        request.setValue(firstName, forHTTPHeaderField: kFirstName)
        request.setValue(lastName, forHTTPHeaderField: kLastName)
        
        return AsynchronousURLConnection.run(request, completion: completion)
    }
    
    class func sendRegistrationEmail(_ email: String) {
        let components = AuthorisationAPI.components("registration/sendemail")
        
        guard let url = components.url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(email, forHTTPHeaderField: kEmail)
        
        _ = AsynchronousURLConnection.run(request, completion: nil)
    }
}
