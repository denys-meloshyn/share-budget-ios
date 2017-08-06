//
//  Budget+CoreDataClass.swift
//  
//
//  Created by Denys Meloshyn on 29.01.17.
//
//

import Foundation
import CoreData

@objc(Budget)
public class Budget: BaseModel {
    override class func modelKeyID() -> String {
        return kGroupID
    }
    
    override func update(with dict: [String: AnyObject?], in managedObjectContext: NSManagedObjectContext) {
        super.update(with: dict, in: managedObjectContext)
        self.configureModelID(dict: dict, for: kGroupID)
        
        self.name = dict[kName] as? String
    }
    
    override func uploadProperties() -> [String : String] {
        var result = super.uploadProperties()
        
        if let modelID = self.modelID {
            result[kGroupID] = String(modelID.intValue)
        }
        
        if let name = self.name {
            result[kName] = name
        }
        
        return result
    }
    
    func lastMonthLimit() -> BudgetLimit? {
        let limits = self.limits?.allObjects as? [BudgetLimit] ?? []
        let sort = limits.sorted(by: { (first, second) -> Bool in
            guard let firstDate = first.date as Date?, let secondDate = second.date as Date? else {
                return false
            }
            
            let res = firstDate.compare(secondDate)
            
            if res == .orderedAscending {
                return true
            }
            
            return false
        })
        
        return sort.last
    }
    
    func limit(for date: Date) -> BudgetLimit? {
        let limits = self.limits?.allObjects as? [BudgetLimit] ?? []
        let sort = limits.sorted(by: { (first, second) -> Bool in
            guard let firstDate = first.date as Date?, let secondDate = second.date as Date? else {
                return false
            }
            
            let res = firstDate.compare(secondDate)
            
            if res == .orderedAscending {
                return true
            }
            
            return false
        })
        
        let calendar = Calendar.current
        let units = Set<Calendar.Component>([.year, .month])
        let items = sort.filter { limit -> Bool in
            guard let limitDate = limit.date as Date? else {
                return false
            }
            
            var dateCurrentComponents = calendar.dateComponents(units, from: date)
            var limitCurrentComponents = calendar.dateComponents(units, from: limitDate)
            
            return dateCurrentComponents.year! >= limitCurrentComponents.year! && dateCurrentComponents.month! >= limitCurrentComponents.month!
        }
        
        return items.last
    }
}
