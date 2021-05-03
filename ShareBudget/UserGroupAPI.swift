//
//  UserGroupAPI.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 21.07.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData
import RxSwift

class UserGroupAPI: BaseAPI {
    func addUserToGroup(token: String) -> Single<String> {
        Single.create { event in
            let builder = Dependency.instance.restApiUrlBuilder().appendPath("user").appendPath("group")

            guard let url = builder.build() else {
                event(.error(Constants.Errors.urlNotValid))
                return Disposables.create()
            }

            var request = URLRequest(url: url)
            request.method = .POST
            request.addToken()

            let formValues = ["invitationToken": token].map { (key, value) -> String in
                "\(key)=\(value)"
            }.joined(separator: "&")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = formValues.data(using: .utf8)

            let task = AsynchronousURLConnection.create(request) { data, response, error -> Void in
                let errorType = BaseAPI.checkResponse(data: data, response: response, error: error)

                guard errorType == .none else {
                    event(.error(errorType))
                    return
                }

                guard let dict = data as? [String: Any?], let token = dict["token"] as? String else {
                    event(.error(errorType))
                    return
                }

                event(.success(token))
            }

            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }

    func invitationToken(groupID: String) -> Single<String> {
        Single.create { event in
            let builder = Dependency.instance.restApiUrlBuilder().appendPath("user").appendPath("group").appendPath("invite")

            guard let url = builder.build() else {
                event(.error(Constants.Errors.urlNotValid))
                return Disposables.create()
            }

            var request = URLRequest(url: url)
            request.method = .GET
            request.addToken()
            request.setValue(groupID, forHTTPHeaderField: Constants.key.json.groupID)

            let task = AsynchronousURLConnection.create(request) { data, response, error -> Void in
                let errorType = BaseAPI.checkResponse(data: data, response: response, error: error)

                guard errorType == .none else {
                    event(.error(errorType))
                    return
                }

                guard let dict = data as? [String: Any?],
                      let result = dict[Constants.key.json.result] as? [String: Any?],
                      let token = result["token"] as? String
                else {
                    event(.error(errorType))
                    return
                }

                event(.success(token))
            }

            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }

    override func timestampStorageKey() -> String {
        return "user_group_timestamp"
    }

    override func parseUpdates(items: [[String: Any?]], in managedObjectContext: NSManagedObjectContext) {
        var userGroup: UserGroup?

        for item in items {
            userGroup = ModelManager.findOrCreateEntity(UserGroup.self, response: item, in: managedObjectContext) as? UserGroup
            userGroup?.update(with: item, in: managedObjectContext)
        }
    }

    override func allChangedModels(completionBlock: APIResultBlock?) -> [BaseAPITask] {
        let managedObjectContext = ModelManager.managedObjectContext
        let tasks = ModelManager.changedTasks(modelEntity: UserGroup.self,
                                              apiEntity: self,
                                              resource: "user/group",
                                              managedObjectContext: managedObjectContext,
                                              completionBlock: completionBlock)
        return tasks
    }
}
