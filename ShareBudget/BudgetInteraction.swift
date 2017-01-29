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
    let managedObjectContext = ModelManager.sharedInstance.managedObjectContext
    private let fetchedResultsController: NSFetchedResultsController<Budget>
    
    override init() {
        self.fetchedResultsController = ModelManager.budgetFetchController(self.managedObjectContext)
        
        super.init()
    }
    
    func numberOfRowsInSection() -> Int {
        guard let section = self.fetchedResultsController.sections?.first else {
            return 0
        }
        
        return section.numberOfObjects
    }
}

// MARK: - NSFetchedResultsControllerDelegate methds

extension BudgetInteraction: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate?.willChangeContent()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate?.didChangeContent()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
}
