//
//  SyncManager.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 14.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData
import XCGLogger

class SyncManager {
    private static var timer: Timer?
    private static var loadingTask: URLSessionTask?
    
    private class func appendTask(_ task: URLSessionTask?, to items: [URLSessionTask]) -> [URLSessionTask] {
        guard let task = task else {
            return items
        }
        
        var result = items
        result.append(task)
        
        return result
    }
    
    private class func scheduleNextUpdate() {
        SyncManager.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(15.0), repeats: false) { (timer) in
            SyncManager.loadUpdates(completion: nil)
        }
    }

    private class func loadUpdates(completion: APIResultBlock?) {
        var tasks = [URLSessionTask]()
        var task: URLSessionTask?
        let managedObjectContext = ModelManager.childrenManagedObjectContext(from: ModelManager.managedObjectContext)
        
        let completionBlock: APIResultBlock = { (data, error) -> (Void) in
            guard error == .none else {
                SyncManager.scheduleNextUpdate()
                return
            }
            
            tasks.remove(at: 0)
            
            if tasks.count == 0 {
                SyncManager.scheduleNextUpdate()
            }
            else {
                SyncManager.loadingTask = tasks.first
                SyncManager.loadingTask?.resume()
            }
        }
        
        task = UserAPI.updates("user", managedObjectContext) { (data, error) -> (Void) in
            completionBlock(data, error)
        }
        tasks = SyncManager.appendTask(task, to: tasks)
        
        if tasks.count == 0 {
            SyncManager.scheduleNextUpdate()
        }
        else {
            SyncManager.loadingTask = tasks.first
            SyncManager.loadingTask?.resume()
        }
    }
    
    class func run() {
        SyncManager.stop()
        
        XCGLogger.info("Start sync")
        SyncManager.loadUpdates(completion: nil)
    }
    
    class func stop() {
        XCGLogger.info("Stop sync")
        
        SyncManager.timer?.invalidate()
        SyncManager.loadingTask?.cancel()
    }
}
