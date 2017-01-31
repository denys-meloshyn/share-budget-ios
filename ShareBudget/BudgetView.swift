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
    
    weak var tableView: UITableView? {
        didSet {
            let nib = R.nib.createSearchTableViewHeader()
            self.tableView?.register(nib, forHeaderFooterViewReuseIdentifier: self.tableHeaderReuseIdentifier)
            self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: self.tableBudgetCellReuseIdentifier)
            self.tableView?.delegate = self.budgetPresenter
            self.tableView?.dataSource = self.budgetPresenter
        }
    }
    
    override init(with presenter: BasePresenter, and viewController: UIViewController) {
        super.init(with: presenter, and: viewController)
        
        self.budgetPresenter.delegate = self
    }
}

extension BudgetView: BudgetPresenterDelegate {
    func createSearchTableHeaderView(with mode: BudgetHeaderMode) -> CreateSearchTableViewHeader? {
        let header = self.tableView?.dequeueReusableHeaderFooterView(withIdentifier: self.tableHeaderReuseIdentifier) as? CreateSearchTableViewHeader
        header?.delegate = self.budgetPresenter
        header?.mode = mode
        
        return header
    }
    
    func refreshData(for mode: BudgetHeaderMode) {
        self.tableView?.reloadData()
        let header = self.tableView?.headerView(forSection: 0) as? CreateSearchTableViewHeader
        header?.mode = mode
    }
    
    func createBudgetCell(with title: String?) -> UITableViewCell? {
        let cell = self.tableView?.dequeueReusableCell(withIdentifier: self.tableBudgetCellReuseIdentifier)
        cell?.textLabel?.text = title
        
        return cell
    }
}
