//
//  BaseAPI.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData
import XCGLogger

class BaseAPI {
    func timestampStorageKey() -> String {
        return ""
    }
    
    var timestamp: String {
        get {
            return UserDefaults.standard.string(forKey: self.timestampStorageKey()) ?? ""
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: self.timestampStorageKey())
        }
    }
    
    var pagination: PaginationAPI?
    
    class private func mapErrorType(data: Any?) -> ErrorTypeAPI {
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
                
            case kTokenExpired:
                return .tokenExpired
                
            case kTokenNotValid:
                return .tokenNotValid
                
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
            return self.mapErrorType(data: data)
        }
        
        return .none
    }
    
    class func components(_ resource: String) -> NSURLComponents {
        let components = NSURLComponents()
        
        components.scheme = "http"
        components.host = "127.0.0.1"
        components.port = 5000
        
//        components.scheme = "https"
//        components.host = "sharebudget-development.herokuapp.com"
        
        components.path = "/" + resource
        
        return components
    }
    
    func parseUpdates(items: [[String: AnyObject?]], in managedObjectContext: NSManagedObjectContext) {
        
    }
    
    func updates(_ resource: String, _ completion: APIResultBlock?) -> URLSessionTask? {
        let components = BaseAPI.components(resource)
        components.path = "/" + resource + "/updates"
        
        if let pagination = self.pagination {
            let sizePageQuery = URLQueryItem(name: kPaginationPageSize, value: String(pagination.size))
            let startPageQuery = URLQueryItem(name: kPaginationStart, value: String(pagination.start))
            components.queryItems = [sizePageQuery, startPageQuery]
        } else {
            let sizePageQuery = URLQueryItem(name: kPaginationPageSize, value: String(paginationSize))
            let startPageQuery = URLQueryItem(name: kPaginationStart, value: String(1))
            components.queryItems = [sizePageQuery, startPageQuery]
        }
        
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET";
        request.addUpdateCredentials(timestamp: self.timestamp)
        
        let task = AsynchronousURLConnection.create(request) { (data, response, error) -> (Void) in
            let errorType = BaseAPI.checkResponse(data: data, response: response, error: error)
            
            guard errorType == .none else {
                XCGLogger.error("Error: \(errorType) message: \(String(describing: data))")
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
            
            if let pagination = dict[kPagination] as? [String: Any] {
                let pagination = PaginationAPI(with: pagination)
                
                if pagination.hasNext() {
                    let newPageTask = BaseAPILoadUpdatesTask(resource: resource, entity: self, completionBlock: completion)
                    SyncManager.insertPaginationTask(newPageTask)
                    self.pagination = pagination
                }
                else {
                    self.pagination = nil
                }
            }
            
            if results.count > 0 {
                self.timestamp = timestamp
                let managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)
                self.parseUpdates(items: results, in: managedObjectContext)
                ModelManager.saveChildren(managedObjectContext, block: nil)
            }
            
            completion?(nil, .none)
        }
        
        return task
    }
    
    func upload(_ resource: String, _ modelID: NSManagedObjectID, _ completion: APIResultBlock?) -> URLSessionTask? {
        let components = BaseAPI.components(resource)
        
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let managedObjectContext = ModelManager.managedObjectContext
        let model = managedObjectContext.object(with: modelID) as! BaseModel
        var properties = model.uploadProperties()
        
        properties[kToken] = UserCredentials.token
        properties[kUserID] = String(UserCredentials.userID)
        if !self.timestamp.isEmpty {
            properties[kTimeStamp] = self.timestamp
        }
        
        let formValues = properties.map { (key, value) -> String in
            return "\(key)=\(value)"
        }.joined(separator: "&")
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = formValues.data(using: .utf8)
        
        return AsynchronousURLConnection.create(request, completion: { (data, response, error) -> (Void) in
            let errorType = BaseAPI.checkResponse(data: data, response: response, error: error)
            
            guard errorType == .none else {
                if errorType == .tokenExpired {
                    XCGLogger.error("Token is expired")
                    _ = AuthorisationAPI.login(email: UserCredentials.email, password: UserCredentials.password, completion: { (data, error) -> (Void) in
                        if error == .none {
                            let task = self.upload(resource, modelID, completion)
                            task?.resume()
                        }
                        else {
                            completion?(data, error)
                        }
                    })
                    
                    return
                }
                
                XCGLogger.error("Error: '\(errorType)' message: \(String(describing: data))")
                
                completion?(data, errorType)
                return
            }
            
            guard let dict = data as? [String: AnyObject?] else {
                XCGLogger.error("Response has wrong structure")
                completion?(data, .unknown)
                return
            }
            
            guard let result = dict[kResult] as? [String: AnyObject?] else {
                XCGLogger.error("'result' has wrong structure")
                completion?(data, .unknown)
                return
            }
            
            let managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)
            let model = managedObjectContext.object(with: modelID) as! BaseModel
            model.isChanged = false
            
            model.update(with: result, in: managedObjectContext)
            ModelManager.saveChildren(managedObjectContext, block: {
                completion?(nil, .none)
            })
        })
    }
    
    func allChangedModels(completionBlock: APIResultBlock?) -> [BaseAPITask] {
        return []
    }
}
