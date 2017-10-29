//
//  BudgetInteraction.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 28.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

protocol BudgetInteractionDelegate: BaseInteractionDelegate {
    
}

class BudgetInteraction: BaseInteraction {
    weak var delegate: BudgetInteractionDelegate?
    let managedObjectContext: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<Budget>
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        self.fetchedResultsController = ModelManager.budgetFetchController(self.managedObjectContext)
        
        super.init()
        
        self.performFetch()
    }
    
    private func performFetch() {
        self.fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            Dependency.logger.error("Can't perform fetch request")
        }
    }
    
    private func createFetchedResultsController(with text: String) {
        self.fetchedResultsController = ModelManager.budgetFetchController(self.managedObjectContext, search: text)
        self.performFetch()
        self.delegate?.didChangeContent?()
    }
    
    func numberOfRowsInSection() -> Int {
        guard let section = self.fetchedResultsController.sections?.first else {
            return 0
        }
        
        return section.numberOfObjects
    }
    
    func budgetModel(for indexPath: IndexPath) -> Budget {
        let budget = self.fetchedResultsController.object(at: indexPath)
        
        return budget
    }
    
    func updateWithSearch(_ text: String) {
        self.createFetchedResultsController(with: text)
    }
    
    func createNewBudget(with name: String) -> Budget {
        let budget = Budget(context: self.managedObjectContext)
        budget.name = name
        budget.isChanged = true
        
        return budget
    }
}

// MARK: - NSFetchedResultsControllerDelegate methds

extension BudgetInteraction: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate?.willChangeContent?()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate?.didChangeContent?()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
}
