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
    func clearSearch()
    func cancelSearch()
    func showGroupList()
    func removeBottomOffset()
    func setBottomOffset(_ offset: Double)
    func refreshData(for mode: BudgetHeaderMode)
    func showCreateNewGroupMessage(message: NSAttributedString)
    func createBudgetCell(with title: String?) -> UITableViewCell
}

protocol BudgetPresenterProtocol: BasePresenterProtocol, UITableViewDelegate, UITableViewDataSource, CreateSearchTableViewHeaderDelegate {
    weak var delegate: BudgetPresenterDelegate? { get set }
}

class BudgetPresenter<I: BudgetInteractionProtocol, R: BudgetRouterProtocol>: BasePresenter<I, R>, BudgetPresenterProtocol {
    weak var delegate: BudgetPresenterDelegate?
    
    override init(with interaction: I, router: R) {
        super.init(with: interaction, router: router)
        
        interaction.delegate = self
    }
    
    func headerMode() -> BudgetHeaderMode {
        let rows = interaction.numberOfRowsInSection()
        
        if rows > 0 {
            return .search
        }
        
        return .create
    }
    
    func updateSearchPlaceholder(_ searchText: String) {
        if headerMode() == .create {
            let descriptionText = LocalisedManager.groups.createNewGroupTip(searchText)
            let attribetString = NSMutableAttributedString(string: descriptionText)
            var range = (descriptionText as NSString).range(of: searchText, options: .backwards)
            attribetString.addAttribute(NSAttributedStringKey.foregroundColor, value: Constants.color.dflt.actionColor, range: range)
            
            range = (descriptionText as NSString).range(of: "+")
            attribetString.addAttribute(NSAttributedStringKey.foregroundColor, value: Constants.color.dflt.actionColor, range: range)
            
            delegate?.showCreateNewGroupMessage(message: attribetString)
        } else {
            delegate?.showGroupList()
        }
    }
    
    func startListenKeyboardNotifications() {
        addKeyboardNotifications()
    }
    
    func stopListenKeyboardNotifications() {
        removeKeyboardNotifications()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interaction.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let budget = interaction.budgetModel(for: indexPath)
        guard let cell = delegate?.createBudgetCell(with: budget.name) else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return delegate?.createSearchTableHeaderView(with: headerMode(), placeholder: LocalisedManager.groups.headerPlaceholder)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let budget = interaction.budgetModel(for: indexPath)
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

// MARK: - LifeCycleStateProtocol

extension BudgetPresenter: LifeCycleStateProtocol {
    func viewDidLoad() {
        delegate?.showTabBar(title: "Budgets", image: UIImage(), selected: UIImage())
        delegate?.showPage(title: "Budgets")
    }
    
    func viewWillAppear(_ animated: Bool) {
        SyncManager.shared.delegate = self
        
        startListenKeyboardNotifications()
    }
    
    func viewDidAppear(_ animated: Bool) {
    }
    
    func viewWillDisappear(_ animated: Bool) {
    }
    
    func viewDidDisappear(_ animated: Bool) {
        stopListenKeyboardNotifications()
    }
}

// MARK: - BudgetInteractionDelegate

extension BudgetPresenter: BudgetInteractionDelegate {
    func willChangeContent() {
        delegate?.refreshData(for: self.headerMode())
    }
    
    func didChangeContent() {
        delegate?.refreshData(for: self.headerMode())
    }
    
    func changed(at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    }
}

// MARK: - CreateSearchTableViewHeaderDelegate

extension BudgetPresenter: CreateSearchTableViewHeaderDelegate {
    func textChanged(_ sender: CreateSearchTableViewHeader, _ text: String) {
        let newText = Validator.removeWhiteSpaces(text)
        if text != newText {
            sender.textField?.text = newText
        }
        
        interaction.updateWithSearch(newText)
        updateSearchPlaceholder(newText)
    }
    
    func createNewItem(_ sender: CreateSearchTableViewHeader, _ title: String?) {
        delegate?.cancelSearch()
        delegate?.clearSearch()
        delegate?.showGroupList()
        interaction.updateWithSearch("")
        
        guard let title = title, !Validator.isNullOrBlank(title) else {
            return
        }
        
        let newBudget = interaction.createNewBudget(with: Validator.removeWhiteSpaces(title))
        router.openDetailPage(for: newBudget.objectID)
    }
    
    func modeButtonPressed(_ sender: CreateSearchTableViewHeader) {
        if headerMode() == .create {
            createNewItem(sender, sender.textField?.text)
        }
    }
}

// MARK: - KeyBoardProtocol

extension BudgetPresenter: KeyBoardProtocol {
    func keyboardWillHide(notification: NSNotification) {
        delegate?.removeBottomOffset()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        delegate?.setBottomOffset(keyboardHeight(from: notification))
    }
}

extension BudgetPresenter: SyncManagerDelegate {
    func error(_ error: ErrorTypeAPI) {
        delegate?.showErrorSync(message: LocalisedManager.generic.errorMessage)
    }
}
