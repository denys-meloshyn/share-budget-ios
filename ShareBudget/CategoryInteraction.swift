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
    var expense: Expense
    var delegate: CategoryInteractionDelegate?
    let managedObjectContext: NSManagedObjectContext
    var fetchedResultsController: NSFetchedResultsController<Category>!
    
    private var expenseID: NSManagedObjectID!
    
    init(with expenseID: NSManagedObjectID, managedObjectContext: NSManagedObjectContext) {
        self.expenseID = expenseID
        self.managedObjectContext = managedObjectContext
        self.expense = self.managedObjectContext.object(with: expenseID) as! Expense
        
        super.init()
        
        self.fetchedResultsController = ModelManager.categoryFetchController(self.managedObjectContext)
        self.fetchedResultsController.delegate = self
        
        self.updatePredicate(with: "")
    }
    
    private func performFetch() {
        do {
            try self.fetchedResultsController.performFetch()
        }
        catch {
            XCGLogger.error("Error fetch \(error)")
        }
    }
    
    private func updatePredicate(with text: String) {
        let predicate: NSPredicate
        if text.characters.count > 0 {
            predicate = NSPredicate(format: "name CONTAINS[c] %@ AND %@ == budget", text, self.expense.budget!)
        }
        else {
            predicate = NSPredicate(format: "%@ == budget", self.expense.budget!)
        }
        
        self.fetchedResultsController.fetchRequest.predicate = predicate
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
        self.updatePredicate(with: text)
    }
    
    func createCategory(with name: String?) -> Category {
        let category = Category(context: self.managedObjectContext)
        category.isChanged = true
        category.name = name
        
        category.budget = self.expense.budget
        self.expense.budget?.addToCategories(category)
        
        return category
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
