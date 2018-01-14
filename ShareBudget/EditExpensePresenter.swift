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

protocol EditExpensePresenterProtocol: BasePresenterProtocol, UITextFieldDelegate {
    weak var delegate: EditExpensePresenterDelegate? { get set }
    
    func openCategoryPage()
    func dateChanged(sender: UIDatePicker)
}

class EditExpensePresenter<I: EditExpenseInteraction, R: EditExpenseRouterProtocol>: BasePresenter<I, R>, EditExpensePresenterProtocol {
    weak var delegate: EditExpensePresenterDelegate?
    fileprivate let items: [EditExpenseField] = [.price, .name, .category, .date]
    
    func openCategoryPage() {
        router.openCategoryPage(for: interaction.expense.objectID, managedObjectContext: interaction.managedObjectContext, delegate: self)
    }
    
    func dateChanged(sender: UIDatePicker) {
        interaction.expense.creationDate = sender.date as NSDate?
        
        updateDate()
        updateSaveButton()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let type = delegate?.typeForTextField(textField) else {
            return true
        }
        
        let objcValue = textField.text as NSString?
        guard let newValue = objcValue?.replacingCharacters(in: range, with: string) else {
            return true
        }
        
        switch type {
        case .name:
            interaction.expense.name = newValue
            
        case .date:
            return false
            
        case .price:
            guard newValue.count > 0 else {
                return true
            }
            
            guard let price = UtilityFormatter.priceEditFormatter.number(from: newValue) else {
                return false
            }
            
            let roundPrice = UtilityFormatter.roundStringDecimalForTwoPlacesToNumber(price)
            if roundPrice == price {
                interaction.expense.price = price
            } else {
                return false
            }
            
        default:
            break
        }
        
        self.updateSaveButton()
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let type = delegate?.typeForTextField(textField) else {
            return true
        }
        
        switch type {
        case .name:
            delegate?.activateTextField(.name)
            
        default:
            break
        }
        
        return true
    }
    
    private func updateApplyButton() {
        var title: String
        
        if interaction.isExpenseNew {
            title = LocalisedManager.edit.expense.create
        } else {
            title = LocalisedManager.edit.expense.update
        }
        
        let button = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: self, action: #selector(EditExpensePresenter.saveChanges))
        
        delegate?.showApplyChangesButton(button)
    }
    
    private func updatePrice() {
        var formattedValue = ""
        if let price = interaction.expense.price, price.doubleValue > 0.0 {
            formattedValue = UtilityFormatter.priceEditFormatter.string(from: price) ?? ""
        }
        
        delegate?.updatePrice(formattedValue)
    }
    
    fileprivate func updateCategory() {
        if let name = interaction.expense.category?.name {
            delegate?.setPlaceholder(name, color: Constants.color.dflt.textTintColor, for: .category)
        } else {
            delegate?.setPlaceholder(LocalisedManager.edit.expense.category, color: Constants.color.dflt.inputTextColor, for: .category)
        }
    }
    
    fileprivate func updateDate() {
        if let creationDate = interaction.expense.creationDate as Date? {
            let formattedValue = UtilityFormatter.expenseCreationFormatter.string(from: creationDate)
            delegate?.updateDate(formattedValue)
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
            let creationDate = interaction.expense.creationDate as Date?
            if let date = creationDate {
                formattedValue = UtilityFormatter.string(from: date)
            }
            
        case .price:
            if let price = interaction.expense.price, price.doubleValue > 0.0 {
                formattedValue = UtilityFormatter.stringAmount(amount: price) ?? ""
            }
            
        case .name:
            formattedValue = interaction.expense.name ?? ""
            
        case .category:
            formattedValue = interaction.expense.category?.name ?? ""
        }
        
        return formattedValue
    }
    
    fileprivate func isInputDataValid() -> Bool {
        if interaction.expense.price == 0.0 {
            return false
        }
        
        if interaction.expense.category == nil {
            return false
        }
        
        return true
    }
    
    fileprivate func updateSaveButton() {
        var isEnable = isInputDataValid()
        if isEnable {
            isEnable = interaction.expense.hasChanges
        }
        
        delegate?.configureSaveButtonState(isEnable)
    }
    
    @objc func saveChanges() {
        interaction.save()
        router.closePage()
    }
}

// MARK: - LifeCycleStateProtocol

extension EditExpensePresenter: LifeCycleStateProtocol {
    func viewDidLoad() {
        updateApplyButton()
        updateSaveButton()
        
        let date = interaction.expense.creationDate ?? NSDate()
        delegate?.updateDatePicker(with: date as Date)
        
        updatePrice()
        updateCategory()
        updateDate()
        delegate?.updateName(interaction.expense.name)
        
        delegate?.activateTextField(.price)
        delegate?.setPlaceholder(LocalisedManager.edit.expense.name, color: Constants.color.dflt.apperanceColor, for: .name)
        delegate?.setPlaceholder(LocalisedManager.edit.expense.date, color: Constants.color.dflt.apperanceColor, for: .date)
        delegate?.setPlaceholder(LocalisedManager.edit.expense.price, color: Constants.color.dflt.apperanceColor, for: .price)
    }
    
    func viewWillAppear(_ animated: Bool) {
    }
    
    func viewDidAppear(_ animated: Bool) {
    }
    
    func viewWillDisappear(_ animated: Bool) {
    }
    
    func viewDidDisappear(_ animated: Bool) {
    }
}

// MARK: - CategoryViewControllerDelegate

extension EditExpensePresenter: CategoryViewControllerDelegate {
    func didSelectCategory(_ categoryID: NSManagedObjectID) {
        interaction.updateCategory(categoryID)
        
        updateSaveButton()
        updateCategory()
    }
}
