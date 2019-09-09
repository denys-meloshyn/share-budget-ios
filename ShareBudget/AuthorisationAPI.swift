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

class AuthorisationAPI: BaseAPI {
    struct ResponseAppleLogin {
        let accessToken: String
        let refreshToken: String
        let user: UserEntity
    }
    
    func componentsLoginApple() -> URLComponents {
        var components = Dependency.backendConnection
        components.path = Dependency.restAPIVersion + "/login/apple"
        
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
            
            let task = self.loader.loadJSON(request) { data, _, error in
                if let error = error {
                    event(.error(error))
                    return
                }
                
                guard let json = data as? [String: String] else {
                    event(.error(Constants.Errors.wrongResponseFormat))
                    return
                }
                
                guard let accessToken = json["accessToken"], let refreshToken = json["refreshToken"] else {
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
    
    class func login(email: String, password: String, completion: APIResultBlock?) -> URLSessionTask? {
        let components = AuthorisationAPI.components("login")
        
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.method = .POST
        request.setValue(email, forHTTPHeaderField: Constants.key.json.email)
        request.setValue(password, forHTTPHeaderField: Constants.key.json.password)
        
        return AsynchronousURLConnection.run(request, completion: { (data, response, error) -> Void in
            let errorType = BaseAPI.checkResponse(data: data, response: response, error: error)
            
            guard errorType == .none else {
                completion?(data, errorType)
                return
            }
            
            guard let dict = data as? [String: AnyObject?] else {
                Dependency.logger.error("Response has wrong structure")
                completion?(data, .unknown)
                return
            }
            
            guard let result = dict[Constants.key.json.result] as? [String: AnyObject?] else {
                Dependency.logger.error("'result' has wrong structure")
                completion?(data, .unknown)
                return
            }
            
            guard let userID = result[Constants.key.json.userID] as? Int else {
                Dependency.logger.error("'userID' is missed")
                completion?(data, .unknown)
                return
            }
            
            guard let token = result[Constants.key.json.token] as? String else {
                Dependency.logger.error("'token' is missed")
                completion?(data, .unknown)
                return
            }
            
            var user = ModelManager.findEntity(User.self, by: userID, in: ModelManager.managedObjectContext)
            if user == nil {
                user = User(context: ModelManager.managedObjectContext)
            }
            
            user?.update(with: result, in: ModelManager.managedObjectContext)
            ModelManager.saveContext(ModelManager.managedObjectContext)
            
            completion?(user, .none)
        })
    }
    
    class func singUp(email: String, password: String, firstName: String, lastName: String?, completion: APICompletionBlock?) -> URLSessionTask? {
        let components = AuthorisationAPI.components("user")
        
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(email, forHTTPHeaderField: Constants.key.json.email)
        request.setValue(password, forHTTPHeaderField: Constants.key.json.password)
        request.setValue(firstName, forHTTPHeaderField: Constants.key.json.firstName)
        request.setValue(lastName, forHTTPHeaderField: Constants.key.json.lastName)
        
        return AsynchronousURLConnection.run(request, completion: completion)
    }
    
    class func sendRegistrationEmail(_ email: String) {
        let components = AuthorisationAPI.components("registration/sendemail")
        
        guard let url = components.url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(email, forHTTPHeaderField: Constants.key.json.email)
        
        _ = AsynchronousURLConnection.run(request, completion: nil)
    }
}
