//
//  TeamMembersPresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 18.07.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

protocol TeamMembersPresenterDelegate {
    func refreshData()
    func createTeamMemberCell(with title: String?, and subTitle: String?) -> UITableViewCell
}

class TeamMembersPresenter: BasePresenter {
    var delegate: TeamMembersPresenterDelegate!
    
    fileprivate var teamMembersInteraction: TeamMembersInteraction {
        get {
            return self.interaction as! TeamMembersInteraction
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.teamMembersInteraction.delegate = self
    }
}

// MARK: - UITableViewDataSource

extension TeamMembersPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teamMembersInteraction.userCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userGroup = self.teamMembersInteraction.userGroup(at: indexPath)
        var items = [String]()
        if let lastName = userGroup.user?.lastName {
            items.append(lastName)
        }
        
        if let firstName = userGroup.user?.firstName {
            items.append(firstName)
        }
        
        var title = NSArray(array: items).componentsJoined(by: " ")
        var subtitle = userGroup.user?.email ?? ""
        
        if title.characters.count == 0 {
            title = subtitle
            subtitle = ""
        }
        
        return self.delegate.createTeamMemberCell(with: title, and: subtitle)
    }
}

// MARK: - UITableViewDelegate

extension TeamMembersPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .destructive, title: LocalisedManager.generic.delete) { (action, indexPath) in
            let userGroup = self.teamMembersInteraction.userGroup(at: indexPath)
            userGroup.isRemoved = true
            userGroup.isChanged = true
        }
        
        return [action]
    }
}

// MARK: - BaseInteractionDelegate

extension TeamMembersPresenter: BaseInteractionDelegate {
    func willChangeContent() {
        self.delegate?.refreshData()
    }
    
    func didChangeContent() {
        self.delegate?.refreshData()
    }
}
