//
//  BudgetDetailInteraction.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 03.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData

protocol BudgetDetailInteractionDelegate: BaseInteractionDelegate {
    func limitChanged()
}

class BudgetDetailInteraction: BaseInteraction {
    var budget: Budget
    let budgetID: NSManagedObjectID
    weak var delegate: BudgetDetailInteractionDelegate?
    
    private let calculator: ExpenseCalculator
    private let managedObjectContext: NSManagedObjectContext
    private let fetchedResultsController: NSFetchedResultsController<Expense>
    
    init(with budgetID: NSManagedObjectID, managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        self.budgetID = budgetID
        self.budget = self.managedObjectContext.object(with: budgetID) as! Budget
        
        self.fetchedResultsController = ModelManager.expenseFetchController(for: budgetID,
                                                                            startDate: UtilityFormatter.firstMonthDay() as NSDate,
                                                                            finishDate: UtilityFormatter.lastMonthDay() as NSDate,
                                                                            managedObjectContext: self.managedObjectContext)
        self.calculator = ExpenseCalculator(fetchedResultsController: self.fetchedResultsController)
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            Dependency.logger.error("Error fetch \(error)")
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
    
    func category(for section: Int) -> Category? {
        let expense = self.fetchedResultsController.object(at: IndexPath(row: 0, section: section))
        
        return expense.category
    }
    
    func categoryTitle(for section: Int) -> String {
        let section = self.fetchedResultsController.sections![section]
        
        return section.name
    }
    
    func totalExpenses() -> Double {
        return self.calculator.totalExpenses()
    }
    
    func lastMonthLimit() -> BudgetLimit? {
        return ModelManager.lastLimit(for: self.budgetID, self.managedObjectContext)
    }
    
    func balance() -> Double {
        let limit = self.lastMonthLimit()?.limit?.doubleValue ?? 0.0
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
        
        guard var newLimit = budgetLimit else {
            return
        }
        
        let calendar = Calendar.current
        let units = Set<Calendar.Component>([.year, .month])
        var currentComponents = calendar.dateComponents(units, from: Date())
        var lastMonthComponents = calendar.dateComponents(units, from: (newLimit.date as Date?) ?? Date())
        
        if currentComponents.year != lastMonthComponents.year || currentComponents.month != lastMonthComponents.month {
            // We don't have budget limit for current month
            newLimit = BudgetLimit(context: self.managedObjectContext)
            newLimit.budget = self.budget
            newLimit.date = NSDate()
            self.budget.addToLimits(newLimit)
        }
        
        newLimit.limit = NSNumber(value: limit)
        newLimit.isChanged = true
        
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
        self.delegate?.didChangeContent?()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
}
