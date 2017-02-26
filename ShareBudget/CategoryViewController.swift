//
//  CategoryViewController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 06.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData
import XCGLogger

protocol CategoryViewControllerDelegate: class {
    func didSelectCategory(_ categoryID: NSManagedObjectID)
}

class CategoryViewController: BaseViewController {
    @IBOutlet var tableView: UITableView?
    
    var budgetID: NSManagedObjectID!
    var managedObjectContext: NSManagedObjectContext!
    weak var delegate: CategoryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let router = CategoryRouter(with: self)
        let interactin = CategoryInteraction(with: self.budgetID, managedObjectContext: self.managedObjectContext)
        let presenter = CategoryPresenter(with: interactin, router: router, delegate: self.delegate)
        self.viperView = CategoryView(with: presenter, and: self)
        
        self.linkStoryboardViews()
        self.viperView?.viewDidLoad()
    }
    
    private func linkStoryboardViews() {
        guard let view = self.viperView as? CategoryView else {
            return
        }
        
        view.tableView = self.tableView
    }
}
