//
//  TeamMembersInteraction.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 18.07.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

class TeamMembersInteraction: BaseInteraction {
    var budget: Budget
    
    private let budgetID: NSManagedObjectID
    private var managedObjectContext: NSManagedObjectContext
    
    init(with budgetID: NSManagedObjectID, context: NSManagedObjectContext) {
        self.budgetID = budgetID
        self.managedObjectContext = context
        self.budget = self.managedObjectContext.object(with: budgetID) as! Budget
        
//        self.fetchedResultsController = ModelManager.expenseFetchController(for: budgetID, UtilityFormatter.firstMonthDay() as NSDate, self.managedObjectContext)
//        self.calculator = ExpenseCalculator(fetchedResultsController: self.fetchedResultsController)
//        
//        do {
//            try self.fetchedResultsController.performFetch()
//        }
//        catch {
//            Dependency.logger.error("Error fetch \(error)")
//        }
        
        super.init()
        
//        self.fetchedResultsController.delegate = self
    }

}
