//
//  CategoryInteraction.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 26.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData
import XCGLogger

protocol CategoryInteractionDelegate: BaseInteractionDelegate {
    
}

class CategoryInteraction: BaseInteraction {
    var budget: Budget
    var delegate: CategoryInteractionDelegate?
    let managedObjectContext: NSManagedObjectContext
    var fetchedResultsController: NSFetchedResultsController<Category>!
    
    private var budgetID: NSManagedObjectID!
    
    init(with budgetID: NSManagedObjectID, managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        self.budget = self.managedObjectContext.object(with: budgetID) as! Budget
        
        super.init()
        self.createFetchedResultsController(with: "")
    }
    
    private func performFetch() {
        self.fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
        }
        catch {
            XCGLogger.error("Error fetch \(error)")
        }
    }

    
    private func createFetchedResultsController(with text: String) {
        self.fetchedResultsController = ModelManager.categoryFetchController(self.managedObjectContext, for: self.budgetID, search: text)
        self.performFetch()
        self.delegate?.didChangeContent()
    }
    
    func numberOfCategories() -> Int {
        let sections = self.fetchedResultsController.sections
        let section = sections?.first
        
        return section?.numberOfObjects ?? 0
    }
    
    func category(for indexPath: IndexPath) -> Category {
        let model = self.fetchedResultsController.object(at: indexPath)
        
        return model
    }
    
    func updateWithSearch(_ text: String) {
        self.createFetchedResultsController(with: text)
    }
}

// MARK: - NSFetchedResultsControllerDelegate methds

extension CategoryInteraction: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate?.willChangeContent()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate?.didChangeContent()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
}
