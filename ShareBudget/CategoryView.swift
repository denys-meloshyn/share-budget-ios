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
    func createSearchTableHeaderView(with mode: BudgetHeaderMode) -> CreateSearchTableViewHeader? {
        let header = self.tableView?.dequeueReusableHeaderFooterView(withIdentifier: self.tableHeaderReuseIdentifier) as? CreateSearchTableViewHeader
        header?.mode = mode
        
        return header
    }
    
    func createCategoryCell(with text: String?) -> UITableViewCell {
        let cell = self.tableView?.dequeueReusableCell(withIdentifier: "CategoryTableViewCell")
        cell?.textLabel?.text = text
        
        return cell!
    }
}


