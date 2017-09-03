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
        request.setValue(email, forHTTPHeaderField: Constants.key.json.email)
        request.setValue(password, forHTTPHeaderField: Constants.key.json.password)
        
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
            
            guard let result = dict[Constants.key.json.result] as? [String: AnyObject?] else {
                Dependency.logger.error("'result' has wrong structure")
                completion?(data, .unknown)
                return
            }
            
            guard let userID = result[Constants.key.json.userID] as? Int else {
                Dependency.logger.error("'userID' is missed")
                completion?(data, .unknown)
                return
            }
            
            guard let token = result[Constants.key.json.token] as? String else {
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
        request.setValue(email, forHTTPHeaderField: Constants.key.json.email)
        request.setValue(password, forHTTPHeaderField: Constants.key.json.password)
        request.setValue(firstName, forHTTPHeaderField: Constants.key.json.firstName)
        request.setValue(lastName, forHTTPHeaderField: Constants.key.json.lastName)
        
        return AsynchronousURLConnection.run(request, completion: completion)
    }
    
    class func sendRegistrationEmail(_ email: String) {
        let components = AuthorisationAPI.components("registration/sendemail")
        
        guard let url = components.url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(email, forHTTPHeaderField: Constants.key.json.email)
        
        _ = AsynchronousURLConnection.run(request, completion: nil)
    }
}
