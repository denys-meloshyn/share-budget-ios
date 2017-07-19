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
    
    private var managedObjectContext: NSManagedObjectContext
    private let fetchedResultsController: NSFetchedResultsController<User>
    
    init(with budgetID: NSManagedObjectID, context: NSManagedObjectContext) {
        self.managedObjectContext = context
        self.budget = self.managedObjectContext.object(with: budgetID) as! Budget
        
        self.fetchedResultsController = ModelManager.teamMembersFetchController(self.managedObjectContext, for: budgetID)
        
        super.init()
        
        self.performFetch()
    }
    
    private func performFetch() {
        self.fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
        }
        catch {
            Dependency.logger.error("Can't perform fetch request")
        }
    }
    
    func userCount() -> Int {
        guard let section = self.fetchedResultsController.sections?.first else {
            return 0
        }
        
        return section.numberOfObjects
    }
    
    func user(at indexPath: IndexPath) -> User {
        return self.fetchedResultsController.object(at: indexPath)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TeamMembersInteraction: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
}
