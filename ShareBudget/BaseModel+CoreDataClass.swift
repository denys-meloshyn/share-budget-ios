//
//  BaseModel+CoreDataClass.swift
//
//
//  Created by Denys Meloshyn on 15.01.17.
//
//

import CoreData
import Foundation

@objc(BaseModel)
public class BaseModel: NSManagedObject {
    class func modelKeyID() -> String {
        return ""
    }

    func update(with dict: [String: Any?], in _: NSManagedObjectContext) {
        if let isRemoved = dict[Constants.key.json.isRemoved] as? Bool {
            self.isRemoved = NSNumber(value: isRemoved)
        }

        timestamp = dict[Constants.key.json.timeStamp] as? String
    }

    func configureModelID(dict: [String: Any?], for key: String) {
        if let modelID = dict[key] as? Int {
            self.modelID = NSNumber(value: modelID)
        }
    }

    func uploadProperties() -> [String: String] {
        var result = [String: String]()

        if let isRemoved = self.isRemoved {
            result[Constants.key.json.isRemoved] = isRemoved.boolValue.description
        }

        return result
    }
}

extension BaseModel: PrimaryKeyProtocol {
    func primaryKey() -> String {
        Self.modelKeyID()
    }
}
