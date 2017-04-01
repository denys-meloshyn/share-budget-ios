//
//  BudgetDetailRouter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 03.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData

class BudgetDetailRouter: BaseRouter {
    func openEditExpensePage(with budgetID: NSManagedObjectID?) {
        guard let editExpenseViewController = R.storyboard.main.editExpenseViewController() else {
            return
        }
        
        editExpenseViewController.budgetID = budgetID
        self.viewController?.navigationController?.pushViewController(editExpenseViewController, animated: true)
    }
    
    func showAllExpensesPage(with budgetID: NSManagedObjectID?, categoryID: NSManagedObjectID? = nil) {
        guard let expensesViewController = R.storyboard.main.expensesViewController() else {
            return
        }
        
        expensesViewController.budgetID = budgetID
        expensesViewController.categoryID = categoryID
        self.viewController?.navigationController?.pushViewController(expensesViewController, animated: true)
    }
}
