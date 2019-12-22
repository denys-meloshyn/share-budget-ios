//
// Created by Denys Meloshyn on 22/12/2019.
// Copyright (c) 2019 Denys Meloshyn. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

protocol APIUploadTaskProtocol {
    var endpointURLBuilder: URL.Builder { get }
    func parseUpdates(items: [String: Any?], in managedObjectContext: NSManagedObjectContext)
}

extension APIUploadTaskProtocol {
    func upload() -> Completable {
        Completable.create { event in
            guard let url = self.endpointURLBuilder.build() else {
                event(.error(NSError(domain: "", code: -1)))
                return Disposables.create()
            }

            var request = URLRequest(url: url)
            request.method = .PUT
            request.addUploadCredentials()

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

                guard let result = dict[Constants.key.json.result] as? [String: Any?] else {
                    Dependency.logger.error("'\(Constants.key.json.result)' has wrong structure", userInfo: [Constants.key.json.logBody: dict])
                    event(.error(errorType))
                    return
                }

                let managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)

                self.parseUpdates(items: result, in: managedObjectContext)
                ModelManager.saveChildren(managedObjectContext) {
                    event(.completed)
                }
            }

            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
