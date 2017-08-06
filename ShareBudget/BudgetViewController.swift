//
//  BudgetViewController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 28.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class BudgetViewController: BaseViewController {
    @IBOutlet var tableView: UITableView?
    @IBOutlet private var createNewGroupLabel: UILabel?
    @IBOutlet private var createNewGroupRootView: UIView?
    @IBOutlet private var constantCreateNewGroupRootViewBottom: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let router = BudgetRouter(with: self)
        let interactin = BudgetInteraction(managedObjectContext: ModelManager.managedObjectContext)
        let presenter = BudgetPresenter(with: interactin, router: router)
        self.viperView = BudgetView(with: presenter, and: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.viperView as? BudgetView else {
            return
        }
        
        self.linkStoryboardViews(to: view)
        self.viperView?.viewDidLoad()
    }
    
    private func linkStoryboardViews(to view: BudgetView) {
        view.tableView = self.tableView
        view.createNewGroupLabel = self.createNewGroupLabel
        view.createNewGroupRootView = self.createNewGroupRootView
        view.constantCreateNewGroupRootViewBottom = self.constantCreateNewGroupRootViewBottom
    }
}
