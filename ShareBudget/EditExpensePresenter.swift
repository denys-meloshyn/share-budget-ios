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
    func updateDate(_ value: String)
    func updateName(_ value: String?)
    func updatePrice(_ value: String)
    func updateDatePicker(with date: Date)
    func configureSaveButtonState(_ state: Bool)
    func activateTextField(_ textField: EditExpenseField)
    func showApplyChangesButton(_ button: UIBarButtonItem)
    func typeForTextField(_ textField: UITextField) -> EditExpenseField
    func setPlaceholder(_ value: String?, color: UIColor?, for textField: EditExpenseField)
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
        
        let date = self.expenseInteraction.expense.creationDate ?? NSDate()
        self.delegate?.updateDatePicker(with: date as Date)
        
        self.updatePrice()
        self.updateCategory()
        self.updateDate()
        self.delegate?.updateName(self.expenseInteraction.expense.name)
        
        self.delegate?.activateTextField(.price)
        self.delegate?.setPlaceholder(LocalisedManager.edit.expense.name, color: Constants.defaultApperanceColor, for: .name)
        self.delegate?.setPlaceholder(LocalisedManager.edit.expense.date, color: Constants.defaultApperanceColor, for: .date)
        self.delegate?.setPlaceholder(LocalisedManager.edit.expense.price, color: Constants.defaultApperanceColor, for: .price)
    }
    
    func openCategoryPage() {
        self.expenseRouter.openCategoryPage(for: self.expenseInteraction.expense.objectID, managedObjectContext: self.expenseInteraction.managedObjectContext, delegate: self)
    }
    
    func dateChanged(sender: UIDatePicker) {
        self.expenseInteraction.expense.creationDate = sender.date as NSDate?
        
        self.updateDate()
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
    
    private func updatePrice() {
        var formattedValue = ""
        if self.expenseInteraction.expense.price > 0.0 {
            formattedValue = String(self.expenseInteraction.expense.price)
        }
        
        self.delegate?.updatePrice(formattedValue)
    }
    
    fileprivate func updateCategory() {
        if let name = self.expenseInteraction.expense.category?.name {
            self.delegate?.setPlaceholder(name, color: Constants.defaultTextTintColor, for: .category)
        }
        else {
            self.delegate?.setPlaceholder(LocalisedManager.edit.expense.category, color: Constants.defaultInputTextColor, for: .category)
        }
    }
    
    fileprivate func updateDate() {
        if let creationDate = self.expenseInteraction.expense.creationDate as Date? {
            let formattedValue = UtilityFormatter.expenseCreationFormatter.string(from: creationDate)
            self.delegate?.updateDate(formattedValue)
        }
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
            if price.doubleValue > 0.0 {
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
        
        if self.expenseInteraction.expense.category == nil {
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

// MARK: - CategoryViewControllerDelegate

extension EditExpensePresenter: CategoryViewControllerDelegate {
    func didSelectCategory(_ categoryID: NSManagedObjectID) {
        self.expenseInteraction.updateCategory(categoryID)
        
        self.updateSaveButton()
        self.updateCategory()
    }
}

// MARK: - UITextFieldDelegate

extension EditExpensePresenter: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let type = self.delegate?.typeForTextField(textField) else {
            return true
        }
        
        let objcValue = textField.text as NSString?
        guard let newValue = objcValue?.replacingCharacters(in: range, with: string) else {
            return true
        }
        
        switch type {
        case .name:
            self.expenseInteraction.expense.name = newValue
            
        case .date:
            return false
            
        case .price:
            guard newValue.characters.count > 0 else {
                return true
            }
            
            guard let price = Double(newValue) else {
                return false
            }
            
            let roundPrice = UtilityFormatter.roundStringDecimalForTwoPlacesToNumber(NSNumber(value: price))
            
            if roundPrice?.doubleValue == price {
                self.expenseInteraction.expense.price = price
            }
            else {
                return false
            }
            
        default:
            break
        }
        
        self.updateSaveButton()
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let type = self.delegate?.typeForTextField(textField) else {
            return true
        }
        
        switch type {
        case .name:
            self.delegate?.activateTextField(.name)
            
        default:
            break
        }
        
        return true
    }
}
