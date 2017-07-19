//
//  TeamMembersView.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 18.07.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class TeamMembersView: BaseView {
    weak var tableView: UITableView?
    
    fileprivate var teamMembersPresenter: TeamMembersPresenter {
        get {
            return self.presenter as! TeamMembersPresenter
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.dataSource = self.teamMembersPresenter
        self.tableView?.delegate = self.teamMembersPresenter
    }
}
