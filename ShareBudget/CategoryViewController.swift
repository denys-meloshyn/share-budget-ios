//
//  CategoryViewController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 06.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData
import UIKit

protocol CategoryViewControllerDelegate: class {
    func didSelectCategory(_ categoryID: NSManagedObjectID)
}

class CategoryViewController: BaseViewController {
    @IBOutlet var tableView: UITableView?

    var expenseID: NSManagedObjectID!
    var managedObjectContext: NSManagedObjectContext!
    weak var delegate: CategoryViewControllerDelegate?

    override func configureVIPER() {
        let router = CategoryRouter(with: self)
        let interactin = CategoryInteraction(with: expenseID, managedObjectContext: managedObjectContext)
        let presenter = CategoryPresenter(with: interactin, router: router, delegate: delegate)
        viperView = CategoryView(with: presenter, and: self)
    }

    override func linkStoryboardViews() {
        guard let view = viperView as? CategoryViewProtocol else {
            return
        }

        view.tableView = tableView
    }
}
