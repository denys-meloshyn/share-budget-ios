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
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.date = dateFormatter.date(from: date) as NSDate?
        }
    }
}
