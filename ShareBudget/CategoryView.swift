//
//  CategoryView.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 26.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class CategoryView: BaseView {
    weak var tableView: UITableView?
    fileprivate let tableHeaderReuseIdentifier = "CreateSearchTableViewHeader"
    
    fileprivate var categoryPresenter: CategoryPresenter {
        get {
            return self.presenter as! CategoryPresenter
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categoryPresenter.delegate = self
        
        let nib = R.nib.createSearchTableViewHeader()
        self.tableView?.register(nib, forHeaderFooterViewReuseIdentifier: self.tableHeaderReuseIdentifier)
        self.tableView?.delegate = self.categoryPresenter
        self.tableView?.dataSource = self.categoryPresenter
    }
}

extension CategoryView: CategoryPresenterDelegate {
    internal func createCategoryCell(with text: String?, isSelected: Bool) -> UITableViewCell {
        let cell = self.tableView?.dequeueReusableCell(withIdentifier: "CategoryTableViewCell")
        cell?.textLabel?.text = text
        
        if isSelected {
            cell?.accessoryType = .checkmark
        }
        else {
            cell?.accessoryType = .none
        }
        
        return cell!
    }

    func refreshData(for mode: BudgetHeaderMode) {
        self.tableView?.reloadData()
        let header = self.tableView?.headerView(forSection: 0) as? CreateSearchTableViewHeader
        header?.mode = mode
    }
    
    func createSearchTableHeaderView(with mode: BudgetHeaderMode, placeholder: String) -> CreateSearchTableViewHeader? {
        let header = self.tableView?.dequeueReusableHeaderFooterView(withIdentifier: self.tableHeaderReuseIdentifier) as? CreateSearchTableViewHeader
        header?.mode = mode
        
        return header
    }
}


