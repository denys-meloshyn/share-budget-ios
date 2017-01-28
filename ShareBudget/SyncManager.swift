//
//  SyncManager.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 14.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

class SyncManager {
    private class func appendTask(_ task: URLSessionTask?, to items: [URLSessionTask]) -> [URLSessionTask] {
        guard let task = task else {
            return items
        }
        
        var result = items
        result.append(task)
        
        return result
    }
    
    class func loadUpdates(completion: APIResultBlock?) {
        var tasks = [URLSessionTask]()
        var task: URLSessionTask?
        let managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.sharedInstance.managedObjectContext)
        
        let completionBlock: APIResultBlock = { (data, error) -> (Void) in
            guard error == .none else {
                completion?(nil, error)
                return
            }
            
            tasks.remove(at: 0)
            
            if tasks.count == 0 {
                completion?(nil, .none)
            }
            else {
                let newTask = tasks.first
                newTask?.resume()
            }
        }
        
        task = UserAPI.updates("user", managedObjectContext) { (data, error) -> (Void) in
            completionBlock(data, error)
        }
        tasks = SyncManager.appendTask(task, to: tasks)
        
        if tasks.count == 0 {
            completion?(nil, .none)
        }
        else {
            tasks.first?.resume()
        }
    }
}
