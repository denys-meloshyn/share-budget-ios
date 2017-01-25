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
    @IBOutlet private var authorisationButton: UIButton?
    @IBOutlet private var authorisationModeButton: UIButton?
    private let email = R.nib.textFieldErrorMessage.firstView(owner: nil)
    private var password = R.nib.textFieldErrorMessage.firstView(owner: nil)
    private var lastName = R.nib.textFieldErrorMessage.firstView(owner: nil)
    private var firstName = R.nib.textFieldErrorMessage.firstView(owner: nil)
    private var repeatPassword = R.nib.textFieldErrorMessage.firstView(owner: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let lastName = self.lastName {
            lastName.isHidden = true
            lastName.textField?.returnKeyType = .go
            self.stackView?.insertArrangedSubview(lastName, at: 0)
        }
        
        if let firstName = self.firstName {
            firstName.isHidden = true
            firstName.textField?.returnKeyType = .next
            self.stackView?.insertArrangedSubview(firstName, at: 0)
        }
        
        if let repeatPassword = self.repeatPassword {
            repeatPassword.isHidden = true
            repeatPassword.textField?.returnKeyType = .go
            repeatPassword.textField?.isSecureTextEntry = true
            self.stackView?.insertArrangedSubview(repeatPassword, at: 0)
        }
        
        if let password = self.password {
            password.textField?.isSecureTextEntry = true
            self.stackView?.insertArrangedSubview(password, at: 0)
        }
        
        if let email = self.email {
            email.textField?.returnKeyType = .next
            email.textField?.keyboardType = .emailAddress
            self.stackView?.insertArrangedSubview(email, at: 0)
        }
        
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

    private func linkStoryboardViews(to view: LoginView) {
        view.stackView = self.stackView
        view.authorisationButton = self.authorisationButton
        view.authorisationModeButton = self.authorisationModeButton
        view.email = self.email
        view.password = self.password
        view.lastName = self.lastName
        view.firstName = self.firstName
        view.repeatPassword = self.repeatPassword
    }
    
    private func linkViewActions(to presenter: LoginPresenter) {
        presenter.listenTextFieldChanges(self.email?.textField)
        presenter.listenTextFieldChanges(self.password?.textField)
        presenter.listenTextFieldChanges(self.lastName?.textField)
        presenter.listenTextFieldChanges(self.firstName?.textField)
        presenter.listenTextFieldChanges(self.repeatPassword?.textField)
        
        self.authorisationButton?.addTarget(presenter, action: #selector(LoginPresenter.authoriseUser), for: .touchUpInside)
        self.authorisationModeButton?.addTarget(presenter, action: #selector(LoginPresenter.switchAuthorisationMode), for: .touchUpInside)
    }
}
