//
//  BasePresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class BasePresenter {
    private let interaction: BaseInteraction
    
    init(with interaction: BaseInteraction) {
        self.interaction = interaction
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
