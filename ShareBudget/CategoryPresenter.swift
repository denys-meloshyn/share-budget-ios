//
//  CategoryPresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 26.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

protocol CategoryPresenterDelegate: BasePresenterDelegate, CreateSearchTableViewHeaderDataSource {
    func refreshData(for mode: BudgetHeaderMode)
    func createCategoryCell(with text: String?, isSelected: Bool) -> UITableViewCell
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
        self.categoryInteraction.delegate = self
    }
    
    func headerMode() -> BudgetHeaderMode {
        guard self.categoryInteraction.numberOfCategories() > 0 else {
            return .create
        }
        
        return .search
    }
}

extension CategoryPresenter: CategoryInteractionDelegate {
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

extension CategoryPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryInteraction.numberOfCategories()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.delegate.createSearchTableHeaderView(with: self.headerMode(), placeholder: LocalisedManager.category.headerPlaceholder)
        header?.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.categoryInteraction.category(for: indexPath)
        let isCurrentCategory = self.categoryInteraction.expense.category?.objectID == model.objectID
        let cell = self.delegate.createCategoryCell(with: model.name, isSelected: isCurrentCategory)
        
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
    func textChanged(_ sender: CreateSearchTableViewHeader, _ text: String) {
        self.categoryInteraction.updateWithSearch(text)
    }
    
    func createNewItem(_ sender: CreateSearchTableViewHeader, _ title: String?) {
        guard let title = title, !Validator.isNullOrBlank(title) else {
            return
        }
        
        let newCategory = self.categoryInteraction.createCategory(with: title)
        self.categoryDelegate?.didSelectCategory(newCategory.objectID)
        self.router.closePage()
    }
    
    func modeButtonPressed(_ sender: CreateSearchTableViewHeader) {
        if self.headerMode() == .create {
            self.createNewItem(sender, sender.textField?.text)
        }
    }
}
