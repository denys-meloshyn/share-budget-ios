//
//  BudgetAPI.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 30.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData
import XCGLogger

class BudgetAPI: BaseAPI {
    override class func modelKeyID() -> String {
        return kGroupID
    }
    
    override class func timestampStorageKey() -> String {
        return "budget_timestamp"
    }
    
    override class func parseUpdates(items: [[String: AnyObject?]], in managedObjectContext: NSManagedObjectContext) {
        var budget: Budget?
        
        for item in items {
            if let internalID = item[kInternalID] as? Int {
                budget = ModelManager.findEntity(Budget.self, internal: internalID, in: managedObjectContext) as? Budget
            } else if let modelID = item[BudgetAPI.modelKeyID()] as? Int {
                budget = ModelManager.findEntity(Budget.self, by: modelID, in: managedObjectContext) as? Budget
            }
            
            if budget == nil {
                budget = Budget(context: managedObjectContext)
            }
            
            budget?.update(with: item, in: managedObjectContext)
        }
    }
    
    class func upload(_ managedObjectContext: NSManagedObjectContext, _ budget: Budget, _ completion: APIResultBlock?) -> URLSessionTask? {
        let components = BudgetAPI.components("group")
        
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        if let name = budget.name {
            request.setValue(name, forHTTPHeaderField: kName)
        }
        
        request.addUpdateCredentials(timestamp: BudgetAPI.timestamp)
        
        return AsynchronousURLConnection.create(request, completion: { (data, response, error) -> (Void) in
            let errorType = BaseAPI.checkResponse(data: data, response: response, error: error)
            
            guard errorType == .none else {
                if errorType == .tokenExpired {
                    XCGLogger.error("Token is expired")
                    _ = AuthorisationAPI.login(email: UserCredentials.email, password: UserCredentials.password, completion: { (data, error) -> (Void) in
                        if error == .none {
                            let task = self.upload(managedObjectContext, budget, completion)
                            task?.resume()
                        }
                        else {
                            completion?(data, error)
                        }
                    })
                    
                    return
                }
                
                XCGLogger.error("Error: \(errorType) message: \(data)")
                
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
            
            budget.isChanged = false
            budget.configureModelID(dict: result, for: kGroupID)
            
            completion?(nil, .none)
        })
    }
}
