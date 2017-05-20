//
//  BaseModel+CoreDataClass.swift
//  
//
//  Created by Denys Meloshyn on 15.01.17.
//
//

import Foundation
import CoreData

@objc(BaseModel)
public class BaseModel: NSManagedObject {
    class func modelKeyID() -> String {
        return ""
    }
    
    func update(with dict: [String: AnyObject?], in managedObjectContext: NSManagedObjectContext) {
        if let isRemoved = dict[kIsRemoved] as? Bool {
            self.isRemoved = isRemoved
        }
        
        self.timestamp = dict[kTimeStamp] as? String
    }
    
    func configureModelID(dict: [String: AnyObject?], for key: String) {
        if let modelID = dict[key] as? Int {
            self.modelID = NSNumber(value: modelID)
        }
    }
    
    func uploadProperties() -> [String: String] {
        var result = [String : String]()
        
        result[kIsRemoved] = String(self.isRemoved)
        
        return result
    }
}
