//
//  BudgetDetailRouter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 03.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData

protocol BudgetDetailRouterProtocol: BaseRouterProtocol {
    func openTeamMembersPage(with budgetID: NSManagedObjectID)
    func openEditExpensePage(with budgetID: NSManagedObjectID?)
    func showAllExpensesPage(with budgetID: NSManagedObjectID?, categoryID: NSManagedObjectID?)
}

class BudgetDetailRouter: BaseRouter, BudgetDetailRouterProtocol {
    func openEditExpensePage(with budgetID: NSManagedObjectID?) {
        guard let editExpenseViewController = R.storyboard.main.editExpenseViewController() else {
            return
        }

        editExpenseViewController.budgetID = budgetID
        viewController?.navigationController?.pushViewController(editExpenseViewController, animated: true)
    }

    func showAllExpensesPage(with budgetID: NSManagedObjectID?, categoryID: NSManagedObjectID?) {
        guard let expensesViewController = R.storyboard.main.expensesViewController() else {
            return
        }

        expensesViewController.budgetID = budgetID
        expensesViewController.categoryID = categoryID
        viewController?.navigationController?.pushViewController(expensesViewController, animated: true)
    }

    func openTeamMembersPage(with budgetID: NSManagedObjectID) {
        guard let teamMembersViewController = R.storyboard.main.teamMembersViewController() else {
            return
        }

        teamMembersViewController.budgetID = budgetID
        viewController?.navigationController?.pushViewController(teamMembersViewController, animated: true)
    }
}
