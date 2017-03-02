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
    let budgetID: NSManagedObjectID
    
    private let calculator: ExpenseCalculator
    private let managedObjectContext = ModelManager.managedObjectContext
    private let fetchedResultsController: NSFetchedResultsController<Expense>
    
    init(with budgetID: NSManagedObjectID) {
        self.budgetID = budgetID
        self.budget = self.managedObjectContext.object(with: budgetID) as! Budget
        
        self.fetchedResultsController = ModelManager.expenseFetchController(for: budgetID, UtilityFormatter.firstMonthDay() as NSDate, self.managedObjectContext)
        self.calculator = ExpenseCalculator(fetchedResultsController: self.fetchedResultsController)
        
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
        return self.calculator.totalExpense(for: categoryIndex)
    }
    
    func numberOfCategoryExpenses() -> Int {
        let sections = self.fetchedResultsController.sections ?? []
        
        return sections.count
    }
    
    func categoryTitle(for section: Int) -> String {
        let section = self.fetchedResultsController.sections![section]
        
        return section.name
    }
    
    func totalExpenses() -> Double {
        return self.calculator.totalExpenses()
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
