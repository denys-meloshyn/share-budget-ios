//
// Created by Denys Meloshyn on 23/09/2019.
// Copyright (c) 2019 Denys Meloshyn. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import CoreData
import url_builder

protocol APIUpdateTaskProtocol {
    var endpointURLBuilder: URL.Builder { get }
    var timeStampStorageManager: TimeStampStorageManager { get }

    func parseUpdates(items: [[String: Any?]], in managedObjectContext: NSManagedObjectContext)
}

class APIUpdateTask {
    let restApiURLBuilder: URL.Builder

    init(restApiURLBuilder: URL.Builder) {
        self.restApiURLBuilder = restApiURLBuilder
    }
}

extension APIUpdateTaskProtocol {
    func updates() -> Single<Bool> {
        Single.create { event in
            guard let url = self.endpointURLBuilder.appendPath("updates").build() else {
                event(.error(Constants.Errors.urlNotValid))
                return Disposables.create()
            }

            var request = URLRequest(url: url)
            request.method = .GET
            request.addUpdateCredentials(timestamp: self.timeStampStorageManager.timestamp)

            let task = AsynchronousURLConnection.create(request) { (data, response, error) -> Void in
                let errorType = BaseAPI.checkResponse(data: data, response: response, error: error)

                guard errorType == .none else {
                    Dependency.logger.error("Error: \(errorType)", userInfo: [Constants.key.json.logBody: String(describing: data)])
                    event(.error(errorType))
                    return
                }

                guard let dict = data as? [String: Any?] else {
                    Dependency.logger.error("Response has wrong structure", userInfo: [Constants.key.json.logBody: String(describing: data)])
                    event(.error(errorType))
                    return
                }

                guard let results = dict[Constants.key.json.result] as? [[String: Any?]] else {
                    Dependency.logger.error("'\(Constants.key.json.result)' has wrong structure", userInfo: [Constants.key.json.logBody: dict])
                    event(.error(errorType))
                    return
                }

                guard let timestamp = dict[Constants.key.json.timeStamp] as? String else {
                    Dependency.logger.error("'\(Constants.key.json.timeStamp)' missed", userInfo: [Constants.key.json.logBody: dict])
                    event(.error(errorType))
                    return
                }

                let managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)

                if !results.isEmpty {
                    self.timeStampStorageManager.timestamp = timestamp
                    self.parseUpdates(items: results, in: managedObjectContext)
                }

                if let pagination = dict[Constants.key.json.pagination] as? [String: Any] {
                    let pagination = PaginationAPI(with: pagination)

                    ModelManager.saveChildren(managedObjectContext) {
                        event(.success(pagination.hasNext()))
                    }
                } else {
                    ModelManager.saveChildren(managedObjectContext) {
                        event(.success(false))
                    }
                }
            }

            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
