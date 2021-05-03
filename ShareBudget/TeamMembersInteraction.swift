//
//  TeamMembersInteraction.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 18.07.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData
import UIKit

protocol TeamMembersInteractionProtocol: BaseInteractionProtocol {
    var delegate: BaseInteractionDelegate? { get set }

    func save()
    func userCount() -> Int
    func userGroup(at indexPath: IndexPath) -> UserGroup
}

class TeamMembersInteraction: BaseInteraction, TeamMembersInteractionProtocol, NSFetchedResultsControllerDelegate {
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

    func controllerWillChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.willChangeContent()
    }

    func controllerDidChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didChangeContent()
    }

    func controller(_: NSFetchedResultsController<NSFetchRequestResult>, didChange _: Any, at _: IndexPath?, for _: NSFetchedResultsChangeType, newIndexPath _: IndexPath?) {}
}
