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
        self.setValue(UserCredentials.token, forHTTPHeaderField: kToken)
    }
    
    mutating func addUpdateCredentials() {
        self.addToken()
        self.setValue(UserCredentials.timestamp, forHTTPHeaderField: kTimeStamp)
        self.setValue(String(UserCredentials.userID), forHTTPHeaderField: kUserID)
    }
    
    mutating func addModelInfo(_ model: BaseModel) {
        self.setValue(String(model.internalID), forHTTPHeaderField: kInternalID)
        self.setValue(String(model.isRemoved), forHTTPHeaderField: kIsRemoved)
        self.setValue(String(model.modelID), forHTTPHeaderField: BaseAPI.modelKeyID())
    }
}

protocol ResourceName {
    var resource: String { get }
}

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
        components.path = "/" + BaseAPI.resource()
        
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
