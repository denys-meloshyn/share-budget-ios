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
    
    override func update(with dict: [String: AnyObject?], in managedObjectContext: NSManagedObjectContext) {
        super.update(with: dict, in: managedObjectContext)
        self.configureModelID(dict: dict, for: kUserID)
        
        self.email = dict[kEmail] as? String
        self.firstName = dict[kFirstName] as? String
        self.lastName = dict[kLastName] as? String
    }
}
