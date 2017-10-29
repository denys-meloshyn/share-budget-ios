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
    weak var delegate: BaseInteractionDelegate?
    
    private var managedObjectContext: NSManagedObjectContext
    private let fetchedResultsController: NSFetchedResultsController<UserGroup>
    
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
        } catch {
            Dependency.logger.error("Can't perform fetch request")
        }
    }
    
    func userCount() -> Int {
        guard let section = self.fetchedResultsController.sections?.first else {
            return 0
        }
        
        return section.numberOfObjects
    }
    
    func userGroup(at indexPath: IndexPath) -> UserGroup {
        return self.fetchedResultsController.object(at: indexPath)
    }
    
    func save() {
        ModelManager.saveContext(self.managedObjectContext)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TeamMembersInteraction: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate?.willChangeContent?()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate?.didChangeContent?()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
}
