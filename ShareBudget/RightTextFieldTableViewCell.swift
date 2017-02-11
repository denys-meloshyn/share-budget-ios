//
//  RightTextFieldTableViewCell.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 05.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

enum RightTextFieldTableViewCellInputType {
    case text(title: String?, value: String?, placeholder: String?)
    case notEdited(title: String?, value: String?, placeholder: String?)
    case date(title: String?, formattedDate: String?, date: Date, placeholder: String?)
}

class RightTextFieldTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var textField: UITextField?
    
    var datePicker: UIDatePicker?
    
    var inputType: RightTextFieldTableViewCellInputType = .text(title: "", value: "", placeholder: "") {
        didSet {
            self.updateTextInput()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textField?.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.accessoryType = .none
        self.textField?.inputView = nil
        self.textField?.isUserInteractionEnabled = true
    }
    
    private func updateTextInput() {
        var resTitle: String?
        var resValue: String?
        var resPlaceholder: String?
        
        switch self.inputType {
        case let .text(title, value, placeholder):
            resTitle = title
            resValue = value
            resPlaceholder = placeholder
        case let .notEdited(title, value, placeholder):
            resTitle = title
            resValue = value
            resPlaceholder = placeholder
            
            self.textField?.isUserInteractionEnabled = false
        case let .date(title, formattedDate, date, placeholder):
            resTitle = title
            resValue = formattedDate
            resPlaceholder = placeholder
            
            self.datePicker = UIDatePicker()
            self.datePicker?.addTarget(self, action: #selector(RightTextFieldTableViewCell.dateChanged), for: .valueChanged)
            self.datePicker?.datePickerMode = .date
            self.textField?.inputView = self.datePicker
            self.datePicker?.date = date
        }
        
        self.textField?.text = resValue
        self.titleLabel?.text = resTitle
        self.textField?.placeholder = resPlaceholder
    }
    
    func dateChanged() {
        self.textField?.text = self.datePicker?.date.description
    }
}

extension RightTextFieldTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch self.inputType {
        case .date:
            return false
        default:
            return true
        }
    }
}
