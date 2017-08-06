//
//  EditExpenseRouter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 05.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

class EditExpenseRouter: BaseRouter {
    func openCategoryPage(for expenseID: NSManagedObjectID, managedObjectContext: NSManagedObjectContext, delegate: CategoryViewControllerDelegate?) {
        if let viewController = R.storyboard.main.categoryViewController() {
            viewController.managedObjectContext = managedObjectContext
            viewController.expenseID = expenseID
            viewController.delegate = delegate
            self.viewController?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
