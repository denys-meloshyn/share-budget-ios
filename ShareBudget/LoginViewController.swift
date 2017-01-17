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
    @IBOutlet private var emailTextField: UITextField?
    @IBOutlet private var authorisationButton: UIButton?
    @IBOutlet private var passwordTextField: UITextField?
    @IBOutlet private var lastNameTextField: UITextField?
    @IBOutlet private var firstNameTextField: UITextField?
    @IBOutlet private var repeatPasswordTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let router = LoginRouter(with: self)
        let interactin = LoginInteraction(with: router)
        let presenter = LoginPresenter(with: interactin)
        self.viperView = LoginView(with: presenter, and: self)
        
        guard let view = self.viperView as? LoginView else {
            return
        }
        
        self.linkStoryboardViews(to: view)
        self.linkViewActions(to: presenter)
        
        presenter.configure()
    }

    func linkStoryboardViews(to view: LoginView) {
        view.stackView = self.stackView
        view.emailTextField = self.emailTextField
        view.lastNameTextField = self.lastNameTextField
        view.passwordTextField = self.passwordTextField
        view.firstNameTextField = self.firstNameTextField
        view.authorisationButton = self.authorisationButton
        view.repeatPasswordTextField = self.repeatPasswordTextField
    }
    
    func linkViewActions(to presenter: LoginPresenter) {
        self.emailTextField?.delegate = presenter
        self.passwordTextField?.delegate = presenter
        self.lastNameTextField?.delegate = presenter
        self.firstNameTextField?.delegate = presenter
        self.repeatPasswordTextField?.delegate = presenter
        
        self.authorisationButton?.addTarget(presenter, action: #selector(LoginPresenter.switchAuthorisationMode), for: .touchUpInside)
    }
}
