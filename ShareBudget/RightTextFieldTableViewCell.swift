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

        textField?.delegate = self
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        accessoryType = .none
        textField?.inputView = nil
        textField?.keyboardType = .default
        textField?.isUserInteractionEnabled = true
        textField?.removeTarget(self, action: #selector(RightTextFieldTableViewCell.textChanged), for: .editingChanged)
    }

    private func updateTextInput() {
        var resTitle: String?
        var resValue: String?
        var resPlaceholder: String?

        switch inputType {
        case let .text(title, value, placeholder):
            resTitle = title
            resValue = value
            resPlaceholder = placeholder
            textField?.autocapitalizationType = .sentences
            listenTextFieldChanges()

        case let .notEdited(title, value, placeholder):
            resTitle = title
            resValue = value
            resPlaceholder = placeholder

            textField?.isUserInteractionEnabled = false

        case let .date(title, formattedDate, date, placeholder):
            resTitle = title
            resValue = formattedDate
            resPlaceholder = placeholder

            datePicker.addTarget(self, action: #selector(RightTextFieldTableViewCell.dateChanged), for: .valueChanged)
            datePicker.datePickerMode = .dateAndTime
            datePicker.date = date ?? Date()
            textField?.inputView = datePicker
            addDateToolBar()

        case let .number(title, value, placeholder):
            resTitle = title
            resValue = value
            resPlaceholder = placeholder

            textField?.keyboardType = .decimalPad
            listenTextFieldChanges()
            addToolBar()
        }

        textField?.text = resValue
        titleLabel?.text = resTitle
        textField?.placeholder = resPlaceholder
    }

    private func keyboardToolBar() -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: frame.width, height: 44.0)))
        toolBar.barStyle = UIBarStyle.default

        return toolBar
    }

    private func addToolBar() {
        let toolBar = keyboardToolBar()

        let doneToolBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(RightTextFieldTableViewCell.doneAction))
        let flexibleSpaceToolBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let nextToolBarItem = UIBarButtonItem(title: LocalisedManager.generic.next, style: UIBarButtonItem.Style.done, target: self, action: #selector(RightTextFieldTableViewCell.nextKeyboardAction))
        toolBar.items = [doneToolBarItem, flexibleSpaceToolBarItem, nextToolBarItem]

        textField?.inputAccessoryView = toolBar
    }

    private func addDateToolBar() {
        let toolBar = keyboardToolBar()

        let doneToolBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(RightTextFieldTableViewCell.doneAction))
        let flexibleSpaceToolBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.items = [flexibleSpaceToolBarItem, doneToolBarItem]

        textField?.inputAccessoryView = toolBar
    }

    private func listenTextFieldChanges() {
        textField?.addTarget(self, action: #selector(RightTextFieldTableViewCell.textChanged), for: .editingChanged)
    }

    @objc func dateChanged() {
        delegate?.valueChanged(sender: self)
    }

    @objc func doneAction() {
        delegate?.done(sender: self)
    }

    @objc func nextKeyboardAction() {
        delegate?.nextKeyboard(sender: self)
    }

    @objc func textChanged() {
        delegate?.valueChanged(sender: self)
    }
}

extension RightTextFieldTableViewCell: UITextFieldDelegate {
    func textField(_: UITextField, shouldChangeCharactersIn _: NSRange, replacementString _: String) -> Bool {
        switch inputType {
        case .date:
            return false
        default:
            return true
        }
    }

    func textFieldShouldReturn(_: UITextField) -> Bool {
        nextKeyboardAction()

        return true
    }
}
