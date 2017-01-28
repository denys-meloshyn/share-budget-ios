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
    private let tableHeaderReuseIdentifier = "CreateSearchTableViewHeader"
    
    weak var tableView: UITableView? {
        didSet {
            let nib = R.nib.createSearchTableViewHeader()
            self.tableView?.register(nib, forHeaderFooterViewReuseIdentifier: self.tableHeaderReuseIdentifier)
        }
    }
}
