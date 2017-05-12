//
//  BudgetPresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 28.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

enum BudgetHeaderMode {
    case search
    case create
}

protocol BudgetPresenterDelegate: BasePresenterDelegate, CreateSearchTableViewHeaderDataSource {
    func cancelSearch()
    func refreshData(for mode: BudgetHeaderMode)
    func createBudgetCell(with title: String?) -> UITableViewCell?
}

class BudgetPresenter: BasePresenter {
    weak var delegate: BudgetPresenterDelegate?
    
    fileprivate var budgetInteraction: BudgetInteraction {
        get {
            return self.interaction as! BudgetInteraction
        }
    }
    
    override init(with interaction: BaseInteraction, router: BaseRouter) {
        super.init(with: interaction, router: router)
        
        self.budgetInteraction.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate?.showTabBar(title: "Budgets", image: UIImage(), selected: UIImage())
        self.delegate?.showPage(title: "Budgets")
    }
    
    func headerMode() -> BudgetHeaderMode {
        let rows = self.budgetInteraction.numberOfRowsInSection()
        
        if rows > 0 {
            return .search
        }
        
        return .create
    }
}

// MARK: - BudgetInteractionDelegate

extension BudgetPresenter: BudgetInteractionDelegate {
    func willChangeContent() {
        self.delegate?.refreshData(for: self.headerMode())
    }
    
    func didChangeContent() {
        self.delegate?.refreshData(for: self.headerMode())
    }
    
    func changed(at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
}

// MARK: - UITableViewDataSource

extension BudgetPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.budgetInteraction.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let budget = self.budgetInteraction.budgetModel(for: indexPath)
        guard let cell = self.delegate?.createBudgetCell(with: budget.name) else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.delegate?.createSearchTableHeaderView(with: self.headerMode(), placeholder: LocalisedManager.groups.headerPlaceholder)
    }
}

// MARK: - UITableViewDelegate

extension BudgetPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let budget = self.budgetInteraction.budgetModel(for: indexPath)
        
        guard let router = self.router as? BudgetRouter else {
            return
        }
        
        router.openDetailPage(for: budget.objectID)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
}

// MARK: - CreateSearchTableViewHeaderDelegate

extension BudgetPresenter: CreateSearchTableViewHeaderDelegate {
    func textFieldPlaceholder() -> String? {
        return LocalisedManager.groups.headerPlaceholder
    }
    
    func textChanged(_ text: String) {
        self.budgetInteraction.updateWithSearch(text)
    }
    
    func createNewItem(_ title: String?) {
        guard let title = title, !title.isEmpty else {
            self.delegate?.cancelSearch()
            return
        }
        
        self.budgetInteraction.createNewBudget(with: title)
    }
    
    func modeButtonPressed(_ sender: CreateSearchTableViewHeader) {
        if self.headerMode() == .create {
            self.createNewItem(sender.textField?.text)
        }
    }
}
