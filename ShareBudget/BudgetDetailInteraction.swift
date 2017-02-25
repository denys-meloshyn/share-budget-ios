//
//  BudgetDetailInteraction.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 03.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData
import XCGLogger

class BudgetDetailInteraction: BaseInteraction {
    var budget: Budget
    var budgetID: NSManagedObjectID
    let managedObjectContext = ModelManager.managedObjectContext
    let fetchedResultsController: NSFetchedResultsController<Expense>
    
    init(with budgetID: NSManagedObjectID) {
        self.budgetID = budgetID
        self.budget = self.managedObjectContext.object(with: budgetID) as! Budget
        
        self.fetchedResultsController = ModelManager.expenseFetchController(for: budgetID, UtilityFormatter.firstMonthDay() as NSDate, self.managedObjectContext)
        do {
            try self.fetchedResultsController.performFetch()
        }
        catch {
            XCGLogger.error("Error fetch \(error)")
        }
    }
    
    func isEmpty() -> Bool {
        return self.numberOfCategoryExpenses() == 0
    }
    
    func totalExpenses(for categoryIndex: Int) -> Double {
        return 100.0
    }
    
    func numberOfCategoryExpenses() -> Int {
        let sections = self.fetchedResultsController.sections ?? []
        
        return sections.count
    }
    
    func totalExpenses() -> Double {
        var total = 0.0
        let sections = self.fetchedResultsController.sections ?? []
        for i in 0..<sections.count {
            let section = sections[i]
            for j in 0..<section.numberOfObjects {
                let indexPath = IndexPath(row: i, section: j)
                let expense = self.fetchedResultsController.object(at: indexPath)
                total += expense.price
            }
        }
        
        return total
    }
    
    func lastMonthLimit() -> BudgetLimit? {
        let limits = self.budget.limits?.allObjects as? [BudgetLimit] ?? []
        let sort = limits.sorted(by: { (first, second) -> Bool in
            guard let firstDate = first.date as? Date, let secondDate = second.date as? Date else {
                return false
            }
            
            let res = firstDate.compare(secondDate)
            
            if res == .orderedAscending {
                return true
            }
            
            return false
        })
        
        return sort.first
    }
    
    func balance() -> Double {
        let limit = self.lastMonthLimit()?.limit ?? 0.0
        let balance = limit - self.totalExpenses()
        
        return balance
    }
}
