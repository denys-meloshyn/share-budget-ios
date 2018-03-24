//
//  BudgetLimit+CoreDataClass.swift
//  
//
//  Created by Denys Meloshyn on 29.01.17.
//
//

import Foundation
import CoreData

@objc(BudgetLimit)
public class BudgetLimit: BaseModel {
    override class func modelKeyID() -> String {
        return Constants.key.json.budgetLimitID
    }
    
    override func update(with dict: [String: Any?], in managedObjectContext: NSManagedObjectContext) {
        super.update(with: dict, in: managedObjectContext)
        self.configureModelID(dict: dict, for: Constants.key.json.budgetLimitID)
        
        self.limit = NSNumber(value: dict[Constants.key.json.limit] as? Double ?? 0.0)
        
        if let date = dict[Constants.key.json.date] as? String {
            self.date = UtilityFormatter.date(from: date) as NSDate?
        }
    }
    
    override func uploadProperties() -> [String: String] {
        var result = super.uploadProperties()
        
        if let modelID = self.modelID {
            result[Constants.key.json.budgetLimitID] = String(modelID.intValue)
        }
        
        if let date = self.date as Date? {
            result[Constants.key.json.date] = UtilityFormatter.string(from: date)
        }
        
        if let groupID = self.budget?.modelID {
            result[Constants.key.json.groupID] = String(groupID.intValue)
        }
        
        result[Constants.key.json.limit] = String(describing: limit?.doubleValue ?? 0.0)
        
        return result
    }
}
