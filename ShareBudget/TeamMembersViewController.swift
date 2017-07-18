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
    
    fileprivate var teamMembersView: TeamMembersView {
        get {
            return self.viperView as! TeamMembersView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let router = TeamMembersRouter(with: self)
        let interactin = TeamMembersInteraction(with: self.budgetID, context: self.managedObjectContext)
        let presenter = TeamMembersPresenter(with: interactin, router: router)
        self.viperView = TeamMembersView(with: presenter, and: self)
        
        self.linkStoryboardViews()
        self.viperView?.viewDidLoad()
    }
    
    private func linkStoryboardViews() {
        teamMembersView.tableView = self.tableView
    }
}
