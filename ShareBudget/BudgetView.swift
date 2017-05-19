//
//  BudgetView.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 28.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import Rswift

class BudgetView: BaseView {
    fileprivate let tableBudgetCellReuseIdentifier = "BudgetTableViewCell"
    fileprivate let tableHeaderReuseIdentifier = "CreateSearchTableViewHeader"
    
    fileprivate var budgetPresenter: BudgetPresenter {
        get {
            return self.presenter as! BudgetPresenter
        }
    }
    
    weak var tableView: UITableView?
    weak var createNewGroupLabel: UILabel?
    weak var createNewGroupRootView: UIView?
    weak var constantCreateNewGroupRootViewBottom: NSLayoutConstraint?
    
    override init(with presenter: BasePresenter, and viewController: UIViewController) {
        super.init(with: presenter, and: viewController)
        
        self.budgetPresenter.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTable()
        self.viewController?.view.backgroundColor = Constants.defaultBackgroundColor
    }
    
    func configureTable() {
        let nib = R.nib.createSearchTableViewHeader()
        self.tableView?.register(nib, forHeaderFooterViewReuseIdentifier: self.tableHeaderReuseIdentifier)
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: self.tableBudgetCellReuseIdentifier)
        self.tableView?.delegate = self.budgetPresenter
        self.tableView?.dataSource = self.budgetPresenter
    }
    
    // Method of BudgetPresenterDelegate, need here to be able to test it
    func refreshData(for mode: BudgetHeaderMode) {
        self.tableView?.reloadData()
        let header = self.tableView?.headerView(forSection: 0) as? CreateSearchTableViewHeader
        header?.mode = mode
    }
}

// MARK: - BudgetPresenterDelegate

extension BudgetView: BudgetPresenterDelegate {
    func createSearchTableHeaderView(with mode: BudgetHeaderMode, placeholder: String) -> CreateSearchTableViewHeader? {
        let header = self.tableView?.dequeueReusableHeaderFooterView(withIdentifier: self.tableHeaderReuseIdentifier) as? CreateSearchTableViewHeader
        header?.delegate = self.budgetPresenter
        header?.textField?.placeholder = placeholder
        header?.mode = mode
        
        return header
    }
    
    func createBudgetCell(with title: String?) -> UITableViewCell {
        let cell = self.tableView?.dequeueReusableCell(withIdentifier: self.tableBudgetCellReuseIdentifier)
        cell?.backgroundColor = UIColor.clear
        cell?.textLabel?.text = title
        
        return cell!
    }
    
    func cancelSearch() {
        let searchView = self.tableView?.headerView(forSection: 0) as? CreateSearchTableViewHeader
        searchView?.textField?.resignFirstResponder()
    }
    
    func showGroupList() {
        self.tableView?.separatorStyle = .singleLine
        self.createNewGroupRootView?.isHidden = true
    }
    
    func showCreateNewGroupMessage(message: NSAttributedString) {
        self.tableView?.separatorStyle = .none
        self.createNewGroupRootView?.isHidden = false
        
        self.createNewGroupLabel?.attributedText = message
    }
    
    func removeBottomOffset() {
        guard var inset = self.tableView?.contentInset else {
            return
        }
        inset.bottom = self.viewController?.bottomLayoutGuide.length ?? 0.0
        
        self.tableView?.contentInset = inset
        self.tableView?.scrollIndicatorInsets = inset
        self.constantCreateNewGroupRootViewBottom?.constant = 0.0
    }
    
    func setBottomOffset(_ offset: Double) {
        guard var inset = self.tableView?.contentInset else {
            return
        }
        inset.bottom = CGFloat(offset)
        
        self.tableView?.contentInset = inset
        self.tableView?.scrollIndicatorInsets = inset
        self.constantCreateNewGroupRootViewBottom?.constant = CGFloat(offset)
    }
}
