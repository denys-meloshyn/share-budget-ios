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
    func openCategoryPage(for expense: NSManagedObjectID, managedObjectContext: NSManagedObjectContext) {
        if let viewController = R.storyboard.main.categoryViewController() {
            viewController.managedObjectContext = managedObjectContext
            viewController.expenseID = expense
            self.viewController?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
