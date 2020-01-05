//
//  TeamMembersViewController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 18.07.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

import RxSwift
import CoreData

class TeamMembersViewController: BaseViewController {
    @IBOutlet private var tableView: UITableView?

    var budgetID: NSManagedObjectID!
    private let disposeBag = DisposeBag()
    let userGroupAPI = UserGroupAPI()
    private let managedObjectContext = ModelManager.managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()

        let router = TeamMembersRouter(with: self)
        let interactor = TeamMembersInteraction(with: budgetID, context: managedObjectContext)
        let presenter = TeamMembersPresenter(with: interactor, router: router)
        viperView = TeamMembersView(with: presenter, and: self)

        linkStoryboardViews()
        viperView?.viewDidLoad()

        let invite = UIBarButtonItem(title: "Invite", style: .plain, target: self, action: #selector(TeamMembersViewController.inviteUserToGroup))
        navigationItem.rightBarButtonItem = invite
    }

    override func linkStoryboardViews() {
        guard let view = viperView as? TeamMembersViewProtocol else {
            return
        }

        view.tableView = tableView
    }

    @objc func inviteUserToGroup() {
        guard let group = managedObjectContext.object(with: budgetID) as? Budget,
              let groupID = group.modelID else {
            return
        }

        navigationItem.rightBarButtonItem?.isEnabled = false
        userGroupAPI.invitationToken(groupID: String(groupID.intValue)).retry(1).delay(.seconds(10), scheduler: MainScheduler.instance).subscribe { event in
            self.navigationItem.rightBarButtonItem?.isEnabled = true

            switch event {
            case .success(let token):
                guard let url = Dependency.instance.restApiUrlBuilder().appendPath("user").appendPath("group").appendQueryParameter(key: "token", value: token).build() else {
                    return
                }

                let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            case .error:
                break
            }
        }.disposed(by: disposeBag)
    }
}
