//
//  LoginViewController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    @IBOutlet private var stackView: UIStackView?
    @IBOutlet private var scrollView: UIScrollView?
    @IBOutlet private var authorisationButton: ButtonListener?
    @IBOutlet private var authorisationModeButton: ButtonListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let router = LoginRouter(with: self)
        let interaction = LoginInteraction()
        let presenter = LoginPresenter(with: interaction, router: router)
        viperView = LoginView(with: presenter, and: self)
        
        guard let view = viperView as? LoginViewProtocol else {
            return
        }
        
        linkStoryboardViews(to: view)
        linkViewActions(to: presenter)
        view.viewDidLoad()
        
        presenter.configure()
    }

    private func linkStoryboardViews(to view: LoginViewProtocol) {
        view.stackView = stackView
        view.scrollView = scrollView
        view.authorisationButton = authorisationButton
        view.authorisationModeButton = authorisationModeButton
    }
    
    private func linkViewActions(to presenter: LoginPresenterProtocol) {
        authorisationButton?.addTouchUpInsideListener(completion: { _ in
            presenter.authoriseUser()
        })

        authorisationModeButton?.addTouchUpInsideListener(completion: { _ in
            presenter.switchAuthorisationMode()
        })
    }
}
