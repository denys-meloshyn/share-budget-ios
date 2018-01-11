//
//  TeamMembersInteraction.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 18.07.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

protocol TeamMembersInteractionProtocol: BaseInteractionProtocol {
    weak var delegate: BaseInteractionDelegate? { get set }
    
    func save()
    func userCount() -> Int
    func userGroup(at indexPath: IndexPath) -> UserGroup
}

class TeamMembersInteraction: BaseInteraction, TeamMembersInteractionProtocol {
    var budget: Budget
    weak var delegate: BaseInteractionDelegate?
    
    private var managedObjectContext: NSManagedObjectContext
    private let fetchedResultsController: NSFetchedResultsController<UserGroup>
    
    init(with budgetID: NSManagedObjectID, context: NSManagedObjectContext) {
        managedObjectContext = context
        budget = managedObjectContext.object(with: budgetID) as! Budget
        
        fetchedResultsController = ModelManager.teamMembersFetchController(managedObjectContext, for: budgetID)
        
        super.init()
        
        performFetch()
    }
    
    private func performFetch() {
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            Dependency.logger.error("Can't perform fetch request")
        }
    }
    
    func userCount() -> Int {
        guard let section = fetchedResultsController.sections?.first else {
            return 0
        }
        
        return section.numberOfObjects
    }
    
    func userGroup(at indexPath: IndexPath) -> UserGroup {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func save() {
        ModelManager.saveContext(managedObjectContext)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TeamMembersInteraction: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.willChangeContent()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didChangeContent()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    }
}
