//
//  BudgetDetailInteraction.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 03.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData
import XCGLogger

protocol BudgetDetailInteractionDelegate: BaseInteractionDelegate {
    func limitChanged()
}

class BudgetDetailInteraction: BaseInteraction {
    var budget: Budget
    let budgetID: NSManagedObjectID
    weak var delegate: BudgetDetailInteractionDelegate?
    
    private var kvoContext: UInt8 = 1
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
        
        super.init()
        
        self.fetchedResultsController.delegate = self
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
    
    func createOrUpdateCurrentBudgetLimit(_ limit: Double) {
        var budgetLimit = self.lastMonthLimit()
        if budgetLimit == nil {
            budgetLimit = BudgetLimit(context: self.managedObjectContext)
            budgetLimit?.date = NSDate()
            
            self.budget.addToLimits(budgetLimit!)
        }
        
        budgetLimit?.limit = limit
        budgetLimit?.isChanged = true
        
        ModelManager.saveContext(self.managedObjectContext)
    }
    
    private func isCurrentMonth(_ date: NSDate) -> Bool {
        let calendar = Calendar.current
        let units = Set<Calendar.Component>([.year, .month, .day])
        
        var inputComponents = calendar.dateComponents(units, from: date as Date)
        inputComponents.calendar = calendar
        
        var currentComponents = calendar.dateComponents(units, from: Date())
        currentComponents.calendar = calendar
        
        return (inputComponents.month == currentComponents.month && inputComponents.year == currentComponents.year)
    }
}

// MARK: - NSFetchedResultsControllerDelegate methds

extension BudgetDetailInteraction: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
}
