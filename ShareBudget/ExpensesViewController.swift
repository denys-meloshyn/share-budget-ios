//
//  ExpensesViewController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

class ExpensesViewController: BaseViewController {
    var budgetID: NSManagedObjectID!
    var categoryID: NSManagedObjectID?
    
    @IBOutlet var tableView: UITableView!

    override func configureVIPER() {
        do {
            let router = ExpensesRouter(with: self)
            let interaction = try ExpensesInteraction(managedObjectContext: ModelManager.managedObjectContext,
                    budgetID: budgetID,
                    categoryID: categoryID,
                    logger: Dependency.logger)
            let presenter = ExpensesPresenter(with: interaction, router: router)
            viperView = ExpensesView(with: presenter, and: self)

            presenter.delegate = viperView as! ExpensesPresenterDelegate
        } catch {
            fatalError("\(error)")
        }
    }

    override func linkStoryboardViews() {
        guard let view = viperView as? ExpensesViewProtocol else {
            fatalError("Expected to receive ExpensesViewProtocol, instead receive \(String(describing: viperView))")
        }

        view.tableView = tableView
    }
}
