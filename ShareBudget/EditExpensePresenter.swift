//
//  EditExpensePresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 05.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

enum EditExpenseField {
    case price
    case name
    case category
    case date
}

protocol EditExpensePresenterDelegate: class {
    func showApplyChangesButton(_ button: UIBarButtonItem)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateApplyButton()
    }
    
    private func updateApplyButton() {
        var title: String
        var isEnabled = true
        
        if self.expenseInteraction.isExpenseNew {
            title = LocalisedManager.edit.expense.create
        }
        else {
            title = LocalisedManager.edit.expense.update
            
            if !self.expenseInteraction.expense.hasChanges {
                isEnabled = false
            }
        }
        
        let button = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: self, action: #selector(EditExpensePresenter.saveChanges))
        button.isEnabled = isEnabled
        
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
    
    func saveChanges() {
        
    }
}

extension EditExpensePresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = self.items[indexPath.row]
        var cell: RightTextFieldTableViewCell
        let input: RightTextFieldTableViewCellInputType
        
        switch type {
        case .category:
            input = RightTextFieldTableViewCellInputType.notEdited(title: self.fieldTitle(type), value: "", placeholder: self.fieldTitle(type))
        case .date:
            input = RightTextFieldTableViewCellInputType.date(title: self.fieldTitle(type), formattedDate: "", date: Date(), placeholder: self.fieldTitle(type))
        default:
            input = RightTextFieldTableViewCellInputType.text(title: self.fieldTitle(type), value: "", placeholder: self.fieldTitle(type))
        }
        
        cell = self.delegate!.createExpenseCell(with: input)
        if type == .category {
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
}

extension EditExpensePresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = self.items[indexPath.row]
        
        switch type {
        case .category:
            if let router = self.router as? EditExpenseRouter {
                router.openCategoryPage(for: self.expenseInteraction.expense.objectID, managedObjectContext: (self.interaction as! EditExpenseInteraction).managedObjectContext)
            }
        default:
            let cell = tableView.cellForRow(at: indexPath) as? RightTextFieldTableViewCell
            cell?.textField?.becomeFirstResponder()
        }
    }
}
