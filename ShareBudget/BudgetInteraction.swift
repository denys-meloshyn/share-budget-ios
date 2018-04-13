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

protocol BudgetInteractionProtocol: BaseInteractionProtocol, NSFetchedResultsControllerDelegate {
    var delegate: BudgetInteractionDelegate? { get set }
    
    func numberOfRowsInSection() -> Int
    func updateWithSearch(_ text: String)
    func createNewBudget(with name: String) -> Budget
    func budgetModel(for indexPath: IndexPath) -> Budget
}

class BudgetInteraction: BaseInteraction, BudgetInteractionProtocol {
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
        fetchedResultsController = ModelManager.budgetFetchController(self.managedObjectContext, search: text)
        performFetch()
        delegate?.didChangeContent()
    }
    
    func numberOfRowsInSection() -> Int {
        guard let section = fetchedResultsController.sections?.first else {
            return 0
        }
        
        return section.numberOfObjects
    }
    
    func budgetModel(for indexPath: IndexPath) -> Budget {
        let budget = fetchedResultsController.object(at: indexPath)
        
        return budget
    }
    
    func updateWithSearch(_ text: String) {
        createFetchedResultsController(with: text)
    }
    
    func createNewBudget(with name: String) -> Budget {
        let budget = Budget(context: managedObjectContext)
        budget.name = name
        budget.isChanged = true
        
        return budget
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.willChangeContent()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didChangeContent()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    }
}
