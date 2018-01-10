//
//  EditExpenseView.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 05.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class EditExpenseView<T: EditExpensePresenterProtocol>: BaseView<T> {
    weak var categoryButton: UIButton?
    weak var dateContainerView: UIView?
    weak var nameSeparatorLine: UIView?
    weak var dateTextField: UITextField?
    weak var nameTextField: UITextField?
    lazy var datePicker = UIDatePicker()
    weak var priceTextField: UITextField?
    weak var categoryContainerView: UIView?
    
    override init(with presenter: T, and viewController: UIViewController) {
        super.init(with: presenter, and: viewController)
        
        presenter.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField?.delegate = presenter
        dateTextField?.delegate = presenter
        priceTextField?.delegate = presenter
        
        setBorderColor(for: dateContainerView)
        setBorderColor(for: categoryContainerView)
        nameSeparatorLine?.backgroundColor = Constants.color.dflt.actionColor
        categoryButton?.addTarget(presenter, action: #selector(EditExpensePresenter.openCategoryPage), for: .touchUpInside)
        
        configureDatePicker()
    }
    
    private func configureDatePicker() {
        datePicker.addTarget(presenter, action: #selector(EditExpensePresenter.dateChanged(sender:)), for: .valueChanged)
        datePicker.datePickerMode = .dateAndTime
        dateTextField?.inputView = datePicker
    }
    
    fileprivate func setBorderColor(for view: UIView?) {
        view?.layer.borderWidth = 1.0
        view?.layer.cornerRadius = 5.0
        view?.layer.borderColor = Constants.color.dflt.actionColor.cgColor
    }
}

extension EditExpenseView: EditExpensePresenterDelegate {
    func updateName(_ value: String?) {
        nameTextField?.text = value
    }
    
    func updateDate(_ value: String) {
        dateTextField?.text = value
    }
    
    func updateDatePicker(with date: Date) {
        datePicker.date = date
    }
    
    func updatePrice(_ value: String) {
        priceTextField?.text = value
    }
    
    func typeForTextField(_ textField: UITextField) -> EditExpenseField {
        switch textField {
        case self.priceTextField!:
            return .price
            
        case self.dateTextField!:
            return .date
            
        case self.nameTextField!:
            return .name
            
        default:
            return .price
        }
    }
    
    func setPlaceholder(_ value: String?, color: UIColor?, for textField: EditExpenseField) {
        switch textField {
        case .price:
            priceTextField?.placeholder = value
            
        case .date:
            dateTextField?.placeholder = value
            
        case .name:
            nameTextField?.placeholder = value
            
        case .category:
            categoryButton?.setTitle(value, for: .normal)
            categoryButton?.setTitle(value, for: .highlighted)
            categoryButton?.setTitleColor(color, for: .normal)
            categoryButton?.setTitleColor(color, for: .highlighted)
        }
    }
    
    func activateTextField(_ textField: EditExpenseField) {
        switch textField {
        case .price:
            priceTextField?.becomeFirstResponder()
        default:
            break
        }
    }
    
    func showApplyChangesButton(_ button: UIBarButtonItem) {
        viewController?.navigationItem.rightBarButtonItem = button
    }
    
    func configureSaveButtonState(_ state: Bool) {
        let button = viewController?.navigationItem.rightBarButtonItem
        button?.isEnabled = state
    }
}
