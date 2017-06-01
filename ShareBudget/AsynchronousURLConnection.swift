//
//  AsynchronousURLConnection.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import XCGLogger

typealias APICompletionBlock = (Any?, URLResponse?, Error?) -> (Void)

class AsynchronousURLConnection {
    private static func logError(data: Data?) {
        guard let data = data else {
            return
        }
        
        let response = String(data: data, encoding: .utf8)
        XCGLogger.error(response)
    }
    
    class func run(_ request: URLRequest, completion: APICompletionBlock?) -> URLSessionDataTask {
        let task = AsynchronousURLConnection.create(request, completion: completion)
        
        NetworkIndicator.shared.visible = true
        task.resume()
        
        return task
    }
    
    class func create(_ request: URLRequest, completion: APICompletionBlock?) -> URLSessionDataTask {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        XCGLogger.info("\(request.httpMethod!) \(request.url!)")
        let complitionResponseBlock = { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            NetworkIndicator.shared.visible = false
            
            if let _ = error {
                XCGLogger.error(error)
                
                completion?(data, response, error)
                return
            }
            
            guard let data = data else {
                completion?(nil, response, error)
                return
            }
            
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                completion?(result, response, error)
            }
            catch {
                AsynchronousURLConnection.logError(data: data)
                completion?(data, response, error)
            }
        }
        
        let task = session.dataTask(with: request, completionHandler: complitionResponseBlock)
        
        return task
    }
}
