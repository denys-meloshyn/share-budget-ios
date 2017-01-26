//
//  BaseAPI.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class BaseAPI {
    class func resource() -> String {
        return ""
    }
    
    class func modelKeyID() -> String {
        return ""
    }
    
    class func components() -> NSURLComponents {
        let components = NSURLComponents()
        components.scheme = "http"
        components.host = "127.0.0.1"
        components.port = 5000
        components.path = "/" + self.resource()
        
        return components
    }
    
    class func updates(_ completion: APICompletionBlock?) -> URLSessionTask? {
        let components = self.components()
        components.path = self.resource() + "/updates"
        
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET";
        request.addUpdateCredentials()
        
        return AsynchronousURLConnection.create(request, completion: completion)
    }
}
