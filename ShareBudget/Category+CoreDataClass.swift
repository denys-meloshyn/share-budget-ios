//
//  Category+CoreDataClass.swift
//
//
//  Created by Denys Meloshyn on 15.01.17.
//
//

import CoreData
import Foundation

@objc(Category)
public class Category: BaseModel {
    override class func modelKeyID() -> String {
        return Constants.key.json.categoryID
    }

    override func update(with dict: [String: Any?], in managedObjectContext: NSManagedObjectContext) {
        super.update(with: dict, in: managedObjectContext)
        configureModelID(dict: dict, for: Constants.key.json.categoryID)

        name = dict[Constants.key.json.name] as? String

        if let modelID = dict[Budget.modelKeyID()] as? Int {
            budget = ModelManager.findEntity(Budget.self, by: modelID, in: managedObjectContext) as? Budget
            budget?.addToCategories(self)
        }
    }

    override func uploadProperties() -> [String: String] {
        var result = super.uploadProperties()

        if let name = self.name {
            result[Constants.key.json.name] = name
        }

        if let categoryID = modelID {
            result[Constants.key.json.categoryID] = String(categoryID.intValue)
        }

        if let groupID = budget?.modelID {
            result[Constants.key.json.groupID] = String(groupID.intValue)
        }

        return result
    }
}
