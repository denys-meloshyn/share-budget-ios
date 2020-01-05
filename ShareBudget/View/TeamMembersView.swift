//
//  TeamMembersView.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 18.07.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

protocol TeamMembersViewProtocol: BaseViewProtocol {
    var tableView: UITableView? { get set }
}

class TeamMembersView<T: TeamMembersPresenterProtocol>: BaseView<T>, TeamMembersViewProtocol {
    weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.delegate = self
        tableView?.dataSource = presenter
        tableView?.delegate = presenter
    }
    
    func refreshData() {
        tableView?.reloadData()
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
