//
//  BaseRouter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

protocol BaseRouterProtocol: class {
    func closePage()
}

class BaseRouter: BaseRouterProtocol {
    weak var viewController: UIViewController?
    
    init(with viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func closePage() {
        _ = viewController?.navigationController?.popViewController(animated: true)
    }
}
