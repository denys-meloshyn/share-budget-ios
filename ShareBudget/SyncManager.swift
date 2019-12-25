//
//  SyncManager.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 14.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData
import RxSwift
import RxCocoa

protocol SyncManagerDelegate: class {
    func error(_ error: ErrorTypeAPI)
}

enum SyncTask {
    case fetch(task: APIUpdateTaskProtocol)
    case upload(task: APIUploadTaskProtocol)
}

class SyncManager {
    static let shared = SyncManager()

    private let logger: LoggerProtocol

    private init(logger: LoggerProtocol = Dependency.logger) {
        self.logger = logger
    }

    weak var delegate: SyncManagerDelegate?

    private var timer: Timer?

    private var loadingTask: URLSessionTask?
    private var disposeBag: DisposeBag? = DisposeBag()

    let userAPI = UserAPI()
    let budgetAPI = BudgetAPI()
    let expenseAPI = ExpenseAPI()
    let categoryAPI = CategoryAPI()
    let userGroupAPI = UserGroupAPI()
    let budgetLimitAPI = BudgetLimitAPI()

    var syncTasks = [SyncTask]()
    var tasks = [BaseAPITask]()

    func sync() {
        Dependency.logger.info("Load updates from server")

        disposeBag = DisposeBag()
        let restApiURLBuilder = Dependency.instance.restApiUrlBuilder(environment: Dependency.environment())
        let userAPIUpdateTask = UserAPIUpdateTask(restApiURLBuilder: restApiURLBuilder)
        let budgetAPIUpdateTask = BudgetAPIUpdateTask(restApiURLBuilder: restApiURLBuilder)
        let userGroupsAPIUpdateTask = UserGroupsAPIUpdateTask(restApiURLBuilder: restApiURLBuilder)
        
        let groups: [Budget] = ModelManager.sharedInstance.changedModels(managedObjectContext: ModelManager.managedObjectContext) ?? []
        syncTasks += groups.map { item -> SyncTask in
            .upload(task: GroupAPIUploadTask(restApiURLBuilder: restApiURLBuilder, json: item.uploadProperties()))
        }

        let userGroups: [UserGroup] = ModelManager.sharedInstance.changedModels(managedObjectContext: ModelManager.managedObjectContext) ?? []
        syncTasks += userGroups.map { item -> SyncTask in
            .upload(task: UserGroupsAPIUploadTask(restApiURLBuilder: restApiURLBuilder, json: item.uploadProperties()))
        }
        
        syncTasks.append(.fetch(task: userAPIUpdateTask))
        syncTasks.append(.fetch(task: budgetAPIUpdateTask))
        syncTasks.append(.fetch(task: userGroupsAPIUpdateTask))

        if let nextTask = syncTasks.first {
            handle(syncTask: nextTask)
        } else {
            scheduleNextUpdate()
        }
    }

    private func scheduleNextUpdate() {
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(10.0), repeats: false) { [weak self] _ in
            self?.run()
        }
    }

    private func handle(syncTask: SyncTask) {
        guard let disposeBag = disposeBag else {
            return
        }
        
        let errorHandler: ((ErrorTypeAPI) -> Void) = { [weak self] error in
            if error == .tokenExpired || error == .tokenNotValid {
                Dependency.logger.error("Token is expired")
                AuthorisationAPI.instance.getRefreshAccessToke(refreshToken: UserCredentials.instance.refreshToken).subscribe { event in
                    switch event {
                    case .success(let model):
                        UserCredentials.instance.accessToken = model.accessToken
                        UserCredentials.instance.refreshToken = model.refreshToken

                        self?.scheduleNextUpdate()
                    case .error:
                        self?.scheduleNextUpdate()
                    }
                }.disposed(by: disposeBag)
            } else {
                self?.scheduleNextUpdate()
            }
        }
        
        switch syncTask {
        case .fetch(let task):
            task.updates().subscribe { [weak self] event in
                switch event {
                case .success(let hasNext):
                    if self?.syncTasks.count ?? 0 > 0 {
                        self?.syncTasks.remove(at: 0)
                    }
                    
                    if hasNext {
                        self?.syncTasks.insert(syncTask, at: 0)
                    }

                    if let nextTask = self?.syncTasks.first {
                        self?.handle(syncTask: nextTask)
                    } else {
                        self?.scheduleNextUpdate()
                    }

                case .error(let error as ErrorTypeAPI):
                    errorHandler(error)

                case .error:
                    self?.scheduleNextUpdate()
                }
            }.disposed(by: disposeBag)
        case .upload(let task):
            task.upload().subscribe { [weak self] event in
                switch event {
                case .completed:
                    if self?.syncTasks.isEmpty == false {
                        self?.syncTasks.remove(at: 0)
                    }
                    if let nextTask = self?.syncTasks.first {
                        self?.handle(syncTask: nextTask)
                    } else {
                        self?.scheduleNextUpdate()
                    }
                case .error(let error as ErrorTypeAPI):
                    errorHandler(error)
                case .error:
                    self?.scheduleNextUpdate()
                }
            }.disposed(by: disposeBag)
        }
    }

    func loadUpdates(completion: APIResultBlock?) {
        Dependency.logger.info("Load updates from server")

        self.tasks.removeAll()
        var task: BaseAPITask

        let completionBlock: APIResultBlock = { [weak self] (data, error) -> Void in
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
    }

    func insertPaginationTask(_ task: BaseAPITask) {
        self.tasks.insert(task, at: 1)
    }

    func run() {
        if Dependency.environment() == .testing {
            return
        }

        self.stop()

        Dependency.logger.info("Start sync")
        sync()
    }

    func stop() {
        Dependency.logger.info("Stop sync")

        timer?.invalidate()
        disposeBag = nil
    }
}
