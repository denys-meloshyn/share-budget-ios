//
//  BaseAPI.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import Foundation

import HTTPNetworking
import CoreData
import RxCocoa
import RxSwift

class BaseAPI {
    let loader: HTTPProtocol
    private let environment: Environment
    
    init(environment: Environment = Dependency.environment(), loader: HTTPProtocol = HTTPNetwork.instance) {
        self.loader = loader
        self.environment = environment
    }
    
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
        if let errorMessage = data as? [String: String], let errorCode = errorMessage[Constants.key.json.message] {
            switch errorCode {
            case Constants.key.error.emailNotApproved:
                return .emailNotApproved
                
            case Constants.key.error.userNotExist:
                return .userNotExist
                
            case Constants.key.error.userIsAlreadyExist:
                return .userIsAlreadyExist
                
            case Constants.key.error.userPasswordIsWrong:
                return .userPasswordIsWrong
                
            case Constants.key.error.tokenExpired:
                return .tokenExpired
                
            case Constants.key.error.tokenNotValid:
                return .tokenNotValid
                
            default:
                return .unknown
            }
        } else if let errorMessage = data as? [String: String], let errorCode = errorMessage["msg"] {
            switch errorCode {
            case "Token has expired":
                return .tokenExpired
                
            default:
                return .unknown
            }
        }
        
        return .unknown 
    }
    
    class func checkResponse(data: Any?, response: URLResponse?, error: Error?) -> ErrorTypeAPI {
        if let cancelError = error as NSError?, cancelError.code == NSURLErrorCancelled {
            return .canceled
        }

        if error != nil {
            return .unknown
        }
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            return self.mapErrorType(data: data)
        }
        
        return .none
    }
    
    class func components(_ resource: String) -> URLComponents {
        var components = Dependency.backendConnection
        components.path = Dependency.restAPIVersion + "/" + resource
        
        return components
    }
    
    func parseUpdates(items: [[String: Any?]], in managedObjectContext: NSManagedObjectContext) {
        
    }

    func updates(_ resource: String, _ completion: APIResultBlock?) -> URLSessionTask {
        var components = BaseAPI.components(resource)
        components.path = Dependency.restAPIVersion + "/" + resource + "/updates"
        
        if let pagination = self.pagination {
            let sizePageQuery = URLQueryItem(name: Constants.key.json.paginationPageSize, value: String(pagination.size))
            let startPageQuery = URLQueryItem(name: Constants.key.json.paginationStart, value: String(pagination.start))
            components.queryItems = [sizePageQuery, startPageQuery]
        } else {
            let sizePageQuery = URLQueryItem(name: Constants.key.json.paginationPageSize, value: String(Constants.values.paginationSize))
            let startPageQuery = URLQueryItem(name: Constants.key.json.paginationStart, value: String(1))
            components.queryItems = [sizePageQuery, startPageQuery]
        }
        
        guard let url = components.url else {
            fatalError()
        }
        
        var request = URLRequest(url: url)
        request.method = .GET
        request.addUpdateCredentials(timestamp: self.timestamp)
        
        let task = AsynchronousURLConnection.create(request) { (data, response, error) -> Void in
            let errorType = BaseAPI.checkResponse(data: data, response: response, error: error)
            
            guard errorType == .none else {
                Dependency.logger.error("Error: \(errorType)", userInfo: [Constants.key.json.logBody: String(describing: data)])
                completion?(data, errorType)
                return
            }
            
            guard let dict = data as? [String: Any?] else {
                Dependency.logger.error("Response has wrong structure", userInfo: [Constants.key.json.logBody: String(describing: data)])
                completion?(data, .unknown)
                return
            }
            
            guard let results = dict[Constants.key.json.result] as? [[String: Any?]] else {
                Dependency.logger.error("'\(Constants.key.json.result)' has wrong structure", userInfo: [Constants.key.json.logBody: dict])
                completion?(data, .unknown)
                return
            }
            
            guard let timestamp = dict[Constants.key.json.timeStamp] as? String else {
                Dependency.logger.error("'\(Constants.key.json.timeStamp)' missed", userInfo: [Constants.key.json.logBody: dict])
                completion?(data, .unknown)
                return
            }
            
            if let pagination = dict[Constants.key.json.pagination] as? [String: Any] {
                let pagination = PaginationAPI(with: pagination)
                
                if pagination.hasNext() {
                    let newPageTask = BaseAPILoadUpdatesTask(resource: resource, entity: self, completionBlock: completion)
//                    SyncManager.shared.insertPaginationTask(newPageTask)
                    self.pagination = pagination
                } else {
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
    
    func formValues(properties: [String: Any]) -> Data? {
        let formValues = properties.map { (key, value) -> String in
            return "\(key)=\(value)"
        }.joined(separator: "&")
        
        return formValues.data(using: .utf8)
    }
    
    func upload(_ resource: String, _ modelID: NSManagedObjectID, _ completion: APIResultBlock?) -> URLSessionTask {
        let components = BaseAPI.components(resource)
        
        guard let url = components.url else {
            fatalError()
        }
        
        var request = URLRequest(url: url)
        request.method = .PUT
        
        let managedObjectContext = ModelManager.managedObjectContext
        let model = managedObjectContext.object(with: modelID) as! BaseModel
        var properties = model.uploadProperties()
        
        properties[Constants.key.json.token] = Dependency.userCredentials.accessToken
        properties[Constants.key.json.userID] = String(Dependency.userCredentials.userID)
        if !self.timestamp.isEmpty {
            properties[Constants.key.json.timeStamp] = self.timestamp
        }
        
        let formValues = properties.map { (key, value) -> String in
            return "\(key)=\(value)"
        }.joined(separator: "&")
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = formValues.data(using: .utf8)
        
        return AsynchronousURLConnection.create(request, completion: { (data, response, error) -> Void in
            let errorType = BaseAPI.checkResponse(data: data, response: response, error: error)
            
            guard errorType == .none else {
//                if errorType == .tokenExpired {
//                    Dependency.logger.error("Token is expired")
//                    _ = AuthorisationAPI.login(email: Dependency.userCredentials.email, password: Dependency.userCredentials.password, completion: { (data, error) -> Void in
//                        if error == .none {
//                            let task = self.upload(resource, modelID, completion)
//                            task.resume()
//                        } else {
//                            completion?(data, error)
//                        }
//                    })
//
//                    return
//                }
                
                Dependency.logger.error("Error: '\(errorType)'", userInfo: [Constants.key.json.logBody: String(describing: data)])
                completion?(data, errorType)
                return
            }
            
            guard let dict = data as? [String: Any?] else {
                Dependency.logger.error("Response has wrong structure", userInfo: [Constants.key.json.logBody: String(describing: data)])
                completion?(data, .unknown)
                return
            }
            
            guard let result = dict[Constants.key.json.result] as? [String: Any?] else {
                Dependency.logger.error("'result' has wrong structure", userInfo: [Constants.key.json.logBody: dict])
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
