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
    fileprivate let tableHeaderReuseIdentifier = "CreateSearchTableViewHeader"
    
    weak var tableView: UITableView? {
        didSet {
            let nib = R.nib.createSearchTableViewHeader()
            self.tableView?.register(nib, forHeaderFooterViewReuseIdentifier: self.tableHeaderReuseIdentifier)
            
            guard let presenter = presenter as? BudgetPresenter else {
                return
            }
            
            self.tableView?.delegate = presenter
            self.tableView?.dataSource = presenter
        }
    }
    
    override init(with presenter: BasePresenter, and viewController: UIViewController) {
        super.init(with: presenter, and: viewController)
        
        guard let presenter = presenter as? BudgetPresenter else {
            return
        }
        
        presenter.delegate = self
    }
}

extension BudgetView: BudgetPresenterDelegate {
    func createSearchTableHeaderView(with mode: BudgetHeaderMode) -> CreateSearchTableViewHeader? {
        let header = self.tableView?.dequeueReusableHeaderFooterView(withIdentifier: self.tableHeaderReuseIdentifier) as? CreateSearchTableViewHeader
        header?.mode = mode
        
        return header
    }
    
    func refreshData() {
        self.tableView?.reloadData()
    }
}
