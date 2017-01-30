//
//  UserCredentials.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

import KeychainSwift

private let keychain = KeychainSwift()
private let keyUserID = "userID"
private let keychainToken = "token"
private let keychainEmail = "email"
private let keyTimestamp = "timestamp"
private let keychainPassword = "password"

class UserCredentials {
    class var token: String {
        get {
            return keychain.get(keychainToken) ?? ""
        }
        
        set {
            keychain.set(newValue, forKey: keychainToken)
        }
    }
    
    class var password: String {
        get {
            return keychain.get(keychainPassword) ?? ""
        }
        
        set {
            keychain.set(newValue, forKey: keychainPassword)
        }
    }
    
    class var email: String {
        get {
            return keychain.get(keychainEmail) ?? ""
        }
        
        set {
            keychain.set(newValue, forKey: keychainEmail)
        }
    }
    
    class var userID: Int {
        get {
            return Int(UserDefaults.standard.string(forKey: keyUserID) ?? "-1") ?? -1
        }
        
        set {
            UserDefaults.standard.set(String(newValue), forKey: keyUserID)
        }
    }
    
    class var isLoggedIn: Bool {
        return UserCredentials.userID >= 0
    }
    
    class func logout() {
        UserCredentials.token = ""
        UserCredentials.userID = -1
        UserCredentials.password = ""
        
        UserAPI.timestamp = ""
        BudgetAPI.timestamp = ""
    }
}
