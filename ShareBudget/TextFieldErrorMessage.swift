//
//  TextFieldErrorMessage.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 22.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class TextFieldErrorMessage: UIView {
    @IBOutlet var textField: UITextField?
    @IBOutlet var errorMessageLabel: UILabel?
    @IBOutlet private var containerTextView: UIView?
    
    var isErrorHidden = true {
        didSet {
            if isErrorHidden {
                self.errorMessageLabel?.text = ""
                self.containerTextView?.layer.borderColor = loginBorderColor.cgColor
            }
            else {
                self.containerTextView?.layer.borderColor = loginErrorBorderColor.cgColor
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerTextView?.layer.borderWidth = 1.0
        self.containerTextView?.layer.cornerRadius = 5.0
        self.containerTextView?.layer.borderColor = loginBorderColor.cgColor
    }
}
