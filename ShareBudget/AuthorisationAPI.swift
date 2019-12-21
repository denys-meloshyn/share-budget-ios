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
import url_builder
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
    
    func urlBuilderLoginApple() -> URL.Builder {
        Dependency.instance.restApiUrlBuilder()
                           .appendPath("login")
                           .appendPath("apple")
    }
    
    func urlBuilderAccessRefreshToken() -> URL.Builder {
        Dependency.instance.restApiUrlBuilder()
                           .appendPath("login")
                           .appendPath("jwt")
                           .appendPath("refresh")
    }
    
    func appleLogin(userIdentifier: String, identityToken: String, firstName: String?, lastName: String?) -> Single<ResponseAppleLogin> {
        Single.create { event in
            guard let url = self.urlBuilderLoginApple().build() else {
                event(.error(Constants.Errors.urlNotValid))
                return Disposables.create()
            }
            
            var request = URLRequest(url: url)
            request.method = .POST
            let properties = ["appleID": userIdentifier, "identityToken": identityToken, "lastName": lastName ?? "", "firstName": firstName ?? ""]
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
                
                guard let accessToken = json["accessToken"] as? String, 
                      let refreshToken = json["refreshToken"] as? String else {
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
        Single.create { event in
            guard let url = self.urlBuilderAccessRefreshToken().build() else {
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
                
                guard let accessToken = json["accessToken"] as? String, 
                      let refreshToken = json["refreshToken"] as? String else {
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
