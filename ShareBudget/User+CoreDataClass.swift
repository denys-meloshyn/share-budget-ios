//
//  User+CoreDataClass.swift
//
//
//  Created by Denys Meloshyn on 15.01.17.
//
//

import CoreData
import Foundation

@objc(User)
public class User: BaseModel {
    override class func modelKeyID() -> String {
        return "userID"
    }

    override func update(with dict: [String: Any?], in managedObjectContext: NSManagedObjectContext) {
        super.update(with: dict, in: managedObjectContext)
        configureModelID(dict: dict, for: Constants.key.json.userID)

        email = dict[Constants.key.json.email] as? String
        firstName = dict[Constants.key.json.firstName] as? String
        lastName = dict[Constants.key.json.lastName] as? String
    }
}
