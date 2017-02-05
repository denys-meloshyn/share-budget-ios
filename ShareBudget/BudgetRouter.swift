//
//  BudgetRouter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 28.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

class BudgetRouter: BaseRouter {
    func openDetailPage(for budgetID: NSManagedObjectID?) {
        guard let budgetDetailViewController = self.viewController?.storyboard?.instantiateViewController(withIdentifier: "BudgetDetailViewController") as? BudgetDetailViewController else {
            return
        }
        
        budgetDetailViewController.budgetID = budgetID
        self.viewController?.navigationController?.pushViewController(budgetDetailViewController, animated: true)
    }
}
