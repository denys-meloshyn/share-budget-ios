//
//  BudgetDetailView.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 03.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class BudgetDetailView: BaseView {
    fileprivate var budgetDetailPresenter: BudgetDetailPresenter {
        get {
            return self.presenter as! BudgetDetailPresenter
        }
    }
    
    override init(with presenter: BasePresenter, and viewController: UIViewController) {
        super.init(with: presenter, and: viewController)
        
        self.budgetDetailPresenter.delegate = self
    }
}

extension BudgetDetailView: BudgetDetailPresenterDelegate {
    
}
