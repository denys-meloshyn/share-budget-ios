//
//  SyncManager.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 14.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

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
        SyncManager.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(5.0), repeats: false) { (timer) in
            SyncManager.loadUpdates(completion: nil)
        }
    }

    private class func loadUpdates(completion: APIResultBlock?) {
        XCGLogger.info("Load updates from server")
        
        var tasks = [URLSessionTask]()
        var task: URLSessionTask?
        
        let completionBlock: APIResultBlock = { (data, error) -> (Void) in
            guard error == .none else {
                if error == .tokenExpired {
                    XCGLogger.error("Token is expired")
                    _ = AuthorisationAPI.login(email: UserCredentials.email, password: UserCredentials.password, completion: { (data, error) -> (Void) in
                        if error == .none {
                            SyncManager.loadUpdates(completion: completion)
                        }
                        else if error == .unknown{
                            DispatchQueue.main.async {
                                SyncManager.scheduleNextUpdate()
                            }
                        }
                        else {
                            completion?(data, error)
                        }
                    })
                    
                    return
                }
                else if error == .unknown {
                    DispatchQueue.main.async {
                        SyncManager.scheduleNextUpdate()
                    }
                }
                else {
                    completion?(data, error)
                }
                
                return
            }
            
            tasks.remove(at: 0)
            
            if tasks.count == 0 {
                DispatchQueue.main.async {
                    SyncManager.scheduleNextUpdate()
                }
            }
            else {
                SyncManager.loadingTask = tasks.first
                SyncManager.loadingTask?.resume()
            }
        }
        
        // Load all updates for 'User'
        task = UserAPI.updates("user", completionBlock)
        tasks = SyncManager.appendTask(task, to: tasks)
        
        // Load all updates for 'Budget'
        task = BudgetAPI.updates("group", completionBlock)
        tasks = SyncManager.appendTask(task, to: tasks)
        
        // Load all updates for 'Budget Limit'
        task = BudgetLimitAPI.updates("group/limit", completionBlock)
        tasks = SyncManager.appendTask(task, to: tasks)
        
        task = CategoryAPI.updates("category", completionBlock)
        tasks = SyncManager.appendTask(task, to: tasks)
        
        // -----------------
        
        let managedObjectContext = ModelManager.managedObjectContext
        let budgetFetchController = ModelManager.budgetChangedFetchController(managedObjectContext)
        do {
            try budgetFetchController.performFetch()
        }
        catch {
            XCGLogger.error("Can't fetch data \(error)")
        }
        
        var indexPath = IndexPath()
        var sections = [NSFetchedResultsSectionInfo]()
        
        sections = budgetFetchController.sections ?? []
        for section in 0..<sections.count {
            let sectionInfo = sections[section]
            for row in 0..<sectionInfo.numberOfObjects {
                indexPath = IndexPath(row: row, section: section)
                let budget = budgetFetchController.object(at: indexPath)
                task = BudgetAPI.upload(managedObjectContext, budget, completionBlock)
                tasks = SyncManager.appendTask(task, to: tasks)
            }
        }
        
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
