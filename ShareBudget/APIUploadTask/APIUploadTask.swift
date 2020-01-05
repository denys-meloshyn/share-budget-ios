//
// Created by Denys Meloshyn on 22/12/2019.
// Copyright (c) 2019 Denys Meloshyn. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

protocol APIUploadTaskProtocol: class {
    var modelID: NSManagedObjectID { get }
    var endpointURLBuilder: URL.Builder { get }
}

class APIUploadTask {
    let modelID: NSManagedObjectID
    let restApiURLBuilder: URL.Builder

    init(restApiURLBuilder: URL.Builder, modelID: NSManagedObjectID) {
        self.modelID = modelID
        self.restApiURLBuilder = restApiURLBuilder
    }
}

extension APIUploadTaskProtocol {
    func parseUpdate(item: [String: Any?], managedObjectContext: NSManagedObjectContext) {
        let model = managedObjectContext.object(with: modelID) as? BaseModel
        model?.update(with: item, in: managedObjectContext)
        model?.isChanged = NSNumber(false)
    }
    
    func upload() -> Completable {
        Completable.create { event in
            guard let url = self.endpointURLBuilder.build() else {
                event(.error(Constants.Errors.urlNotValid))
                return Disposables.create()
            }
            
            let backgroundContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)
            guard let model = backgroundContext.object(with: self.modelID) as? BaseModel else {
                event(.error(Constants.Errors.nilObject))
                return Disposables.create()
            }

            var request = URLRequest(url: url)
            request.method = .PUT
            request.addUploadCredentials()

            var json = model.uploadProperties()
            json[Constants.key.json.userID] = Dependency.userCredentials.userID

            let formValues = json.map { (key, value) -> String in
                "\(key)=\(value)"
            }.joined(separator: "&")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = formValues.data(using: .utf8)

            let task = AsynchronousURLConnection.create(request) { [weak self] (data, response, error) -> Void in
                let errorType = BaseAPI.checkResponse(data: data, response: response, error: error)

                guard errorType == .none else {
                    event(.error(errorType))
                    return
                }

                guard let dict = data as? [String: Any?] else {
                    event(.error(errorType))
                    return
                }

                guard let result = dict[Constants.key.json.result] as? [String: Any?] else {
                    event(.error(errorType))
                    return
                }

                let managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)
                self?.parseUpdate(item: result, managedObjectContext: managedObjectContext)
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
