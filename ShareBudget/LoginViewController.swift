//
//  LoginViewController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginViewController: BaseViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    @IBOutlet private var stackView: UIStackView?
    @IBOutlet private var scrollView: UIScrollView?
    @IBOutlet private var authorisationButton: ButtonListener?
    @IBOutlet private var authorisationModeButton: ButtonListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(handleAuthorizationButtonPress),for: .touchUpInside)
        stackView?.addArrangedSubview(button)
        
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
    
    @objc func handleAuthorizationButtonPress() {
     let request = ASAuthorizationAppleIDProvider().createRequest()
     request.requestedScopes = [.fullName, .email]
     let controller = ASAuthorizationController(authorizationRequests: [request])
     controller.delegate = self
     controller.presentationContextProvider = self
     controller.performRequests()
    }
    
    func authorizationController(controller _: ASAuthorizationController,
     didCompleteWithAuthorization authorization: ASAuthorization) {
     if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
     let userIdentifier = credential.user
     let identityToken = credential.identityToken
     let authCode = credential.authorizationCode
     let realUserStatus = credential.realUserStatus
     // Create account in your system
     }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller _: ASAuthorizationController, didCompleteWithError error: Error) {
     // Handle error
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
