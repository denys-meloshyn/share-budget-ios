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
        
        let userIdentifier = ""
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
            switch credentialState {
            case .authorized:
                // The Apple ID credential is valid. Show Home UI Here
                break
            case .revoked:
                // The Apple ID credential is revoked. Show SignIn UI Here.
                break
            case .notFound:
                // No credential was found. Show SignIn UI Here.
                break
            default:
                break
            }
        }

    }

    @objc func handleAuthorizationButtonPress() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    func authorizationController(controller _: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = credential.user
            let authCode = credential.authorizationCode
            let realUserStatus = credential.realUserStatus
            if let identityTokenData = credential.identityToken,
                let identityToken = String(bytes: identityTokenData, encoding: .utf8) {
                print(identityToken)
            }
            
            // Create account in your system
        }
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }

    func authorizationController(controller _: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error
    }
}
