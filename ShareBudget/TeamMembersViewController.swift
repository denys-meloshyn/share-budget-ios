//
//  TeamMembersViewController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 18.07.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

class TeamMembersViewController: BaseViewController {
    @IBOutlet private var tableView: UITableView?
    
    var budgetID: NSManagedObjectID!
    private let managedObjectContext = ModelManager.managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let router = TeamMembersRouter(with: self)
        let interactin = TeamMembersInteraction(with: budgetID, context: managedObjectContext)
        let presenter = TeamMembersPresenter(with: interactin, router: router)
        viperView = TeamMembersView(with: presenter, and: self)
        
        linkStoryboardViews()
        viperView?.viewDidLoad()
    }
    
    override func linkStoryboardViews() {
        guard let view = viperView as? TeamMembersViewProtocol else {
            return
        }
        
        view.tableView = tableView
    }
}
