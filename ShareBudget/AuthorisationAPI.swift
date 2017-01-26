//
//  AuthorisationAPI.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 26.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class AuthorisationAPI: BaseAPI {
    override class func resource() -> String {
        return "login"
    }
    
    class func login(email: String, password: String, completion: APICompletionBlock?) -> URLSessionTask? {
        let components = BaseAPI.components()
        
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(email, forHTTPHeaderField: kEmail)
        request.setValue(password, forHTTPHeaderField: kPassword)
        
        return AsynchronousURLConnection.create(request, completion: completion)
    }
}
