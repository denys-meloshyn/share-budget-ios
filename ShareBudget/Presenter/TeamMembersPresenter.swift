//
//  TeamMembersPresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 18.07.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

protocol TeamMembersPresenterDelegate: class {
    func refreshData()
    func createTeamMemberCell(with title: String?, and subTitle: String?) -> UITableViewCell
}

protocol TeamMembersPresenterProtocol: BasePresenterProtocol, UITableViewDelegate, UITableViewDataSource {
    var delegate: TeamMembersPresenterDelegate! { get set }
}

class TeamMembersPresenter<I: TeamMembersInteractionProtocol, R: TeamMembersRouterProtocol>: BasePresenter<I, R>, TeamMembersPresenterProtocol {
    weak var delegate: TeamMembersPresenterDelegate!
    
    func viewDidLoad() {
        interaction.delegate = self
    }
    
    func viewWillAppear(_ animated: Bool) {
    }
    
    func viewDidAppear(_ animated: Bool) {
    }
    
    func viewWillDisappear(_ animated: Bool) {
    }
    
    func viewDidDisappear(_ animated: Bool) {
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interaction.userCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userGroup = interaction.userGroup(at: indexPath)
        var items = [String]()
        if let lastName = userGroup.user?.lastName {
            items.append(lastName)
        }
        
        if let firstName = userGroup.user?.firstName {
            items.append(firstName)
        }
        
        var title = NSArray(array: items).componentsJoined(by: " ")
        var subtitle = userGroup.user?.email ?? ""
        
        if title.count == 0 {
            title = subtitle
            subtitle = ""
        }
        
        return delegate.createTeamMemberCell(with: title, and: subtitle)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .destructive, title: LocalisedManager.generic.delete) { (_, indexPath) in
            let userGroup = self.interaction.userGroup(at: indexPath)
            userGroup.isRemoved = true
            userGroup.isChanged = true
            self.interaction.save()
        }
        
        return [action]
    }
}

// MARK: - BaseInteractionDelegate

extension TeamMembersPresenter: BaseInteractionDelegate {
    func changed(at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    }
    
    func willChangeContent() {
        delegate?.refreshData()
    }
    
    func didChangeContent() {
        delegate?.refreshData()
    }
}
