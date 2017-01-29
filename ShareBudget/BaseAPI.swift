//
//  BaseAPI.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData
import XCGLogger

class BaseAPI {
    class func modelKeyID() -> String {
        return ""
    }
    
    class func timestampStorageKey() -> String {
        return ""
    }
    
    class var timestamp: String {
        get {
            return UserDefaults.standard.string(forKey: self.timestampStorageKey()) ?? ""
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: self.timestampStorageKey())
        }
    }
    
    private class func mapdErrorType(data: Any?) -> ErrorTypeAPI {
        if let errorMessage = data as? [String: String], let errorCode = errorMessage[kMessage] {
            switch errorCode {
            case kEmailNotApproved:
                return .emailNotApproved
                
            case kUserNotExist:
                return .userNotExist
                
            case kUserIsAlreadyExist:
                return .userIsAlreadyExist
                
            case kUserPasswordIsWrong:
                return .userPasswordIsWrong
                
            default:
                return .unknown
            }
        }
        
        return .unknown
    }
    
    class func checkResponse(data: Any?, response: URLResponse?, error: Error?) -> ErrorTypeAPI {
        if let _ = error {
            return .unknown
        }
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            return BaseAPI.mapdErrorType(data: data)
        }
        
        return .none
    }
    
    class func components(_ resource: String) -> NSURLComponents {
        let components = NSURLComponents()
        components.scheme = "http"
        components.host = "127.0.0.1"
        components.port = 5000
        components.path = "/" + resource
        
        return components
    }
    
    class func parseUpdates(items: [[String: AnyObject?]], in managedObjectContext: NSManagedObjectContext) {
        
    }
    
    class func updates(_ resource: String, _ managedObjectContext: NSManagedObjectContext, _ completion: APIResultBlock?) -> URLSessionTask? {
        let components = self.components(resource)
        components.path = resource + "/updates"
        
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET";
        request.addUpdateCredentials(timestamp: self.timestamp)
        
        let task = AsynchronousURLConnection.create(request) { (data, response, error) -> (Void) in
            let errorType = BaseAPI.checkResponse(data: data, response: response, error: error)
            
            guard errorType == .none else {
                if errorType == .tokenExpired {
                    _ = self.updates(resource, managedObjectContext, completion)
                    return
                }
                
                completion?(data, errorType)
                return
            }
            
            guard let dict = data as? [String: AnyObject?] else {
                XCGLogger.error("Response has wrong structure")
                completion?(data, .unknown)
                return
            }
            
            guard let results = dict[kResult] as? [[String: AnyObject?]] else {
                XCGLogger.error("'result' has wrong structure")
                completion?(data, .unknown)
                return
            }
            
            guard let timestamp = dict[kTimeStamp] as? String else {
                XCGLogger.error("'timeStamp' missed")
                completion?(data, .unknown)
                return
            }
            
            self.timestamp = timestamp
            self.parseUpdates(items: results, in: managedObjectContext)
            completion?(nil, .none)
        }
        
        return task
    }
}
