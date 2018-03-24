//
//  TextFieldErrorMessage.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 22.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class TextFieldErrorMessage: UIView {
    @IBOutlet var errorMessageLabel: UILabel!
    @IBOutlet var textField: TextFieldListener!
    @IBOutlet private var containerTextView: UIView!
    
    var isErrorHidden = true {
        didSet {
            if isErrorHidden {
                errorMessageLabel.text = ""
                containerTextView.layer.borderColor = Constants.color.login.validBorderColor.cgColor
            } else {
                containerTextView.layer.borderColor = Constants.color.login.errorBorderColor.cgColor
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerTextView.layer.borderWidth = 1.0
        containerTextView.layer.cornerRadius = 5.0
        containerTextView.layer.borderColor = Constants.color.login.validBorderColor.cgColor
    }
}
