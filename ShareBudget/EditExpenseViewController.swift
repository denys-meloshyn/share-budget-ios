//
//  EditExpenseViewController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 05.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

class EditExpenseViewController: BaseViewController {
    @IBOutlet var tableView: UITableView?
    
    var budgetID: NSManagedObjectID?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func viewDidLoad() {
        let router = EditExpenseRouter(with: self)
        let interactin = EditExpenseInteraction(with: self.budgetID!)
        let presenter = EditExpensePresenter(with: interactin, router: router)
        self.viperView = EditExpenseView(with: presenter, and: self)
        
        super.viewDidLoad()
    }
    
    override func linkStoryboardViews() {
        guard let view = self.viperView as? EditExpenseView else {
            return
        }
        
        view.tableView = self.tableView
    }
}
