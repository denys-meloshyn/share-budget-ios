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

class BaseView: NSObject {
    let presenter: BasePresenter
    weak var viewController: UIViewController?
    
    init(with presenter: BasePresenter, and viewController: UIViewController) {
        self.presenter = presenter
        self.viewController = viewController
    }
}

extension BaseView: LifeCycleStateProtocol {
    @objc func viewDidLoad() {
        self.presenter.viewDidLoad()
    }
    
    func viewWillAppear(_ animated: Bool) {
        self.presenter.viewWillAppear(animated)
    }
    
    func viewDidAppear(_ animated: Bool) {
        self.presenter.viewDidAppear(animated)
    }
    
    func viewWillDisappear(_ animated: Bool) {
        self.presenter.viewWillDisappear(animated)
    }
    
    func viewDidDisappear(_ animated: Bool) {
        self.presenter.viewDidDisappear(animated)
    }
}

extension BaseView: BasePresenterDelegate {
    @objc func showPage(title: String?) {
        self.viewController?.navigationItem.title = title
    }
    
    @objc func showTabBar(title: String, image: UIImage, selected: UIImage) {
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
