//
//  BudgetViewController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 28.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class BudgetViewController: BaseViewController {
    @IBOutlet private var tableView: UITableView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let router = BudgetRouter(with: self)
        let interactin = BudgetInteraction()
        let presenter = BudgetPresenter(with: interactin, router: router)
        self.viperView = BudgetView(with: presenter, and: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.viperView as? BudgetView else {
            return
        }
        
        self.linkStoryboardViews(to: view)
    }
    
    private func linkStoryboardViews(to view: BudgetView) {
        view.tableView = self.tableView
    }
}
