//
//  LoginPresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

protocol LoginPresenterDelegate: class {}

protocol LoginPresenterProtocol {
    func login(userIdentifier: String, identityToken: String, firstName: String?, lastName: String?)
}

class LoginPresenter: LoginPresenterProtocol {
    private let disposeBag = DisposeBag()
    private let router: LoginRouterProtocol
    private let interactor: LoginInteractionProtocol
    private weak var delegate: LoginPresenterDelegate?

    init(interactor: LoginInteractionProtocol, router: LoginRouterProtocol) {
        self.router = router
        self.interactor = interactor
    }

    func login(userIdentifier: String, identityToken: String, firstName: String?, lastName: String?) {
        interactor.login(userIdentifier: userIdentifier, identityToken: identityToken, firstName: firstName, lastName: lastName).subscribe { event in
            switch event {
            case let .success(model):
                UserCredentials.instance.accessToken = model.accessToken
                UserCredentials.instance.refreshToken = model.refreshToken
                UserCredentials.instance.userID = String("\(model.user.userID ?? -1)")

                SyncManager.shared.run()

                self.router.showHomePage()
            case .error:
                break
            }
        }.disposed(by: disposeBag)
    }
}
