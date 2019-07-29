//
//  LoginViewController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import SnapKit
import AuthenticationServices

class LoginViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    @IBOutlet private var stackView: UIStackView?
    @IBOutlet private var scrollView: UIScrollView?
    @IBOutlet private var authorisationButton: ButtonListener?
    @IBOutlet private var authorisationModeButton: ButtonListener?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .whiteOutline)
        button.addTarget(self, action: #selector(handleAuthorizationButtonPress), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
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
}
