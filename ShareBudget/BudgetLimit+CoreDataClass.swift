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
    override func update(with dict: [String: AnyObject?], in managedObjectContext: NSManagedObjectContext) {
        super.update(with: dict, in: managedObjectContext)
        self.configureModelID(dict: dict, for: kBudgetLimitID)
        
        self.limit = (dict[kLimit] as? Double) ?? 0.0
        
        if let date = dict[kDate] as? String {
            self.date = UtilityFormatter.date(from: date) as NSDate?
        }
    }
    
    override func uploadProperties() -> [String : String] {
        var result = super.uploadProperties()
        
        if let modelID = self.modelID {
            result[kBudgetLimitID] = String(modelID.intValue)
        }
        
        if let date = self.date as Date? {
            result[kDate] = UtilityFormatter.string(from: date)
        }
        
        if let groupID = self.budget?.modelID {
            result[kGroupID] = String(groupID.intValue)
        }
        
        result[kLimit] = String(limit)
        
        return result
    }
}
