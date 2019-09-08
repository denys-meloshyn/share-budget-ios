//
//  UserCredentials.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

import KeychainSwift

protocol UserCredentialsProtocol {
    var isLoggedIn: Bool { get }
    var userID: String { get set }
    var accessToken: String { get set }
    var refreshToken: String { get set }

    func logout()
}

class UserCredentials: UserCredentialsProtocol {
    enum Constants {
        static let keyUserID = "userID"
        static let keyAccessToken = "accessToken"
        static let keyRefreshToken = "refreshToken"
    }
    
    static let instance = UserCredentials(keychain: KeychainSwift())

    private let keychain: KeychainSwift

    var isLoggedIn: Bool {
        guard !userID.isEmpty, !accessToken.isEmpty, !refreshToken.isEmpty else {
            return false
        }

        return true
    }

    var userID: String {
        get {
            return keychain.get(Constants.keyUserID) ?? ""
        }

        set {
            keychain.set(newValue, forKey: Constants.keyUserID)
        }
    }

    var accessToken: String {
        get {
            return keychain.get(Constants.keyAccessToken) ?? ""
        }

        set {
            keychain.set(newValue, forKey: Constants.keyAccessToken)
        }
    }

    var refreshToken: String {
        get {
            return keychain.get(Constants.keyRefreshToken) ?? ""
        }

        set {
            keychain.set(newValue, forKey: Constants.keyRefreshToken)
        }
    }

    init(keychain: KeychainSwift) {
        self.keychain = keychain
    }

    func logout() {
        userID = ""
        accessToken = ""
        refreshToken = ""
        
        UserCredentials.resetTimeStamps()
    }

    class func resetTimeStamps() {
        SyncManager.shared.categoryAPI.timestamp = ""
        SyncManager.shared.expenseAPI.timestamp = ""
        SyncManager.shared.budgetAPI.timestamp = ""
        SyncManager.shared.budgetLimitAPI.timestamp = ""
        SyncManager.shared.userAPI.timestamp = ""
        SyncManager.shared.userGroupAPI.timestamp = ""
    }
}
