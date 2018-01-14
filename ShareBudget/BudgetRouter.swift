//
//  BudgetRouter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 28.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

protocol BudgetRouterProtocol: BaseRouterProtocol {
    func openDetailPage(for budgetID: NSManagedObjectID?)
}

class BudgetRouter: BaseRouter, BudgetRouterProtocol {
    func openDetailPage(for budgetID: NSManagedObjectID?) {
        guard let budgetDetailViewController = R.storyboard.main.budgetDetailViewController() else {
            return
        }
        
        budgetDetailViewController.budgetID = budgetID
        budgetDetailViewController.hidesBottomBarWhenPushed = true
        self.viewController?.navigationController?.pushViewController(budgetDetailViewController, animated: true)
    }
}
