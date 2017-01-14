//
//  UserAPI.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class UserAPI: BaseAPI {
    static func create(_ firstName: String, _ lastName: String, _ email: String, _ password: String, _ completion: APICompletionBlock?) -> URLSessionTask? {
        let components = BaseAPI.components()
        components.path = "/user";
        
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST";
        request.addValue(email, forHTTPHeaderField: kEmail)
        request.addValue(lastName, forHTTPHeaderField: kLastName)
        request.addValue(password, forHTTPHeaderField: kPassword)
        request.addValue(firstName, forHTTPHeaderField: kFirstName)
        
        return AsynchronousURLConnection.create(request, completion: completion)
    }
    
    static func update(_ firstName: String, _ lastName: String, _ email: String, _ password: String, _ completion: APICompletionBlock?) -> URLSessionTask? {
        let components = BaseAPI.components()
        components.path = "/user";
        
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT";
        request.addValue(lastName, forHTTPHeaderField: kLastName)
        request.addValue(firstName, forHTTPHeaderField: kFirstName)
        request.addToken()
        
        return AsynchronousURLConnection.create(request, completion: completion)
    }
}
