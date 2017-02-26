//
//  CategoryPresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 26.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

protocol CategoryPresenterDelegate: BasePresenterDelegate, CreateSearchTableViewHeaderDataSource {
    func createCategoryCell(with text: String?) -> UITableViewCell
}

class CategoryPresenter: BasePresenter {
    weak var delegate: CategoryPresenterDelegate!
    weak var categoryDelegate: CategoryViewControllerDelegate?
    
    fileprivate var categoryInteraction: CategoryInteraction {
        get {
            return self.interaction as! CategoryInteraction
        }
    }
    
    init(with interaction: BaseInteraction, router: BaseRouter, delegate: CategoryViewControllerDelegate?) {
        super.init(with: interaction, router: router)
        
        self.categoryDelegate = delegate
    }
    
    func headerMode() -> BudgetHeaderMode {
        let rows = self.categoryInteraction.numberOfCategories()
        
        if rows > 0 {
            return .search
        }
        
        return .create
    }
}

// MARK: - UITableViewDataSource

extension CategoryPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryInteraction.numberOfCategories()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.delegate.createSearchTableHeaderView(with: self.headerMode())
        header?.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.categoryInteraction.category(for: indexPath)
        let cell = self.delegate.createCategoryCell(with: model.name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
}

// MARK: - UITableViewDelegate

extension CategoryPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = self.categoryInteraction.category(for: indexPath)
        self.categoryDelegate?.didSelectCategory(category.objectID)
        
        self.router.closePage()
    }
}

// MARK: - CreateSearchTableViewHeaderDelegate

extension CategoryPresenter: CreateSearchTableViewHeaderDelegate {
    func textChanged(_ text: String) {
        self.categoryInteraction.updateWithSearch(text)
    }
    
    func createNewBudget(_ title: String?) {
        //        self.budgetInteraction.createNewBudget(with: title)
    }
    
    func modeButtonPressed(_ sender: CreateSearchTableViewHeader) {
        //        if self.headerMode() == .create {
        //            self.createNewBudget(sender.textField?.text)
        //        }
    }
}
