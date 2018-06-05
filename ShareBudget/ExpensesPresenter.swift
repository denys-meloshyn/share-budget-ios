//
//  ExpensesPresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 05.06.2018.
//  Copyright © 2018 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

protocol ExpensesPresenterProtocol: BasePresenterProtocol, UITableViewDataSource, UITableViewDelegate {
    var delegate: ExpensesPresenterDelegate! { get set }
}

protocol ExpensesPresenterDelegate: BasePresenterDelegate {
    func refresh()
    func showCreateNewExpenseButton(action: @escaping BarButtonItemListenerActionBlock)
    func createExpenseDateSectionHeaderView(month: String?, expenses: String?) -> ExpenseTableViewHeader?
    func createExpenseTableViewCell(at indexPath: IndexPath, title: String?, price: String?, category: String?, budget: String?, date: String?) -> ExpenseTableViewCell?
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
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return interaction.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interaction.numberOfRows(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let expense = interaction.object(at: indexPath)
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2

        var date = ""
        if let creationDate = expense.creationDate as Date? {
            date = UtilityFormatter.expenseCreationFormatter.string(for: creationDate) ?? ""
        }

        let dict = interaction.budgetRest[indexPath.section]
        let cell = delegate?.createExpenseTableViewCell(at: indexPath,
                title: expense.name,
                price: UtilityFormatter.priceFormatter.string(for: expense.price),
                category: expense.category?.name,
                budget: dict[expense.modelID?.stringValue ?? ""],
                date: date)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let creationDate = interaction.date(for: section)
        let total = interaction.totalExpense(for: section)

        return delegate?.createExpenseDateSectionHeaderView(month: UtilityFormatter.yearMonthFormatter.string(from: creationDate as Date),
                expenses: UtilityFormatter.priceFormatter.string(for: total))
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let expense = interaction.object(at: indexPath)
        router.openEditExpenseViewController(budgetID: interaction.budget.objectID, expenseID: expense.objectID)
    }
}
