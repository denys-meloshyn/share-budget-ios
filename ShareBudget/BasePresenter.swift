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
    func showErrorMessage(with title: String, _ message: String, _ actions: [UIAlertAction])
}

class BasePresenter: NSObject {
    let interaction: BaseInteraction
    
    init(with interaction: BaseInteraction) {
        self.interaction = interaction
    }
    
    func configure() {
        
    }
    
    func alertOkAction(title: String = LocalisedManager.generic.ok) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: .cancel, handler: nil)
        
        return action
    }
}

extension BasePresenter: LifeCycleStateProtocol {
    func viewWillAppear(_ animated: Bool) {
        
    }
    
    func viewDidAppear(_ animated: Bool) {
        
    }
    
    func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func viewDidDisappear(_ animated: Bool) {
        
    }
}
