//
//  CategoryView.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 26.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

protocol CategoryViewProtocol: BaseViewProtocol {
    var tableView: UITableView? { get set }
}

class CategoryView<T: CategoryPresenterProtocol>: BaseView<T>, CategoryViewProtocol {
    weak var tableView: UITableView?
    fileprivate let tableDequeueReusableCell = "CategoryTableViewCell"
    fileprivate let tableHeaderReuseIdentifier = "CreateSearchTableViewHeader"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.delegate = self
        
        let nib = R.nib.createSearchTableViewHeader()
        tableView?.register(nib, forHeaderFooterViewReuseIdentifier: tableHeaderReuseIdentifier)
        tableView?.delegate = presenter
        tableView?.dataSource = presenter
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: tableDequeueReusableCell)
    }
}

extension CategoryView: CategoryPresenterDelegate {
    internal func createCategoryCell(with text: String?, isSelected: Bool) -> UITableViewCell {
        let cell = tableView?.dequeueReusableCell(withIdentifier: tableDequeueReusableCell)
        cell?.textLabel?.text = text
        
        if isSelected {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        
        return cell!
    }

    func refreshData(for mode: BudgetHeaderMode) {
        tableView?.reloadData()
        let header = tableView?.headerView(forSection: 0) as? CreateSearchTableViewHeader
        header?.mode = mode
    }
    
    func createSearchTableHeaderView(with mode: BudgetHeaderMode, placeholder: String) -> CreateSearchTableViewHeader? {
        let header = tableView?.dequeueReusableHeaderFooterView(withIdentifier: tableHeaderReuseIdentifier) as? CreateSearchTableViewHeader
        header?.textField?.placeholder = placeholder
        header?.mode = mode
        
        return header
    }
}
