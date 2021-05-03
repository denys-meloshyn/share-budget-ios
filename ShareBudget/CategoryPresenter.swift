//
//  CategoryPresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 26.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData
import UIKit

protocol CategoryPresenterDelegate: BasePresenterDelegate, CreateSearchTableViewHeaderDataSource {
    func refreshData(for mode: BudgetHeaderMode)
    func createCategoryCell(with text: String?, isSelected: Bool) -> UITableViewCell
}

protocol CategoryPresenterProtocol: BasePresenterProtocol, UITableViewDataSource, UITableViewDelegate {
    var delegate: CategoryPresenterDelegate! { get set }
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

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return interaction.numberOfCategories()
    }

    func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        let header = delegate.createSearchTableHeaderView(with: headerMode(), placeholder: LocalisedManager.category.headerPlaceholder)
        header?.delegate = self

        return header
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = interaction.category(for: indexPath)
        let isCurrentCategory = interaction.expense.category?.objectID == model.objectID
        let cell = delegate.createCategoryCell(with: model.name, isSelected: isCurrentCategory)

        return cell
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 60.0
    }

    // MARK: - UITableViewDelegate

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
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

    func changed(at _: IndexPath?, for _: NSFetchedResultsChangeType, newIndexPath _: IndexPath?) {}
}

// MARK: - LifeCycleStateProtocol

extension CategoryPresenter: LifeCycleStateProtocol {
    func viewDidLoad() {}

    func viewWillAppear(_: Bool) {}

    func viewDidAppear(_: Bool) {}

    func viewWillDisappear(_: Bool) {}

    func viewDidDisappear(_: Bool) {}
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

    func createNewItem(_: CreateSearchTableViewHeader, _ title: String?) {
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
