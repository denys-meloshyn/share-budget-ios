//
//  CategoryInteraction.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 26.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData

protocol CategoryInteractionDelegate: BaseInteractionDelegate {
}

protocol CategoryInteractionProtocol: BaseInteractionProtocol {
    var expense: Expense { get set }
    weak var delegate: CategoryInteractionDelegate? { get set }
    
    func numberOfCategories() -> Int
    func updateWithSearch(_ text: String)
    func createCategory(with name: String) -> Category
    func category(for indexPath: IndexPath) -> Category
}

class CategoryInteraction: BaseInteraction, CategoryInteractionProtocol {
    var expense: Expense
    weak var delegate: CategoryInteractionDelegate?
    let managedObjectContext: NSManagedObjectContext
    var fetchedResultsController: NSFetchedResultsController<Category>!
    
    private var expenseID: NSManagedObjectID!
    
    init(with expenseID: NSManagedObjectID, managedObjectContext: NSManagedObjectContext) {
        self.expenseID = expenseID
        self.managedObjectContext = managedObjectContext
        expense = managedObjectContext.object(with: expenseID) as! Expense
        
        super.init()
        
        fetchedResultsController = ModelManager.categoryFetchController(managedObjectContext)
        fetchedResultsController.delegate = self
        
        updatePredicate(with: "")
    }
    
    private func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            Dependency.logger.error("Error fetch \(error)")
        }
    }
    
    private func updatePredicate(with text: String) {
        var predicates = [NSPredicate]()
        var tmpPredicate = NSPredicate(format: "%@ == budget", expense.budget!)
        predicates.append(tmpPredicate)
        
        predicates.append(ModelManager.removePredicate())
        
        let predicate: NSPredicate
        if !text.isEmpty {
            tmpPredicate = NSPredicate(format: "name CONTAINS[c] %@", text)
            predicates.append(tmpPredicate)
        }
        
        predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchedResultsController.fetchRequest.predicate = predicate
        performFetch()
        
        delegate?.didChangeContent()
    }
    
    func numberOfCategories() -> Int {
        let sections = fetchedResultsController.sections
        let section = sections?.first
        
        return section?.numberOfObjects ?? 0
    }
    
    func category(for indexPath: IndexPath) -> Category {
        let model = fetchedResultsController.object(at: indexPath)
        
        return model
    }
    
    func updateWithSearch(_ text: String) {
        updatePredicate(with: text)
    }
    
    func createCategory(with name: String) -> Category {
        let category = Category(context: managedObjectContext)
        category.isChanged = true
        category.name = name
        
        category.budget = expense.budget
        expense.budget?.addToCategories(category)
        
        return category
    }
}

// MARK: - NSFetchedResultsControllerDelegate methds

extension CategoryInteraction: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.willChangeContent()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didChangeContent()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    }
}
