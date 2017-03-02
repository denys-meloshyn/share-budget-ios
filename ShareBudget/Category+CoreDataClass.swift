//
//  Category+CoreDataClass.swift
//  
//
//  Created by Denys Meloshyn on 15.01.17.
//
//

import Foundation
import CoreData

@objc(Category)
public class Category: BaseModel {
    override func update(with dict: [String: AnyObject?], in managedObjectContext: NSManagedObjectContext) {
        super.update(with: dict, in: managedObjectContext)
        self.configureModelID(dict: dict, for: kCategoryID)
        
        self.name = dict[kName] as? String
        
        if let modelID = dict[BudgetAPI.modelKeyID()] as? Int {
            self.budget = ModelManager.findEntity(Budget.self, by: modelID, in: managedObjectContext) as? Budget
            self.budget?.addToCategories(self)
        }
    }
    
    override func uploadProperties() -> [String : String] {
        var result = super.uploadProperties()
        
        if let name = self.name {
            result[kName] = name
        }
        
        if let groupID = self.budget?.modelID {
            result[kGroupID] = String(groupID.intValue)
        }
        
        return result
    }
}
