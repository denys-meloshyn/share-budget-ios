//
//  BudgetDetailInteraction.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 03.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData

protocol BudgetDetailInteractionDelegate: BaseInteractionDelegate {
    func limitChanged()
}

protocol BudgetDetailInteractionProtocol: BaseInteractionProtocol {
    var budget: Budget { get set }
    var budgetID: NSManagedObjectID { get }
    var delegate: BudgetDetailInteractionDelegate? { get set }

    func isEmpty() -> Bool
    func balance() -> Double
    func totalExpenses() -> Double
    func lastMonthLimit() -> BudgetLimit?
    func numberOfCategoryExpenses() -> Int
    func category(for section: Int) -> Category?
    func categoryTitle(for section: Int) -> String
    func totalExpenses(for categoryIndex: Int) -> Double
    func createOrUpdateCurrentBudgetLimit(_ limit: Double)
}

class BudgetDetailInteraction: BaseInteraction, BudgetDetailInteractionProtocol, NSFetchedResultsControllerDelegate {
    var budget: Budget
    let budgetID: NSManagedObjectID
    weak var delegate: BudgetDetailInteractionDelegate?

    private let calculator: ExpenseCalculator
    private let managedObjectContext: NSManagedObjectContext
    private let fetchedResultsController: NSFetchedResultsController<Expense>

    init(with budgetID: NSManagedObjectID, managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        self.budgetID = budgetID
        budget = self.managedObjectContext.object(with: budgetID) as! Budget

        fetchedResultsController = ModelManager.expenseFetchController(for: budgetID,
                                                                       startDate: UtilityFormatter.firstMonthDay() as NSDate,
                                                                       finishDate: UtilityFormatter.lastMonthDay() as NSDate,
                                                                       managedObjectContext: self.managedObjectContext)
        calculator = ExpenseCalculator(fetchedResultsController: fetchedResultsController)

        do {
            try fetchedResultsController.performFetch()
        } catch {
            Dependency.logger.error("Error fetch \(error)")
        }

        super.init()

        fetchedResultsController.delegate = self
    }

    func isEmpty() -> Bool {
        return numberOfCategoryExpenses() == 0
    }

    func totalExpenses(for categoryIndex: Int) -> Double {
        return calculator.totalExpense(for: categoryIndex)
    }

    func numberOfCategoryExpenses() -> Int {
        let sections = fetchedResultsController.sections ?? []

        return sections.count
    }

    func category(for section: Int) -> Category? {
        let expense = fetchedResultsController.object(at: IndexPath(row: 0, section: section))

        return expense.category
    }

    func categoryTitle(for section: Int) -> String {
        let section = fetchedResultsController.sections![section]

        return section.name
    }

    func totalExpenses() -> Double {
        return calculator.totalExpenses()
    }

    func lastMonthLimit() -> BudgetLimit? {
        return ModelManager.lastLimit(for: budgetID, managedObjectContext)
    }

    func balance() -> Double {
        let limit = lastMonthLimit()?.limit?.doubleValue ?? 0.0
        let balance = limit - totalExpenses()

        return balance
    }

    func createOrUpdateCurrentBudgetLimit(_ limit: Double) {
        var budgetLimit = lastMonthLimit()
        if budgetLimit == nil {
            budgetLimit = BudgetLimit(context: managedObjectContext)
            budgetLimit?.date = NSDate()

            budget.addToLimits(budgetLimit!)
        }

        guard var newLimit = budgetLimit else {
            return
        }

        let calendar = Calendar.current
        let units = Set<Calendar.Component>([.year, .month])
        var currentComponents = calendar.dateComponents(units, from: Date())
        var lastMonthComponents = calendar.dateComponents(units, from: (newLimit.date as Date?) ?? Date())

        if currentComponents.year != lastMonthComponents.year || currentComponents.month != lastMonthComponents.month {
            // We don't have budget limit for current month
            newLimit = BudgetLimit(context: managedObjectContext)
            newLimit.budget = budget
            newLimit.date = NSDate()
            budget.addToLimits(newLimit)
        }

        newLimit.limit = NSNumber(value: limit)
        newLimit.isChanged = true

        ModelManager.saveContext(managedObjectContext)
    }

    private func isCurrentMonth(_ date: NSDate) -> Bool {
        let calendar = Calendar.current
        let units = Set<Calendar.Component>([.year, .month, .day])

        var inputComponents = calendar.dateComponents(units, from: date as Date)
        inputComponents.calendar = calendar

        var currentComponents = calendar.dateComponents(units, from: Date())
        currentComponents.calendar = calendar

        return (inputComponents.month == currentComponents.month && inputComponents.year == currentComponents.year)
    }

    func controllerWillChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {}

    func controllerDidChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didChangeContent()
    }

    func controller(_: NSFetchedResultsController<NSFetchRequestResult>, didChange _: Any, at _: IndexPath?, for _: NSFetchedResultsChangeType, newIndexPath _: IndexPath?) {}
}
