//
//  ExpenseTableViewHeader.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 24.03.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class ExpenseTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet var monthLabel: UILabel?
    @IBOutlet var monthExpensesLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = Constants.appearance.dflt.apperanceColor
    }
}
