//
//  BaseAPI.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class BaseAPI {
    class func modelKeyID() -> String {
        return ""
    }
    
    class func components(_ resource: String) -> NSURLComponents {
        let components = NSURLComponents()
        components.scheme = "http"
        components.host = "127.0.0.1"
        components.port = 5000
        components.path = "/" + resource
        
        return components
    }
    
    class func updates(_ resource: String, _ completion: APICompletionBlock?) -> URLSessionTask? {
        let components = self.components(resource)
        components.path = resource + "/updates"
        
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET";
        request.addUpdateCredentials()
        
        return AsynchronousURLConnection.create(request, completion: completion)
    }
}
