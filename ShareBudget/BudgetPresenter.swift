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
    func showGroupList()
    func removeBottomOffset()
    func setBottomOffset(_ offset: Double)
    func refreshData(for mode: BudgetHeaderMode)
    func showCreateNewGroupMessage(message: NSAttributedString)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.removeKeyboardNotifications()
    }
    
    fileprivate func headerMode() -> BudgetHeaderMode {
        let rows = self.budgetInteraction.numberOfRowsInSection()
        
        if rows > 0 {
            return .search
        }
        
        return .create
    }
    
    fileprivate func updateSearchPlaceholder(_ searchText: String) {
        if self.headerMode() == .create {
            let descriptionText = LocalisedManager.groups.createNewGroupTip(searchText)
            let attribetString = NSMutableAttributedString(string: descriptionText)
            var range = (descriptionText as NSString).range(of: searchText, options: .backwards)
            attribetString.addAttribute(NSForegroundColorAttributeName, value: Constants.defaultActionColor, range: range)
            
            range = (descriptionText as NSString).range(of: "+")
            attribetString.addAttribute(NSForegroundColorAttributeName, value: Constants.defaultActionColor, range: range)
            
            self.delegate?.showCreateNewGroupMessage(message: attribetString)
        }
        else {
            self.delegate?.showGroupList()
        }
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
        tableView.deselectRow(at: indexPath, animated: false)
        
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
    func textChanged(_ sender: CreateSearchTableViewHeader, _ text: String) {
        let newText = Validator.removeWhiteSpaces(text)
        if text != newText {
            sender.textField?.text = newText
        }
        
        self.budgetInteraction.updateWithSearch(newText)
        self.updateSearchPlaceholder(newText)
    }
    
    func createNewItem(_ sender: CreateSearchTableViewHeader, _ title: String?) {
        guard let title = title, !Validator.isNullOrBlank(title) else {
            self.delegate?.cancelSearch()
            self.delegate?.showGroupList()
            return
        }
        
        self.budgetInteraction.createNewBudget(with: Validator.removeWhiteSpaces(title))
    }
    
    func modeButtonPressed(_ sender: CreateSearchTableViewHeader) {
        if self.headerMode() == .create {
            self.createNewItem(sender, sender.textField?.text)
        }
    }
}

// MARK: - KeyBoardProtocol

extension BudgetPresenter: KeyBoardProtocol {
    func keyboardWillHide(notification: NSNotification) {
        self.delegate?.removeBottomOffset()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.delegate?.setBottomOffset(self.keyboardHeight(from: notification))
    }
}
