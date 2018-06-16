//
//  ExpensesInteraction.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 05.06.2018.
//  Copyright © 2018 Denys Meloshyn. All rights reserved.
//

import CoreData

protocol ExpensesInteractionProtocol: BaseInteractionProtocol {
    var budget: Budget { get }
    var budgetRest: [[String: Double]] { get }
    var delegate: ExpensesInteractionDelegate? { get set }

    func numberOfSections() -> Int
    func date(for section: Int) -> NSDate
    func updateFilter(with value: String?)
    func totalExpense(for section: Int) -> Double
    func object(at indexPath: IndexPath) -> Expense
    func numberOfRows(inSection section: Int) -> Int
}

protocol ExpensesInteractionDelegate: BaseInteractionDelegate {
}

class ExpensesInteraction: BaseInteraction, ExpensesInteractionProtocol {
    let budget: Budget
    var category: Category?
    var budgetRest = [[String: Double]]()
    weak var delegate: ExpensesInteractionDelegate?

    private let logger: LoggerProtocol
    private let budgetID: NSManagedObjectID
    private var calculator: ExpenseCalculator
    private let categoryID: NSManagedObjectID?
    private let managedObjectContext: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<Expense>

    init(managedObjectContext: NSManagedObjectContext,
         budgetID: NSManagedObjectID,
         categoryID: NSManagedObjectID?,
         logger: LoggerProtocol) throws {
        self.logger = logger
        self.budgetID = budgetID
        self.categoryID = categoryID
        self.managedObjectContext = managedObjectContext
        fetchedResultsController = ModelManager.expenseFetchController(managedObjectContext, for: budgetID, categoryID: categoryID)
        calculator = ExpenseCalculator(fetchedResultsController: fetchedResultsController)

        if let categoryID = categoryID {
            guard let category = managedObjectContext.object(with: categoryID) as? Category else {
                throw ShareBudgetError.runtime("Wrong category object")
            }
            self.category = category
        }

        guard let budget = managedObjectContext.object(with: budgetID) as? Budget else {
            throw ShareBudgetError.runtime("Wrong budget object")
        }
        self.budget = budget

        super.init()

        performFetch()
        budgetRest = calculateBudgetRestForExpenses()
    }

    func numberOfSections() -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    func numberOfRows(inSection section: Int) -> Int {
        let sectionModel = fetchedResultsController.sections?[section]

        return sectionModel?.numberOfObjects ?? 0
    }

    func object(at indexPath: IndexPath) -> Expense {
        return fetchedResultsController.object(at: indexPath)
    }

    func date(for section: Int) -> NSDate {
        let sectionModel = fetchedResultsController.sections?[section]
        var expense: Expense? = nil

        if sectionModel?.numberOfObjects ?? 0 > 0 {
            expense = fetchedResultsController.object(at: IndexPath(row: 0, section: section))
        }

        return expense?.creationDate ?? NSDate()
    }

    func totalExpense(for section: Int) -> Double {
        return calculator.totalExpense(for: section)
    }

    func updateFilter(with value: String?) {
        fetchedResultsController = ModelManager.expenseFetchController(managedObjectContext,
                for: budgetID,
                categoryID: categoryID,
                searchText: value)
        calculator = ExpenseCalculator(fetchedResultsController: fetchedResultsController)

        performFetch()
        delegate?.didChangeContent()
    }

    func calculateBudgetRestForExpenses() -> [[String: Double]] {
        var result = [[String: Double]]()
        let sections = fetchedResultsController.sections ?? [NSFetchedResultsSectionInfo]()
        for section in 0..<sections.count {
            let firstExpense = fetchedResultsController.object(at: IndexPath(row: 0, section: section))
            let date = firstExpense.creationDate ?? NSDate()
            let lastLimit = ModelManager.lastLimit(for: budgetID, date: date, managedObjectContext)
            let total = lastLimit?.limit?.doubleValue ?? 0.0
            var rest = total

            var rowDict = [String: Double]()
            let fetchedResultsSectionInfo = sections[section]
            for i in 0..<fetchedResultsSectionInfo.numberOfObjects {
                let indexPath = IndexPath(row: fetchedResultsSectionInfo.numberOfObjects - i - 1, section: section)
                let expense = fetchedResultsController.object(at: indexPath)

                rest -= expense.price?.doubleValue ?? 0.0
                rowDict[expense.modelID?.stringValue ?? ""] = rest
            }
            result.append(rowDict)
        }

        return result
    }

    private func performFetch() {
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            logger.logError("Can't perform fetch request")
        }
    }
}

extension ExpensesInteraction: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.willChangeContent()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        budgetRest = calculateBudgetRestForExpenses()
        delegate?.didChangeContent()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
    }
}
