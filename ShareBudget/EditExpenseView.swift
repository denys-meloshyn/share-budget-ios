//
//  EditExpenseView.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 05.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class EditExpenseView: BaseView {
    var categoryButton: UIButton?
    var dateContainerView: UIView?
    var dateTextField: UITextField?
    var nameTextField: UITextField?
    var priceTextField: UITextField?
    var categoryContainerView: UIView?
    
    fileprivate var editExpensePresenter: EditExpensePresenter {
        get {
            return self.presenter as! EditExpensePresenter
        }
    }
    
    override init(with presenter: BasePresenter, and viewController: UIViewController) {
        super.init(with: presenter, and: viewController)
        
        self.editExpensePresenter.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.priceTextField?.delegate = self.editExpensePresenter
        
        self.setBorderColor(for: self.dateContainerView)
        self.setBorderColor(for: self.categoryContainerView)
    }
    
    fileprivate func setBorderColor(for view: UIView?) {
        view?.layer.borderWidth = 1.0
        view?.layer.cornerRadius = 5.0
        view?.layer.borderColor = Constants.defaultActionColor.cgColor
    }
}

extension EditExpenseView: EditExpensePresenterDelegate {
    func updatePrice(_ value: String) {
        self.priceTextField?.text = value
    }
    
    func typeForTextField(_ textField: UITextField) -> EditExpenseField {
        switch textField {
        case self.priceTextField!:
            return .price
        default:
            return .price
        }
    }
    
    func setPlaceholder(_ value: String?, for textField: EditExpenseField) {
        switch textField {
        case .price:
            self.priceTextField?.placeholder = value
            
        case .date:
            self.dateTextField?.placeholder = value
            
        case .name:
            self.nameTextField?.placeholder = value
            
        case .category:
            self.categoryButton?.setTitle(value, for: .normal)
            self.categoryButton?.setTitle(value, for: .highlighted)
        }
    }
    
    func activateTextField(_ textField: EditExpenseField) {
        switch textField {
        case .price:
            self.priceTextField?.becomeFirstResponder()
        default:
            break
        }
    }
    
    func createExpenseCell(with inputType: RightTextFieldTableViewCellInputType) -> RightTextFieldTableViewCell {
        return RightTextFieldTableViewCell()
    }
    
    func showApplyChangesButton(_ button: UIBarButtonItem) {
        self.viewController?.navigationItem.rightBarButtonItem = button
    }
    
    func activateCellTextField(at indexPath: IndexPath) {
//        self.tableView?.scrollToRow(at: indexPath, at: .middle, animated: true)
//        let cell = self.tableView?.cellForRow(at: indexPath) as? RightTextFieldTableViewCell
//        cell?.textField?.becomeFirstResponder()
    }
    
    func refreshTextField(at indexPath: IndexPath, with value: String) {
//        let cell = self.tableView?.cellForRow(at: indexPath) as? RightTextFieldTableViewCell
//        cell?.textField?.text = value
    }
    
    func configureSaveButtonState(_ state: Bool) {
        let button = self.viewController?.navigationItem.rightBarButtonItem
        button?.isEnabled = state
    }
}
