//
//  SyncManager.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 14.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData

protocol SyncManagerDelegate: class {
    func error(_ error: ErrorTypeAPI)
}

class SyncManager {
    static let shared = SyncManager()
    
    private init() {}
    
    weak var delegate: SyncManagerDelegate? = nil
    
    private var timer: Timer?
    private var loadingTask: URLSessionTask?
    
    private func scheduleNextUpdate() {
        self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(10.0), repeats: false) { (timer) in
            self.loadUpdates(completion: nil)
        }
    }
    
    let userAPI = UserAPI()
    let budgetAPI = BudgetAPI()
    let expenseAPI = ExpenseAPI()
    let categoryAPI = CategoryAPI()
    let userGroupAPI = UserGroupAPI()
    let budgetLimitAPI = BudgetLimitAPI()
    
    var tasks = [BaseAPITask]()

    private func loadUpdates(completion: APIResultBlock?) {
        Dependency.logger.info("Load updates from server")
        
        self.tasks.removeAll()
        var task: BaseAPITask
        
        let completionBlock: APIResultBlock = { [weak self] (data, error) -> (Void) in
            guard error == .none else {
                if error == .tokenExpired || error == .tokenNotValid {
                    Dependency.logger.error("Token is expired")
                    _ = AuthorisationAPI.login(email: Dependency.userCredentials.email, password: Dependency.userCredentials.password, completion: { (data, error) -> (Void) in
                        switch (error) {
                        case .none:
                            self?.loadUpdates(completion: completion)
                        case .unknown:
                            DispatchQueue.main.async {
                                self?.delegate?.error(error)
                                self?.scheduleNextUpdate()
                            }
                        default:
                            completion?(data, error)
                        }
                    })
                    
                    return
                }
                else if error == .unknown {
                    DispatchQueue.main.async {
                        self?.delegate?.error(error)
                        self?.scheduleNextUpdate()
                    }
                }
                else {
                    completion?(data, error)
                }
                
                return
            }
            
            self?.tasks.remove(at: 0)
            
            if self?.tasks.count == 0 {
                DispatchQueue.main.async {
                    self?.scheduleNextUpdate()
                }
            }
            else {
                self?.loadingTask = self?.tasks.first?.request()
                self?.loadingTask?.resume()
                NetworkIndicator.shared.visible = true
            }
        }
        
        // New or changed budgets
        tasks += self.budgetAPI.allChangedModels(completionBlock: completionBlock)
        
        // New or changed budget limits
        tasks += self.budgetLimitAPI.allChangedModels(completionBlock: completionBlock)
        
        // New or changed user groups
        tasks += self.userGroupAPI.allChangedModels(completionBlock: completionBlock)
        
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
        
        // Load all updates for 'User Groups'
        task = BaseAPILoadUpdatesTask(resource: "user/group", entity: self.userGroupAPI, completionBlock: completionBlock)
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
            self.scheduleNextUpdate()
        }
        else {
            self.loadingTask = tasks.first?.request()
            self.loadingTask?.resume()
            NetworkIndicator.shared.visible = true
        }
    }
    
    func insertPaginationTask(_ task: BaseAPITask) {
        self.tasks.insert(task, at: 1)
    }
    
    func run() {
        if (Dependency.environment() == .testing) {
            return
        }
        
        self.stop()
        
        Dependency.logger.info("Start sync")
        self.loadUpdates(completion: nil)
    }
    
    func stop() {
        Dependency.logger.info("Stop sync")
        
        self.timer?.invalidate()
        self.loadingTask?.cancel()
    }
}
