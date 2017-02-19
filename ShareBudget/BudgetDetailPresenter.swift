//
//  BudgetDetailPresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 03.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

protocol BudgetDetailPresenterDelegate: class {
    func updateBalance(_ balance: String)
    func updateMonthLimit(_ limit: String)
    func updateTotalExpense(_ total: String)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTotalExpenses()
        self.configureMonthBudget()
        self.configureBalance()
    }
    
    private func configureTotalExpenses() {
        let total = self.budgetDetailInteraction.totalExpenses()
        self.delegate?.updateTotalExpense(String(total))
    }
    
    private func configureMonthBudget() {
        let month = self.budgetDetailInteraction.lastMonthLimit()
        self.delegate?.updateMonthLimit(String(month?.limit ?? 0.0))
    }
    
    private func configureBalance() {
        self.delegate?.updateBalance(String(self.budgetDetailInteraction.balance()))
    }
    
    func createNewExpense() {
        self.budgetDetailRouter.openEditExpensePage(with: self.budgetDetailInteraction.budgetID)
    }
    
    func showAllExpenses() {
        self.budgetDetailRouter.showAllExpensesPage(with: self.budgetDetailInteraction.budgetID)
    }
}
