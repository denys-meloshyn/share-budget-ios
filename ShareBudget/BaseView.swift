//
//  BaseView.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import Toast_Swift

protocol LifeCycleStateProtocol: class {
    func viewDidLoad()
    func viewWillAppear(_ animated: Bool)
    func viewDidAppear(_ animated: Bool)
    func viewWillDisappear(_ animated: Bool)
    func viewDidDisappear(_ animated: Bool)
}

protocol BaseViewProtocol: class {
}

class BaseView<T: BasePresenterProtocol>: NSObject {
    let presenter: T
    weak var viewController: UIViewController?
    
    init(with presenter: T, and viewController: UIViewController) {
        self.presenter = presenter
        self.viewController = viewController
    }
}

extension BaseView: LifeCycleStateProtocol {
    func viewDidLoad() {
        presenter.viewDidLoad()
    }
    
    func viewWillAppear(_ animated: Bool) {
        presenter.viewWillAppear(animated)
    }
    
    func viewDidAppear(_ animated: Bool) {
        presenter.viewDidAppear(animated)
    }
    
    func viewWillDisappear(_ animated: Bool) {
        presenter.viewWillDisappear(animated)
    }
    
    func viewDidDisappear(_ animated: Bool) {
        presenter.viewDidDisappear(animated)
    }
}

extension BaseView: BasePresenterDelegate {
    func showPage(title: String?) {
        self.viewController?.navigationItem.title = title
    }
    
    func showTabBar(title: String, image: UIImage, selected: UIImage) {
        self.viewController?.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selected)
    }
    
    func showMessage(with title: String, _ message: String, _ actions: [UIAlertAction]) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in actions {
            alertView.addAction(action)
        }
        
        self.viewController?.present(alertView, animated: true, completion: nil)
    }
    
    func showErrorSync(message text: String) {
        self.viewController?.view.makeToast(text, duration: 3.0, position: .center)
    }
}
