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
    func createSearchTableHeaderView(with mode: BudgetHeaderMode) -> CreateSearchTableViewHeader?
}

class BudgetPresenter: BasePresenter {
    weak var delegate: BudgetPresenterDelegate?
    
    var budgetInteraction: BudgetInteraction? {
        get {
            guard let interaction = self.interaction as? BudgetInteraction else {
                return nil
            }
            
            return interaction
        }
    }
    override var interaction: BaseInteraction {
        didSet {
            self.budgetInteraction?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate?.showPage(title: "Budget")
    }
    
    func headerMode() -> BudgetHeaderMode {
        guard let rows = self.budgetInteraction?.numberOfRowsInSection() else {
            return .create
        }
        
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
        
    }
    
    func changed(at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
}

// MARK: - UITableViewDataSource methods

extension BudgetPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "asd"
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
