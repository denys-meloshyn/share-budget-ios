//
//  AuthorisationAPI.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 26.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class AuthorisationAPI: BaseAPI {
    class func login(email: String, password: String, completion: APICompletionBlock?) -> URLSessionTask? {
        let components = AuthorisationAPI.components("login")
        
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(email, forHTTPHeaderField: kEmail)
        request.setValue(password, forHTTPHeaderField: kPassword)
        
        return AsynchronousURLConnection.run(request, completion: completion)
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
