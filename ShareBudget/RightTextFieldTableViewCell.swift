//
//  RightTextFieldTableViewCell.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 05.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class RightTextFieldTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var textField: UITextField?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.accessoryType = .none
    }
}
