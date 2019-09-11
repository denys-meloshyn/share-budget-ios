//
//  LoginInteraction.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

protocol LoginInteractionProtocol: BaseInteractionProtocol {
    func login(userIdentifier: String, identityToken: String, firstName: String?, lastName: String?) -> Single<AuthorisationAPI.ResponseAppleLogin>
}

class LoginInteraction: LoginInteractionProtocol {
    private let authorisationAPI: AuthorisationAPIProtocol
    
    init(authorisationAPI: AuthorisationAPIProtocol ) {
        self.authorisationAPI = authorisationAPI
    }
    
    func login(userIdentifier: String, identityToken: String, firstName: String?, lastName: String?) -> Single<AuthorisationAPI.ResponseAppleLogin> {
        return authorisationAPI.appleLogin(userIdentifier: userIdentifier, identityToken: identityToken, firstName: firstName, lastName: lastName)
    }
}
