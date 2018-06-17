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
    func closePage(animated: Bool)
}

class BaseRouter: BaseRouterProtocol {
    weak var viewController: UIViewController?
    
    init(with viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func closePage() {
        closePage(animated: false)
    }

    func closePage(animated: Bool) {
        _ = viewController?.navigationController?.popViewController(animated: animated)
    }
}
