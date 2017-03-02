//
//  ExpenseCalculator.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 02.03.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData

class ExpenseCalculator {
    private let fetchedResultsController: NSFetchedResultsController<Expense>
    
    init(fetchedResultsController: NSFetchedResultsController<Expense>) {
        self.fetchedResultsController = fetchedResultsController
    }
    
    func totalExpenses() -> Double {
        var total = 0.0
        let sections = self.fetchedResultsController.sections ?? []
        for i in 0..<sections.count {
            total += self.totalExpense(for: i)
        }
        
        return total
    }
    
    func totalExpense(for section: Int) -> Double {
        let sections = self.fetchedResultsController.sections!
        let sectionModel = sections[section]
        
        var total = 0.0
        for i in 0..<sectionModel.numberOfObjects {
            let indexPath = IndexPath(row: i, section: section)
            let expense = self.fetchedResultsController.object(at: indexPath)
            total += expense.price
        }
        
        return total
    }
}
