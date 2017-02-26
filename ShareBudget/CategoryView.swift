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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = R.nib.createSearchTableViewHeader()
        self.tableView?.register(nib, forHeaderFooterViewReuseIdentifier: self.tableHeaderReuseIdentifier)
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


