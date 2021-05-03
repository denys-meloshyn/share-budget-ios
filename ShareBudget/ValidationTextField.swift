//
//  ValidationTextField.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 09.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

protocol ValidationTextFieldDelegate: class {
    func textChanged(_ text: String)
}

enum ValidationState {
    case notValid
    case valid
    case none
}

enum FieldState {
    case inactive
    case active
}

class ValidationTextField: UIView {
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var textField: UITextField?

    var textFieldState: FieldState = .inactive {
        didSet {
            updateUI()
        }
    }

    var validationState: ValidationState = .notValid {
        didSet {
            self.updateUI()
        }
    }

    weak var delegate: ValidationTextFieldDelegate?

    private var isFieldEmpty: Bool {
        return self.textField?.text?.count == 0
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.borderWidth = 1.0
    }

    private func updateUI() {
        var labelColor = UIColor.white
        var borderColor = UIColor.white

        switch (validationState, textFieldState) {
        case (.notValid, .active):
            borderColor = UIColor.red
            labelColor = UIColor.red

        case (.notValid, .inactive):
            borderColor = UIColor.purple
            labelColor = UIColor.purple

        case (.valid, .active):
            borderColor = UIColor.green
            labelColor = UIColor.green

        case (.valid, .inactive):
            borderColor = UIColor.gray
            labelColor = UIColor.green

        case (.none, .active):
            borderColor = UIColor.gray
            labelColor = UIColor.blue

        case (.none, .inactive):
            borderColor = UIColor.gray
            labelColor = UIColor.gray
        }

        titleLabel?.textColor = labelColor
        layer.borderColor = borderColor.cgColor

        if isFieldEmpty {
            titleLabel?.isHidden = true
        } else {
            titleLabel?.isHidden = false
        }
    }

    @IBAction func textChanged(sender: UITextField) {
        delegate?.textChanged(sender.text ?? "")
    }
}

extension ValidationTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_: UITextField) {
        textFieldState = .active
    }

    func textFieldDidEndEditing(_: UITextField) {
        textFieldState = .inactive
    }
}
