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
        
        self.teamMembersPresenter.delegate = self
        self.tableView?.dataSource = self.teamMembersPresenter
        self.tableView?.delegate = self.teamMembersPresenter
    }
    
    func refreshData() {
        self.tableView?.reloadData()
    }
}

// MARK: - TeamMembersPresenterDelegate

extension TeamMembersView: TeamMembersPresenterDelegate {
    func createTeamMemberCell(with title: String?, and subTitle: String?) -> UITableViewCell {
        let cell = tableView?.dequeueReusableCell(withIdentifier: "TeamMemberTableViewCell")
        cell?.textLabel?.text = title
        cell?.detailTextLabel?.text = subTitle
        
        return cell!
    }
}
