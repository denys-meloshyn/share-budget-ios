//
//  ExpensesRouter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 05.06.2018.
//  Copyright © 2018 Denys Meloshyn. All rights reserved.
//

import CoreData

protocol ExpensesRouterProtocol: BaseRouterProtocol {
    func openEditExpenseViewController(budgetID: NSManagedObjectID, expenseID: NSManagedObjectID)
}

class ExpensesRouter: BaseRouter, ExpensesRouterProtocol {
    func openEditExpenseViewController(budgetID: NSManagedObjectID, expenseID: NSManagedObjectID) {
        guard let editExpenseViewController = R.storyboard.main.editExpenseViewController() else {
            fatalError("EditExpenseViewController not exist")
        }

        editExpenseViewController.budgetID = budgetID
        editExpenseViewController.expenseID = expenseID

        viewController?.navigationController?.pushViewController(editExpenseViewController, animated: true)
    }
}
