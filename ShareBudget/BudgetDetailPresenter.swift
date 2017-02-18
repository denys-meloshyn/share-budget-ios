//
//  BudgetDetailPresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 03.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

protocol BudgetDetailPresenterDelegate: class {
    
}

class BudgetDetailPresenter: BasePresenter {
    weak var delegate: BudgetDetailPresenterDelegate?
    
    private var budgetDetailInteraction: BudgetDetailInteraction {
        get {
            return self.interaction as! BudgetDetailInteraction
        }
    }
    
    private var budgetDetailRouter: BudgetDetailRouter {
        get {
            return self.router as! BudgetDetailRouter
        }
    }
    
    func createNewExpense() {
        self.budgetDetailRouter.openEditExpensePage(with: self.budgetDetailInteraction.budgetID)
    }
    
    func showAllExpenses() {
        self.budgetDetailRouter.showAllExpensesPage(with: self.budgetDetailInteraction.budgetID)
    }
}
