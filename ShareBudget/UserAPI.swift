//
//  UserAPI.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

class UserAPI: BaseAPI {
    override class func modelKeyID() -> String {
        return "userID"
    }
    
    override class func timestampStorageKey() -> String {
        return "user_timestamp"
    }
    
    override class func parseUpdates(items: [[String: AnyObject?]], in managedObjectContext: NSManagedObjectContext) {
        var user: User?
        
        for item in items {
            user = User(context: managedObjectContext)
            user?.update(with: item, in: managedObjectContext)
        }
    }
    
    class func create(_ managedObjectContext: NSManagedObjectContext, _ firstName: String, _ lastName: String, _ email: String, _ password: String, _ completion: APICompletionBlock?) -> URLSessionTask? {
        let components = UserAPI.components("user")
        
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(email, forHTTPHeaderField: kEmail)
        request.setValue(lastName, forHTTPHeaderField: kLastName)
        request.setValue(password, forHTTPHeaderField: kPassword)
        request.setValue(firstName, forHTTPHeaderField: kFirstName)
        
        return AsynchronousURLConnection.create(request, completion: completion)
    }
    
    class func update(_ managedObjectContext: NSManagedObjectContext, _ user: User, _ completion: APICompletionBlock?) -> URLSessionTask? {
        let components = UserAPI.components("user")
        
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        if let lastName = user.lastName {
            request.setValue(lastName, forHTTPHeaderField: kLastName)
        }
        
        if let firstName = user.firstName {
            request.setValue(firstName, forHTTPHeaderField: kFirstName)
        }
        
        request.addUpdateCredentials(timestamp: self.timestamp)
        
        return AsynchronousURLConnection.create(request, completion: completion)
    }
}
