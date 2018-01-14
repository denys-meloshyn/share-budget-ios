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

protocol CategoryPresenterProtocol: BasePresenterProtocol, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: CategoryPresenterDelegate! { get set }
}

class CategoryPresenter<I: CategoryInteractionProtocol, R: CategoryRouterProtocol>: BasePresenter<I, R>, CategoryPresenterProtocol {
    weak var delegate: CategoryPresenterDelegate!
    weak var categoryDelegate: CategoryViewControllerDelegate?
    
    init(with interaction: I, router: R, delegate: CategoryViewControllerDelegate?) {
        super.init(with: interaction, router: router)
        
        categoryDelegate = delegate
        self.interaction.delegate = self
    }
    
    func headerMode() -> BudgetHeaderMode {
        guard interaction.numberOfCategories() > 0 else {
            return .create
        }
        
        return .search
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interaction.numberOfCategories()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = delegate.createSearchTableHeaderView(with: headerMode(), placeholder: LocalisedManager.category.headerPlaceholder)
        header?.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = interaction.category(for: indexPath)
        let isCurrentCategory = interaction.expense.category?.objectID == model.objectID
        let cell = delegate.createCategoryCell(with: model.name, isSelected: isCurrentCategory)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = interaction.category(for: indexPath)
        categoryDelegate?.didSelectCategory(category.objectID)
        
        router.closePage()
    }
}

// MARK: - CategoryInteractionDelegate

extension CategoryPresenter: CategoryInteractionDelegate {
    func willChangeContent() {
        delegate?.refreshData(for: headerMode())
    }
    
    func didChangeContent() {
        delegate?.refreshData(for: headerMode())
    }
    
    func changed(at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    }
}

// MARK: - LifeCycleStateProtocol

extension CategoryPresenter: LifeCycleStateProtocol {
    func viewDidLoad() {
    }
    
    func viewWillAppear(_ animated: Bool) {
    }
    
    func viewDidAppear(_ animated: Bool) {
    }
    
    func viewWillDisappear(_ animated: Bool) {
    }
    
    func viewDidDisappear(_ animated: Bool) {
    }
}

// MARK: - CreateSearchTableViewHeaderDelegate

extension CategoryPresenter: CreateSearchTableViewHeaderDelegate {
    func textChanged(_ sender: CreateSearchTableViewHeader, _ text: String) {
        let newText = Validator.removeWhiteSpaces(text)
        if text != newText {
            sender.textField?.text = newText
        }
        
        interaction.updateWithSearch(newText)
    }
    
    func createNewItem(_ sender: CreateSearchTableViewHeader, _ title: String?) {
        guard let title = title, !Validator.isNullOrBlank(title) else {
            return
        }
        
        let newCategory = interaction.createCategory(with: title)
        categoryDelegate?.didSelectCategory(newCategory.objectID)
        router.closePage()
    }
    
    func modeButtonPressed(_ sender: CreateSearchTableViewHeader) {
        if headerMode() == .create {
            createNewItem(sender, sender.textField?.text)
        }
    }
}
