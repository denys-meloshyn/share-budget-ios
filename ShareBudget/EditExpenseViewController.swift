//
//  EditExpenseViewController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 05.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class EditExpenseViewController: BaseViewController {
    @IBOutlet var tableView: UITableView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let router = EditExpenseRouter(with: self)
        let interactin = EditExpenseInteraction()
        let presenter = EditExpensePresenter(with: interactin, router: router)
        self.viperView = EditExpenseView(with: presenter, and: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func linkStoryboardViews() {
        guard let view = self.viperView as? EditExpenseView else {
            return
        }
        
        view.tableView = self.tableView
    }
}
