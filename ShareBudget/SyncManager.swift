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
    
    private class func scheduleNextUpdate() {
        SyncManager.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(10.0), repeats: false) { (timer) in
            SyncManager.loadUpdates(completion: nil)
        }
    }

    private class func loadUpdates(completion: APIResultBlock?) {
        XCGLogger.info("Load updates from server")
        
        var tasks = [BaseAPITask]()
        var task: BaseAPITask
        
        let completionBlock: APIResultBlock = { (data, error) -> (Void) in
            guard error == .none else {
                if error == .tokenExpired || error == .tokenNotValid {
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
                SyncManager.loadingTask = tasks.first?.request()
                SyncManager.loadingTask?.resume()
            }
        }
        
        // New or changed budgets
        tasks += BudgetAPI.allChangedModels(completionBlock: completionBlock)
        
        // New or changed budget limits
        tasks += BudgetLimitAPI.allChangedModels(completionBlock: completionBlock)
        
        // New or changed categories
        tasks += CategoryAPI.allChangedModels(completionBlock: completionBlock)
        
        // New or changed expenses
        tasks += ExpenseAPI.allChangedModels(completionBlock: completionBlock)
        
        // Load all updates for 'User'
        task = BaseAPILoadUpdatesTask(resource: "user", entity: UserAPI.self, completionBlock: completionBlock)
        tasks.append(task)
        
        // Load all updates for 'Budget'
        task = BaseAPILoadUpdatesTask(resource: "group", entity: BudgetAPI.self, completionBlock: completionBlock)
        tasks.append(task)
        
        // Load all updates for 'Budget Limit'
        task = BaseAPILoadUpdatesTask(resource: "group/limit", entity: BudgetLimitAPI.self, completionBlock: completionBlock)
        tasks.append(task)
        
        // Load all updates for 'Category'
        task = BaseAPILoadUpdatesTask(resource: "category", entity: CategoryAPI.self, completionBlock: completionBlock)
        tasks.append(task)
        
        // Load all updates for 'Expense'
        task = BaseAPILoadUpdatesTask(resource: "expense", entity: ExpenseAPI.self, completionBlock: completionBlock)
        tasks.append(task)
        
        // -----------------
        
        
        
        if tasks.count == 0 {
            SyncManager.scheduleNextUpdate()
        }
        else {
            SyncManager.loadingTask = tasks.first?.request()
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
