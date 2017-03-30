//
//  EditExpensePresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 05.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

enum EditExpenseField {
    case price
    case name
    case category
    case date
}

protocol EditExpensePresenterDelegate: BasePresenterDelegate {
    func configureSaveButtonState(_ state: Bool)
    func activateCellTextField(at indexPath: IndexPath)
    func showApplyChangesButton(_ button: UIBarButtonItem)
    func refreshTextField(at indexPath: IndexPath, with value: String)
    func createExpenseCell(with inputType: RightTextFieldTableViewCellInputType) -> RightTextFieldTableViewCell
}

class EditExpensePresenter: BasePresenter {
    weak var delegate: EditExpensePresenterDelegate?
    fileprivate let items: [EditExpenseField] = [.price, .name, .category, .date]
    fileprivate var expenseInteraction: EditExpenseInteraction {
        get {
            return self.interaction as! EditExpenseInteraction
        }
    }
    fileprivate var expenseRouter: EditExpenseRouter {
        get {
            return self.router as! EditExpenseRouter
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateApplyButton()
        self.updateSaveButton()
    }
    
    private func updateApplyButton() {
        var title: String
        
        if self.expenseInteraction.isExpenseNew {
            title = LocalisedManager.edit.expense.create
        }
        else {
            title = LocalisedManager.edit.expense.update
        }
        
        let button = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: self, action: #selector(EditExpensePresenter.saveChanges))
        
        self.delegate?.showApplyChangesButton(button)
    }
    
    fileprivate func fieldTitle(_ field: EditExpenseField) -> String {
        switch field {
        case .price:
            return LocalisedManager.edit.expense.price
            
        case .name:
            return LocalisedManager.edit.expense.name
            
        case .category:
            return LocalisedManager.edit.expense.category
            
        case .date:
            return LocalisedManager.edit.expense.date
        }
    }
    
    fileprivate func formattedTextFieldValue(for type: EditExpenseField) -> String {
        var formattedValue = ""
        
        switch type {
        case .date:
            let creationDate = self.expenseInteraction.expense.creationDate as Date?
            if let date = creationDate {
                formattedValue = UtilityFormatter.string(from: date)
            }
            
        case .price:
            let price = NSNumber(value: self.expenseInteraction.expense.price)
            if price.doubleValue >= 0.0 {
                formattedValue = UtilityFormatter.stringAmount(amount: price) ?? ""
            }
            
        case .name:
            formattedValue = self.expenseInteraction.expense.name ?? ""
            
        case .category:
            formattedValue = self.expenseInteraction.expense.category?.name ?? ""
        }
        
        return formattedValue
    }
    
    fileprivate func isInputDataValid() -> Bool {
        if self.expenseInteraction.expense.price == 0.0 {
            return false
        }
        
        guard let name = self.expenseInteraction.expense.name, name.characters.count > 0 else {
            return false
        }
        
        return true
    }
    
    fileprivate func updateSaveButton() {
        var isEnable = self.isInputDataValid()
        if isEnable {
            isEnable = self.expenseInteraction.expense.hasChanges
        }
        
        self.delegate?.configureSaveButtonState(isEnable)
    }
    
    func saveChanges() {
        self.expenseInteraction.save()
        self.expenseRouter.closePage()
    }
}

// MARK: - UITableViewDataSource

extension EditExpensePresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = self.items[indexPath.row]
        let input: RightTextFieldTableViewCellInputType
        
        let title = self.fieldTitle(type)
        let placeholder = self.fieldTitle(type)
        let formattedValue = self.formattedTextFieldValue(for: type)
        
        switch type {
        case .category:
            input = .notEdited(title: title, value: formattedValue, placeholder: placeholder)
            
        case .date:
            let creationDate = self.expenseInteraction.expense.creationDate as Date?
            
            input = .date(title: title, formattedDate: formattedValue, date: creationDate, placeholder: placeholder)
            
        case .price:
            input = .number(title: title, value: formattedValue, placeholder: placeholder)
            
        default:
            input = .text(title: title, value: formattedValue, placeholder: placeholder)
        }
        
        let cell = self.delegate!.createExpenseCell(with: input)
        cell.indexPath = indexPath
        cell.delegate = self
        if type == .category {
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension EditExpensePresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = self.items[indexPath.row]
        
        switch type {
        case .category:
            self.expenseRouter.openCategoryPage(for: self.expenseInteraction.expense.objectID, managedObjectContext: self.expenseInteraction.managedObjectContext, delegate: self)
        default:
            let cell = tableView.cellForRow(at: indexPath) as? RightTextFieldTableViewCell
            cell?.textField?.becomeFirstResponder()
        }
    }
}

extension EditExpensePresenter: CategoryViewControllerDelegate {
    func didSelectCategory(_ categoryID: NSManagedObjectID) {
        self.expenseInteraction.updateCategory(categoryID)
        
        guard let index = self.items.index(of: .category) else {
            return
        }
        
        let indexPath = IndexPath(row: index, section: 0)
        self.updateSaveButton()
        self.delegate?.refreshTextField(at: indexPath, with: self.formattedTextFieldValue(for: .category))
    }
}

// MARK: - RightTextFieldTableViewCellDelegate

extension EditExpensePresenter: RightTextFieldTableViewCellDelegate {
    func done(sender: RightTextFieldTableViewCell) {
        sender.textField?.resignFirstResponder()
    }
    
    func nextKeyboard(sender: RightTextFieldTableViewCell) {
        guard let indexPath = sender.indexPath else {
            return
        }
        
        if indexPath.row + 1 < self.items.count {
            var nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if self.items[nextIndexPath.row] == .category {
                nextIndexPath = IndexPath(row: indexPath.row + 2, section: indexPath.section)
            }
            self.delegate?.activateCellTextField(at: nextIndexPath)
        }
        else {
            self.done(sender: sender)
        }
    }
    
    func valueChanged(sender: RightTextFieldTableViewCell) {
        guard let indexPath = sender.indexPath else {
            return
        }
        
        let type = self.items[indexPath.row]
        switch type {
        case .name:
            self.expenseInteraction.expense.name = sender.textField?.text
            
        case .date:
            self.expenseInteraction.expense.creationDate = sender.datePicker.date as NSDate?
            
            let newValue = self.formattedTextFieldValue(for: type)
            self.delegate?.refreshTextField(at: indexPath, with: newValue)
            
        case .price:
            guard let text = sender.textField?.text else {
                return
            }
            
            let price = UtilityFormatter.amount(from: text) ?? 0.0
            let roundPrice = UtilityFormatter.roundStringDecimalForTwoPlacesToNumber(price)
            
            if roundPrice?.doubleValue == price.doubleValue {
                self.expenseInteraction.expense.price = price.doubleValue
            }
            else {
                let newValue = self.formattedTextFieldValue(for: type)
                self.delegate?.refreshTextField(at: indexPath, with: newValue)
            }
            
        default:
            break
        }
        
        self.updateSaveButton()
    }
}

