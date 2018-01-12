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
    private let email = R.nib.textFieldErrorMessage.firstView(owner: nil)
    private var password = R.nib.textFieldErrorMessage.firstView(owner: nil)
    private var lastName = R.nib.textFieldErrorMessage.firstView(owner: nil)
    private var firstName = R.nib.textFieldErrorMessage.firstView(owner: nil)
    private var repeatPassword = R.nib.textFieldErrorMessage.firstView(owner: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let lastName = lastName {
            lastName.isHidden = true
            lastName.textField?.returnKeyType = .go
            stackView?.insertArrangedSubview(lastName, at: 0)
        }
        
        if let firstName = firstName {
            firstName.isHidden = true
            firstName.textField?.returnKeyType = .next
            stackView?.insertArrangedSubview(firstName, at: 0)
        }
        
        if let repeatPassword = repeatPassword {
            repeatPassword.isHidden = true
            repeatPassword.textField?.returnKeyType = .go
            repeatPassword.textField?.isSecureTextEntry = true
            stackView?.insertArrangedSubview(repeatPassword, at: 0)
        }
        
        if let password = password {
            password.textField?.isSecureTextEntry = true
            stackView?.insertArrangedSubview(password, at: 0)
        }
        
        if let email = email {
            email.textField?.returnKeyType = .next
            email.textField?.autocorrectionType = .no
            email.textField?.keyboardType = .emailAddress
            stackView?.insertArrangedSubview(email, at: 0)
        }
        
        let router = LoginRouter(with: self)
        let interaction = LoginInteraction()
        let presenter = LoginPresenter(with: interaction, router: router)
        viperView = LoginView(with: presenter, and: self)
        
        guard let view = viperView as? LoginViewProtocol else {
            return
        }
        
        linkStoryboardViews(to: view)
        linkViewActions(to: presenter)
        
        presenter.configure()
    }

    private func linkStoryboardViews(to view: LoginViewProtocol) {
        view.stackView = stackView!
        view.scrollView = scrollView!
        view.authorisationButton = authorisationButton!
        view.authorisationModeButton = authorisationModeButton!
        view.email = email!
        view.password = password!
        view.lastName = lastName!
        view.firstName = firstName!
        view.repeatPassword = repeatPassword!
    }
    
    private func linkViewActions(to presenter: LoginPresenterProtocol) {
        presenter.listenTextFieldChanges(email?.textField)
        presenter.listenTextFieldChanges(password?.textField)
        presenter.listenTextFieldChanges(lastName?.textField)
        presenter.listenTextFieldChanges(firstName?.textField)
        presenter.listenTextFieldChanges(repeatPassword?.textField)

        authorisationButton?.addTouchUpInsideListener(completion: { _ in
            presenter.authoriseUser()
        })

        authorisationModeButton?.addTouchUpInsideListener(completion: { _ in
            presenter.switchAuthorisationMode()
        })
    }
}
