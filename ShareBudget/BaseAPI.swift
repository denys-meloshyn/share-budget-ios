//
//  BaseAPI.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

extension URLRequest {
    mutating func addToken() {
        self.addValue(UserCredentials.token, forHTTPHeaderField: kToken)
    }
    
    mutating func addUpdateCredentials() {
        self.addValue(UserCredentials.token, forHTTPHeaderField: kToken)
        self.addValue(UserCredentials.timestamp, forHTTPHeaderField: kTimeStamp)
        self.addValue(String(UserCredentials.userID), forHTTPHeaderField: kUserID)
    }
}

protocol ResourceName {
    var resource: String { get }
}

class BaseAPI {
    class func resource() -> String {
        return ""
    }
    
    class func components() -> NSURLComponents {
        let components = NSURLComponents()
        components.scheme = "http"
        components.host = "127.0.0.1"
        components.port = 5000
        
        return components
    }
    
    class func updates(_ completion: APICompletionBlock?) -> URLSessionTask? {
        let components = BaseAPI.components()
        components.path = BaseAPI.resource() + "/updates"
        
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET";
        request.addUpdateCredentials()
        
        return AsynchronousURLConnection.create(request, completion: completion)
    }
}
