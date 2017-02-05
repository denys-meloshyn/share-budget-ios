//
//  EditExpenseView.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 05.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class EditExpenseView: BaseView {
    weak var tableView: UITableView? {
        didSet {
            let nib = R.nib.rightTextFieldTableViewCell
            self.tableView?.register(nib)
            
            self.tableView?.delegate = self.editExpensePresenter
            self.tableView?.dataSource = self.editExpensePresenter
        }
    }
    
    fileprivate var editExpensePresenter: EditExpensePresenter {
        get {
            return self.presenter as! EditExpensePresenter
        }
    }
    
    override init(with presenter: BasePresenter, and viewController: UIViewController) {
        super.init(with: presenter, and: viewController)
        
        self.editExpensePresenter.delegate = self
    }
}

extension EditExpenseView: EditExpensePresenterDelegate {
    func createExpenseCell(with title: String?, value: String?, placeholder: String?) -> UITableViewCell {
        let cell = self.tableView?.dequeueReusableCell(withIdentifier: R.reuseIdentifier.rightTextFieldTableViewCell)
        cell?.titleLabel?.text = title
        cell?.textField?.text = value
        cell?.textField?.placeholder = placeholder
        
        return cell ?? UITableViewCell()
    }
}
