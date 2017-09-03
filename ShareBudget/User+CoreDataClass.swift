//
//  User+CoreDataClass.swift
//  
//
//  Created by Denys Meloshyn on 15.01.17.
//
//

import Foundation
import CoreData

@objc(User)
public class User: BaseModel {
    override class func modelKeyID() -> String {
        return "userID"
    }
    
    override func update(with dict: [String: Any?], in managedObjectContext: NSManagedObjectContext) {
        super.update(with: dict, in: managedObjectContext)
        self.configureModelID(dict: dict, for: Constants.key.json.userID)
        
        self.email = dict[Constants.key.json.email] as? String
        self.firstName = dict[Constants.key.json.firstName] as? String
        self.lastName = dict[Constants.key.json.lastName] as? String
    }
}
