//
//  BasePresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

protocol BasePresenterDelegate: class {
    func showPage(title: String?)
    func showErrorSync(message text: String)
    func showTabBar(title: String, image: UIImage, selected: UIImage)
    func showMessage(with title: String, _ message: String, _ actions: [UIAlertAction])
}

protocol BasePresenterProtocol: LifeCycleStateProtocol {
    
}

class BasePresenter<Interaction: BaseInteractionProtocol, Router: BaseRouterProtocol>: NSObject {
    let router: Router
    let interaction: Interaction
    
    init(with interaction: Interaction, router: Router) {
        self.router = router
        self.interaction = interaction
    }
    
    func configure() {
    }
    
    func alertOkAction(title: String = LocalisedManager.generic.ok) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: .cancel, handler: nil)
        
        return action
    }
}
