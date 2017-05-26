//
//  CreateSearchTableViewHeader.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 28.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

protocol CreateSearchTableViewHeaderDataSource {
    func createSearchTableHeaderView(with mode: BudgetHeaderMode, placeholder: String) -> CreateSearchTableViewHeader?
}

protocol CreateSearchTableViewHeaderDelegate: class {
    func modeButtonPressed(_ sender: CreateSearchTableViewHeader)
    func textChanged(_ sender: CreateSearchTableViewHeader, _ text: String)
    func createNewItem(_ sender: CreateSearchTableViewHeader, _ title: String?)
}

class CreateSearchTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet var textField: UITextField?
    @IBOutlet var textFieldRootView: UIView?
    @IBOutlet var searchCreateButton: UIButton?
    
    weak var delegate: CreateSearchTableViewHeaderDelegate?
    
    var mode: BudgetHeaderMode = .create {
        didSet {
            switch mode {
            case .create:
                self.showCreate()
                
            case .search:
                self.showSearch()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textFieldRootView?.layer.borderWidth = 1.0
        self.textFieldRootView?.layer.borderColor = Constants.defaultActionColor.cgColor
        self.searchCreateButton?.tintColor = Constants.defaultActionColor
        self.contentView.backgroundColor = Constants.defaultBackgroundColor
    }
    
    private func showSearch() {
        self.searchCreateButton?.setTitle("🔎", for: .normal)
    }
    
    private func showCreate() {
        self.searchCreateButton?.setTitle("+", for: .normal)
    }
    
    @IBAction func textChanged() {
        self.delegate?.textChanged(self, self.textField?.text ?? "")
    }
    
    @IBAction func modeAction() {
        self.delegate?.modeButtonPressed(self)
    }
}

extension CreateSearchTableViewHeader: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate?.createNewItem(self, textField.text)
        
        return false
    }
}
