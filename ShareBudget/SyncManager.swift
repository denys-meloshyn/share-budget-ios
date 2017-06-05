//
//  SyncManager.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 14.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData

class SyncManager {
    private static var timer: Timer?
    private static var loadingTask: URLSessionTask?
    
    private class func scheduleNextUpdate() {
        SyncManager.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(10.0), repeats: false) { (timer) in
            SyncManager.loadUpdates(completion: nil)
        }
    }
    
    static let userAPI = UserAPI()
    static let budgetAPI = BudgetAPI()
    static let expenseAPI = ExpenseAPI()
    static let categoryAPI = CategoryAPI()
    static let budgetLimitAPI = BudgetLimitAPI()
    
    static var tasks = [BaseAPITask]()

    private class func loadUpdates(completion: APIResultBlock?) {
        Dependency.logger.info("Load updates from server")
        
        self.tasks.removeAll()
        var task: BaseAPITask
        
        let completionBlock: APIResultBlock = { (data, error) -> (Void) in
            guard error == .none else {
                if error == .tokenExpired || error == .tokenNotValid {
                    Dependency.logger.error("Token is expired")
                    _ = AuthorisationAPI.login(email: Dependency.userCredentials.email, password: Dependency.userCredentials.password, completion: { (data, error) -> (Void) in
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
            
            self.tasks.remove(at: 0)
            
            if self.tasks.count == 0 {
                DispatchQueue.main.async {
                    SyncManager.scheduleNextUpdate()
                }
            }
            else {
                SyncManager.loadingTask = tasks.first?.request()
                SyncManager.loadingTask?.resume()
                NetworkIndicator.shared.visible = true
            }
        }
        
        // New or changed budgets
        tasks += self.budgetAPI.allChangedModels(completionBlock: completionBlock)
        
        // New or changed budget limits
        tasks += self.budgetLimitAPI.allChangedModels(completionBlock: completionBlock)
        
        // New or changed categories
        tasks += self.categoryAPI.allChangedModels(completionBlock: completionBlock)
        
        // New or changed expenses
        tasks += self.expenseAPI.allChangedModels(completionBlock: completionBlock)
        
        // Load all updates for 'User'
        task = BaseAPILoadUpdatesTask(resource: "user", entity: self.userAPI, completionBlock: completionBlock)
        tasks.append(task)
        
        // Load all updates for 'Budget'
        task = BaseAPILoadUpdatesTask(resource: "group", entity: self.budgetAPI, completionBlock: completionBlock)
        tasks.append(task)
        
        // Load all updates for 'Budget Limit'
        task = BaseAPILoadUpdatesTask(resource: "group/limit", entity: self.budgetLimitAPI, completionBlock: completionBlock)
        tasks.append(task)
        
        // Load all updates for 'Category'
        task = BaseAPILoadUpdatesTask(resource: "category", entity: self.categoryAPI, completionBlock: completionBlock)
        tasks.append(task)
        
        // Load all updates for 'Expense'
        task = BaseAPILoadUpdatesTask(resource: "expense", entity: self.expenseAPI, completionBlock: completionBlock)
        tasks.append(task)
        
        // -----------------
        
        if tasks.count == 0 {
            SyncManager.scheduleNextUpdate()
        }
        else {
            SyncManager.loadingTask = tasks.first?.request()
            SyncManager.loadingTask?.resume()
            NetworkIndicator.shared.visible = true
        }
    }
    
    class func insertPaginationTask(_ task: BaseAPITask) {
        self.tasks.insert(task, at: 1)
    }
    
    class func run() {
        if (Dependency.environment() == .testing) {
            return
        }
        
        SyncManager.stop()
        
        Dependency.logger.info("Start sync")
        SyncManager.loadUpdates(completion: nil)
    }
    
    class func stop() {
        Dependency.logger.info("Stop sync")
        
        SyncManager.timer?.invalidate()
        SyncManager.loadingTask?.cancel()
    }
}
