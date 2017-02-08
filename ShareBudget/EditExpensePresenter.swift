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
    case create
}

protocol EditExpensePresenterDelegate: class {
    func createExpenseCell(with title: String?, value: String?, placeholder: String?) -> RightTextFieldTableViewCell
}

class EditExpensePresenter: BasePresenter {
    weak var delegate: EditExpensePresenterDelegate?
    fileprivate let items: [EditExpenseField] = [.price, .name, .category, .date, .create]
    
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
            
        case .create:
            return LocalisedManager.edit.expense.create
        }
    }
}

extension EditExpensePresenter: UITableViewDataSource {
    fileprivate var expenseInteraction: EditExpenseInteraction {
        get {
            return self.interaction as! EditExpenseInteraction
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = self.items[indexPath.row]
        var cell: RightTextFieldTableViewCell
        
        if type == .create {
            cell = RightTextFieldTableViewCell()
        }
        else {
            cell = self.delegate?.createExpenseCell(with: self.fieldTitle(type), value: "", placeholder: self.fieldTitle(type)) ?? RightTextFieldTableViewCell()
        }
        
        if type == .category {
            cell.accessoryType = .disclosureIndicator
            cell.textField?.isUserInteractionEnabled = false
        }
        
        return cell
    }
}

extension EditExpensePresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let router = self.router as? EditExpenseRouter {
            router.openCategoryPage(for: self.expenseInteraction.expense.objectID, managedObjectContext: (self.interaction as! EditExpenseInteraction).managedObjectContext)
        }
    }
}
