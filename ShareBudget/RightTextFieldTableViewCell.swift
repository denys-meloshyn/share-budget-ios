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
    case number(title: String?, value: String?, placeholder: String?)
    case notEdited(title: String?, value: String?, placeholder: String?)
    case date(title: String?, formattedDate: String?, date: Date?, placeholder: String?)
}

protocol RightTextFieldTableViewCellDelegate: class {
    func done(sender: RightTextFieldTableViewCell)
    func valueChanged(sender: RightTextFieldTableViewCell)
    func nextKeyboard(sender: RightTextFieldTableViewCell)
}

class RightTextFieldTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var textField: UITextField?
    
    lazy var datePicker = UIDatePicker()
    
    var indexPath: IndexPath?
    weak var delegate: RightTextFieldTableViewCellDelegate?
    
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
        self.textField?.keyboardType = .default
        self.textField?.isUserInteractionEnabled = true
        self.textField?.removeTarget(self, action: #selector(RightTextFieldTableViewCell.textChanged), for: .editingChanged)
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
            self.textField?.autocapitalizationType = .words
            self.listenTextFieldChanges()
            
        case let .notEdited(title, value, placeholder):
            resTitle = title
            resValue = value
            resPlaceholder = placeholder
            
            self.textField?.isUserInteractionEnabled = false
            
        case let .date(title, formattedDate, date, placeholder):
            resTitle = title
            resValue = formattedDate
            resPlaceholder = placeholder
            
            self.datePicker.addTarget(self, action: #selector(RightTextFieldTableViewCell.dateChanged), for: .valueChanged)
            self.datePicker.datePickerMode = .dateAndTime
            self.datePicker.date = date ?? Date()
            self.textField?.inputView = self.datePicker
            self.addDateToolBar()
            
        case let .number(title, value, placeholder):
            resTitle = title
            resValue = value
            resPlaceholder = placeholder
            
            self.textField?.keyboardType = .decimalPad
            self.listenTextFieldChanges()
            self.addToolBar()
        }
        
        self.textField?.text = resValue
        self.titleLabel?.text = resTitle
        self.textField?.placeholder = resPlaceholder
    }
    
    private func keyboardToolBar() -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.frame.width, height: 44.0)))
        toolBar.barStyle = UIBarStyle.default
        
        return toolBar
    }
    
    private func addToolBar() {
        let toolBar = self.keyboardToolBar()
        
        let doneToolBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(RightTextFieldTableViewCell.doneAction))
        let flexibleSpaceToolBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let nextToolBarItem = UIBarButtonItem(title: LocalisedManager.generic.next, style: UIBarButtonItemStyle.done, target: self, action: #selector(RightTextFieldTableViewCell.nextKeyboardAction))
        toolBar.items = [doneToolBarItem, flexibleSpaceToolBarItem, nextToolBarItem]
        
        self.textField?.inputAccessoryView = toolBar
    }
    
    private func addDateToolBar() {
        let toolBar = self.keyboardToolBar()
        
        let doneToolBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(RightTextFieldTableViewCell.doneAction))
        let flexibleSpaceToolBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.items = [flexibleSpaceToolBarItem, doneToolBarItem]
        
        self.textField?.inputAccessoryView = toolBar
    }
    
    private func listenTextFieldChanges() {
        self.textField?.addTarget(self, action: #selector(RightTextFieldTableViewCell.textChanged), for: .editingChanged)
    }
    
    func dateChanged() {
        self.delegate?.valueChanged(sender: self)
    }
    
    func doneAction() {
        self.delegate?.done(sender: self)
    }
    
    func nextKeyboardAction() {
        self.delegate?.nextKeyboard(sender: self)
    }
    
    func textChanged() {
        self.delegate?.valueChanged(sender: self)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nextKeyboardAction()
        
        return true
    }
}
