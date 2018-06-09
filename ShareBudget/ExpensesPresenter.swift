//
//  ExpensesPresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 05.06.2018.
//  Copyright © 2018 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

protocol ExpensesPresenterProtocol: BasePresenterProtocol {
    var delegate: ExpensesPresenterDelegate! { get set }

    func expenseSelected(at indexPath: IndexPath)
    func interaction() -> ExpensesInteractionProtocol
    func headerViewModel(for section: Int) -> ExpenseTableViewHeaderViewModel
    func cellViewModel(for indexPath: IndexPath) -> ExpenseTableViewCellViewModel
}

struct ExpenseTableViewCellViewModel {
    var date: String?
    var title: String?
    var price: String?
    var budget: String?
    var category: String?
}

struct ExpenseTableViewHeaderViewModel {
    var month: String?
    var expenses: String?
}

protocol ExpensesPresenterDelegate: BasePresenterDelegate {
    func refresh()
    func showCreateNewExpenseButton(action: @escaping BarButtonItemListenerActionBlock)
}

class ExpensesPresenter<Interaction: ExpensesInteractionProtocol, Router: ExpensesRouterProtocol>: BasePresenter<Interaction, Router>, ExpensesPresenterProtocol, ExpensesInteractionDelegate {
    weak var delegate: ExpensesPresenterDelegate!

    func viewDidLoad() {
        interaction.delegate = self
        
        delegate.showPage(title: interaction.budget.name)
        delegate.showCreateNewExpenseButton { _ in
            self.router.openCreateExpenseViewController(budgetID: self.interaction.budget.objectID)
        }
    }
    
    func viewWillAppear(_ animated: Bool) {
    }
    
    func viewDidAppear(_ animated: Bool) {
    }
    
    func viewWillDisappear(_ animated: Bool) {
    }
    
    func viewDidDisappear(_ animated: Bool) {
    }
    
    func didChangeContent() {
        delegate.refresh()
    }
    
    func willChangeContent() {
    }
    
    func changed(at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    }

    func interaction() -> ExpensesInteractionProtocol {
        return interaction
    }

    func cellViewModel(for indexPath: IndexPath) -> ExpenseTableViewCellViewModel {
        let expense = interaction.object(at: indexPath)

        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2

        var date = ""
        if let creationDate = expense.creationDate as Date? {
            date = UtilityFormatter.expenseCreationFormatter.string(for: creationDate) ?? ""
        }
        let dict = interaction.budgetRest[indexPath.section]

        return ExpenseTableViewCellViewModel(date: date,
                title: expense.name,
                price: UtilityFormatter.priceFormatter.string(for: expense.price),
                budget: dict[expense.modelID?.stringValue ?? ""],
                category: expense.category?.name)
    }

    func headerViewModel(for section: Int) -> ExpenseTableViewHeaderViewModel {
        let creationDate = interaction.date(for: section)
        let total = interaction.totalExpense(for: section)

        return ExpenseTableViewHeaderViewModel(month: UtilityFormatter.yearMonthFormatter.string(from: creationDate as Date),
                expenses: UtilityFormatter.priceFormatter.string(for: total))
    }

    func expenseSelected(at indexPath: IndexPath) {
        let expense = interaction.object(at: indexPath)
        router.openEditExpenseViewController(budgetID: interaction.budget.objectID, expenseID: expense.objectID)
    }
}
