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

protocol BudgetPresenterDelegate: BasePresenterDelegate {
    func refreshData()
    func createBudgetCell(with title: String?) -> UITableViewCell?
    func createSearchTableHeaderView(with mode: BudgetHeaderMode) -> CreateSearchTableViewHeader?
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
        
        self.delegate?.showPage(title: "Budget")
    }
    
    func headerMode() -> BudgetHeaderMode {
        let rows = self.budgetInteraction.numberOfRowsInSection()
        
        if rows > 0 {
            return .search
        }
        
        return .create
    }
}

extension BudgetPresenter: BudgetInteractionDelegate {
    func willChangeContent() {
        self.delegate?.refreshData()
    }
    
    func didChangeContent() {
        self.delegate?.refreshData()
    }
    
    func changed(at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
}

// MARK: - UITableViewDataSource methods

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
        return self.delegate?.createSearchTableHeaderView(with: self.headerMode())
    }
}

// MARK: - UITableViewDelegate methods

extension BudgetPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

extension BudgetPresenter: CreateSearchTableViewHeaderDelegate {
    func textChanged(_ text: String) {
        self.budgetInteraction.updateWithSearch(text)
    }
    
    func createNewBudget(_ title: String?) {
        self.budgetInteraction.createNewBudget(with: title)
    }
}
