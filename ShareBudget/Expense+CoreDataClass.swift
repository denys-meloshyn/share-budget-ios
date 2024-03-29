//
//  Expense+CoreDataClass.swift
//
//
//  Created by Denys Meloshyn on 15.01.17.
//
//

import CoreData
import Foundation

@objc(Expense)
public class Expense: BaseModel {
    override class func modelKeyID() -> String {
        return Constants.key.json.expenseID
    }

    override public func didChangeValue(forKey key: String) {
        super.didChangeValue(forKey: key)

        if key == "creationDate" {
            willAccessValue(forKey: "creationDate")
            if let creationDate = self.creationDate as Date? {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy MM"

                let section = dateFormatter.string(from: creationDate)

                willChangeValue(forKey: "sectionCreationDate")
                sectionCreationDate = section
                didChangeValue(forKey: "sectionCreationDate")

                willChangeValue(forKey: "creationDateSearch")
                creationDateSearch = UtilityFormatter.expenseCreationFormatter.string(for: creationDate) ?? ""
                didChangeValue(forKey: "creationDateSearch")
            }
            didAccessValue(forKey: "creationDate")
        }
    }

    override func update(with dict: [String: Any?], in managedObjectContext: NSManagedObjectContext) {
        super.update(with: dict, in: managedObjectContext)
        configureModelID(dict: dict, for: Constants.key.json.expenseID)

        if let budgetID = dict[Constants.key.json.groupID] as? Int {
            budget = ModelManager.findEntity(Budget.self, by: budgetID, in: managedObjectContext) as? Budget
            budget?.addToExpenses(self)
        }

        if let categoryID = dict[Constants.key.json.categoryID] as? Int {
            category = ModelManager.findEntity(Category.self, by: categoryID, in: managedObjectContext) as? Category
            category?.addToExpenses(self)
        }

        if let date = dict[Constants.key.json.creationDate] as? String {
            creationDate = UtilityFormatter.pareseDateFormatter.date(from: date) as NSDate?
        }

        name = dict[Constants.key.json.name] as? String
        price = NSNumber(value: dict[Constants.key.json.price] as? Double ?? 0.0)
    }

    override func uploadProperties() -> [String: String] {
        var result = super.uploadProperties()

        result[Constants.key.json.price] = String(price?.doubleValue ?? 0.0)

        if let modelID = self.modelID {
            result[Constants.key.json.expenseID] = String(modelID.intValue)
        }

        if let name = self.name {
            result[Constants.key.json.name] = name
        }

        if let modelID = budget?.modelID {
            result[Constants.key.json.groupID] = String(modelID.intValue)
        }

        if let categoryID = category?.modelID {
            result[Constants.key.json.categoryID] = String(categoryID.intValue)
        }

        if let creationDate = self.creationDate as Date? {
            result[Constants.key.json.creationDate] = UtilityFormatter.iso8601DateFormatter.string(from: creationDate)
        }

        return result
    }
}
