//
//  AuthorisationAPI.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 26.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import HTTPNetworking

protocol AuthorisationAPIProtocol {
    func appleLogin(userIdentifier: String, identityToken: String, firstName: String?, lastName: String?) -> Single<AuthorisationAPI.ResponseAppleLogin>
}

class AuthorisationAPI: BaseAPI, AuthorisationAPIProtocol {
    static let instance = AuthorisationAPI()
    
    struct ResponseAppleLogin {
        let accessToken: String
        let refreshToken: String
        let user: UserEntity
    }
    
    struct ResponseAccessRefreshToken {
        let accessToken: String
        let refreshToken: String
    }
    
    func componentsLoginApple() -> URLComponents {
        var components = Dependency.backendConnection
        components.path = Dependency.restAPIVersion + "/login/apple"
        
        return components
    }
    
    func componentsAccessRefreshToken() -> URLComponents {
        var components = Dependency.backendConnection
        components.path = Dependency.restAPIVersion + "/login/jwt/refresh"
        
        return components
    }
    
    func appleLogin(userIdentifier: String, identityToken: String, firstName: String?, lastName: String?) -> Single<ResponseAppleLogin> {
        return Single.create { event in
            guard let url = self.componentsLoginApple().url else {
                event(.error(Constants.Errors.urlNotValid))
                return Disposables.create()
            }
            
            var request = URLRequest(url: url)
            request.method = .POST
            let properties = ["userID": userIdentifier, "identityToken": identityToken, "lastName": lastName ?? "", "firstName": firstName ?? ""]
            request.httpBody = self.formValues(properties: properties)
            
            let task = self.loader.loadJSON(request) { data, _, error in
                if let error = error {
                    event(.error(error))
                    return
                }
                
                guard let json = data as? [String: Any] else {
                    event(.error(Constants.Errors.wrongResponseFormat))
                    return
                }
                
                guard let accessToken = json["accessToken"] as? String, let refreshToken = json["refreshToken"] as? String else {
                    event(.error(Constants.Errors.wrongResponseFormat))
                    return
                }
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
                    
                    let decoder = JSONDecoder()
                    let user = try decoder.decode(UserEntity.self, from: jsonData)
                    event(.success(ResponseAppleLogin(accessToken: accessToken, refreshToken: refreshToken, user: user)))
                } catch {
                    event(.error(error))
                }
            }
            
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func getRefreshAccessToke(refreshToken: String) -> Single<ResponseAccessRefreshToken> {
        return Single.create { event in
            guard let url = self.componentsAccessRefreshToken().url else {
                event(.error(Constants.Errors.urlNotValid))
                return Disposables.create()
            }
            
            var request = URLRequest(url: url)
            request.method = .POST
            request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
            
            let task = self.loader.loadJSON(request) { data, _, error in
                if let error = error {
                    event(.error(error))
                    return
                }
                
                guard let json = data as? [String: Any] else {
                    event(.error(Constants.Errors.wrongResponseFormat))
                    return
                }
                
                guard let accessToken = json["accessToken"] as? String, let refreshToken = json["refreshToken"] as? String else {
                    event(.error(Constants.Errors.wrongResponseFormat))
                    return
                }
                
                event(.success(ResponseAccessRefreshToken(accessToken: accessToken, refreshToken: refreshToken)))
            }
            
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
