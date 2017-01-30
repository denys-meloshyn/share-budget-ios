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
}
