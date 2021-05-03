//
//  LoginViewController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

import AuthenticationServices
import RxCocoa
import RxSwift
import SnapKit

class LoginViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private var presenter: LoginPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        let router = LoginRouter(with: self)
        let interactor = LoginInteraction(authorisationAPI: AuthorisationAPI.instance)
        presenter = LoginPresenter(interactor: interactor, router: router)

        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .whiteOutline)
        button.addTarget(self, action: #selector(handleAuthorizationButtonPress), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
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
                                 didCompleteWithAuthorization authorization: ASAuthorization)
    {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = credential.user
            guard let identityTokenData = credential.identityToken,
                  let identityToken = String(bytes: identityTokenData, encoding: .utf8)
            else {
                return
            }

            presenter.login(userIdentifier: userIdentifier, identityToken: identityToken, firstName: credential.fullName?.givenName, lastName: credential.fullName?.familyName)
        }
    }

    func presentationAnchor(for _: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }

    func authorizationController(controller _: ASAuthorizationController, didCompleteWithError _: Error) {
        // Handle error
    }
}
