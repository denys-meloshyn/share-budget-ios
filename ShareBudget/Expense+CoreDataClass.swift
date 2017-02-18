//
//  Expense+CoreDataClass.swift
//  
//
//  Created by Denys Meloshyn on 15.01.17.
//
//

import Foundation
import CoreData

@objc(Expense)
public class Expense: BaseModel {
    override func update(with dict: [String: AnyObject?], in managedObjectContext: NSManagedObjectContext) {
        super.update(with: dict, in: managedObjectContext)
        self.configureModelID(dict: dict, for: kExpenseID)
        
        if let budgetID = dict[kGroupID] as? Int {
            self.budget = ModelManager.findEntity(Budget.self, by: budgetID, in: managedObjectContext) as? Budget
            self.budget?.expenses?.adding(self)
        }
        
        self.name = dict[kName] as? String
        self.price = (dict[kPrice] as? Double) ?? 0.0
    }
    
    override func uploadProperties() -> [String : String] {
        var result = super.uploadProperties()
        
        result[kPrice] = String(self.price)
        result[kExpenseID] = String(self.modelID)
        
        if let name = self.name {
            result[kName] = name
        }
        
        if let modelID = self.budget?.modelID {
            result[kGroupID] = String(modelID)
        }
        
        return result
    }
}
