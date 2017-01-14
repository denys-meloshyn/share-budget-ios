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
private let keychainToken = "token"
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
    
    var password: String {
        get {
            return keychain.get(keychainPassword) ?? ""
        }
        
        set {
            keychain.set(newValue, forKey: keychainPassword)
        }
    }
}
