//
//  CreateSearchTableViewHeader.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 28.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

protocol CreateSearchTableViewHeaderDelegate: class {
    func textChanged(_ text: String)
    func createNewBudget(_ title: String?)
}

class CreateSearchTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet var textField: UITextField?
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
    
    @IBAction func textChanged() {
        self.delegate?.textChanged(self.textField?.text ?? "")
    }
    
    private func showSearch() {
        self.searchCreateButton?.setTitle("?", for: .normal)
    }
    
    private func showCreate() {
        self.searchCreateButton?.setTitle("+", for: .normal)
    }
}

extension CreateSearchTableViewHeader: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate?.createNewBudget(textField.text)
        
        return false
    }
}
