//
//  BasePresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

protocol BasePresenterDelegate: class {
    func showPage(title: String)
    func showTabBar(title: String, image: UIImage, selected: UIImage)
    func showMessage(with title: String, _ message: String, _ actions: [UIAlertAction])
}

class BasePresenter: NSObject {
    var interaction: BaseInteraction
    let router: BaseRouter
    
    init(with interaction: BaseInteraction, router: BaseRouter) {
        self.interaction = interaction
        self.router = router
    }
    
    func configure() {
        
    }
    
    func alertOkAction(title: String = LocalisedManager.generic.ok) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: .cancel, handler: nil)
        
        return action
    }
}

extension BasePresenter: LifeCycleStateProtocol {
    func viewDidLoad() {
        
    }
    
    func viewWillAppear(_ animated: Bool) {
        
    }
    
    func viewDidAppear(_ animated: Bool) {
        
    }
    
    func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func viewDidDisappear(_ animated: Bool) {
        
    }
}
