//
//  CreateSearchTableViewHeader.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 28.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class CreateSearchTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet var textField: UITextField?
    @IBOutlet var searchCreateButton: UIButton?
    
    var mode: BudgetHeaderMode = .create {
        didSet {
            switch mode {
            case .create:
                self.showCreate()
                
            case .search:
                self.showSearch()
            }
        }
    }
    
    func showSearch() {
        self.searchCreateButton?.setTitle("?", for: .normal)
    }
    
    func showCreate() {
        self.searchCreateButton?.setTitle("+", for: .normal)
    }
}
