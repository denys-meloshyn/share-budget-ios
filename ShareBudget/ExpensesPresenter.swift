//
//  ExpensesPresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 05.06.2018.
//  Copyright © 2018 Denys Meloshyn. All rights reserved.
//

import CoreData
import UIKit

protocol ExpensesPresenterProtocol: BasePresenterProtocol {
    var delegate: ExpensesPresenterDelegate! { get set }

    func updateSearchText(newValue: String?)
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
    var highlightedText: String?
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

    private var searchText: String?

    func viewDidLoad() {
        interaction.delegate = self

        delegate.showPage(title: interaction.budget.name)
        delegate.showCreateNewExpenseButton { _ in
            self.router.openCreateExpenseViewController(budgetID: self.interaction.budget.objectID)
        }
    }

    func viewWillAppear(_: Bool) {}

    func viewDidAppear(_: Bool) {}

    func viewWillDisappear(_: Bool) {}

    func viewDidDisappear(_: Bool) {}

    func didChangeContent() {
        delegate.refresh()
    }

    func willChangeContent() {}

    func changed(at _: IndexPath?, for _: NSFetchedResultsChangeType, newIndexPath _: IndexPath?) {}

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

        var moneyLeft = ""
        if let left = dict[expense.modelID?.stringValue ?? ""] {
            moneyLeft = String(left)
        }

        return ExpenseTableViewCellViewModel(date: date,
                                             title: expense.name,
                                             price: UtilityFormatter.priceFormatter.string(for: expense.price),
                                             budget: moneyLeft,
                                             category: expense.category?.name,
                                             highlightedText: searchText)
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

    func updateSearchText(newValue: String?) {
        searchText = newValue
        interaction.updateFilter(with: searchText)
    }
}
