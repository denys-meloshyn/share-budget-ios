//
//  TeamMembersPresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 18.07.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class TeamMembersPresenter: BasePresenter {
    fileprivate var teamMembersInteraction: TeamMembersInteraction {
        get {
            return self.interaction as! TeamMembersInteraction
        }
    }
}

// MARK: - UITableViewDataSource

extension TeamMembersPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teamMembersInteraction.userCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = UITableViewCell()
        let user = self.teamMembersInteraction.user(at: indexPath)
        c.textLabel?.text = user.email
        
        return c
    }
}

// MARK: - UITableViewDelegate

extension TeamMembersPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return nil
    }
}
