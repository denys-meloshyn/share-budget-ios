//
//  CreateSearchTableViewHeader.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 28.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

protocol CreateSearchTableViewHeaderDataSource {
    func createSearchTableHeaderView(with mode: BudgetHeaderMode) -> CreateSearchTableViewHeader?
}

protocol CreateSearchTableViewHeaderDelegate: class {
    func textChanged(_ text: String)
    func createNewItem(_ title: String?)
    func modeButtonPressed(_ sender: CreateSearchTableViewHeader)
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = UIColor.white
    }
    
    private func showSearch() {
        self.searchCreateButton?.setTitle("🔎", for: .normal)
    }
    
    private func showCreate() {
        self.searchCreateButton?.setTitle("+", for: .normal)
    }
    
    @IBAction func textChanged() {
        self.delegate?.textChanged(self.textField?.text ?? "")
    }
    
    @IBAction func modeAction() {
        self.delegate?.modeButtonPressed(self)
    }
}

extension CreateSearchTableViewHeader: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate?.createNewItem(textField.text)
        
        return false
    }
}
