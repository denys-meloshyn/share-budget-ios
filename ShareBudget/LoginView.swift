//
//  LoginView.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class LoginView: BaseView {
    weak var stackView: UIStackView?
    weak var emailTextField: UITextField?
    weak var authorisationButton: UIButton?
    weak var passwordTextField: UITextField?
    weak var lastNameTextField: UITextField?
    weak var firstNameTextField: UITextField?
    weak var repeatPasswordTextField: UITextField?
    
    override init(with presenter: BasePresenter, and viewController: UIViewController) {
        super.init(with: presenter, and: viewController)
        
        guard let presenter = presenter as? LoginPresenter else {
            return
        }
        
        presenter.delegate = self
    }
}

extension LoginView: LoginPresenterDelegate {
    private func updateButton(title: String) {
        self.authorisationButton?.setTitle(title, for: .normal)
        self.authorisationButton?.setTitle(title, for: .selected)
    }
    
    private func updateSignUpViews(hidden: Bool) {
        self.lastNameTextField?.isHidden = hidden
        self.firstNameTextField?.isHidden = hidden
        self.repeatPasswordTextField?.isHidden = hidden
    }
    
    func showLogin(title: String) {
        UIView.animate(withDuration: 0.3) {
            self.updateSignUpViews(hidden: true)
            self.updateButton(title: title)
        }
    }
    
    func showSignUp(title: String) {
        UIView.animate(withDuration: 0.3) {
            self.updateSignUpViews(hidden: false)
            self.updateButton(title: title)
        }
    }
}
