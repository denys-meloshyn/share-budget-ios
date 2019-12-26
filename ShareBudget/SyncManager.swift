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
    private var disposeBag = DisposeBag()

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
        
        // New or changed groups
        let groups: [Budget] = ModelManager.sharedInstance.changedModels(managedObjectContext: ModelManager.managedObjectContext) ?? []
        syncTasks += groups.map { item -> SyncTask in
            .upload(task: GroupAPIUploadTask(restApiURLBuilder: restApiURLBuilder, modelID: item.objectID))
        }
        
        // New or changed group limits
        let groupLimits: [BudgetLimit] = ModelManager.sharedInstance.changedModels(managedObjectContext: ModelManager.managedObjectContext) ?? []
        syncTasks += groupLimits.map { item -> SyncTask in
            .upload(task: GroupLimitAPIUploadTask(restApiURLBuilder: restApiURLBuilder, modelID: item.objectID))
        }

        // New or changed user groups
        let userGroups: [UserGroup] = ModelManager.sharedInstance.changedModels(managedObjectContext: ModelManager.managedObjectContext) ?? []
        syncTasks += userGroups.map { item -> SyncTask in
            .upload(task: UserGroupsAPIUploadTask(restApiURLBuilder: restApiURLBuilder, modelID: item.objectID))
        }
        
        // New or changed user groups
        let categories: [Category] = ModelManager.sharedInstance.changedModels(managedObjectContext: ModelManager.managedObjectContext) ?? []
        syncTasks += categories.map { item -> SyncTask in
            .upload(task: CategoryAPIUploadTask(restApiURLBuilder: restApiURLBuilder, modelID: item.objectID))
        }
        
        // New or changed expenses
        let expenses: [Expense] = ModelManager.sharedInstance.changedModels(managedObjectContext: ModelManager.managedObjectContext) ?? []
        syncTasks += expenses.map { item -> SyncTask in
            .upload(task: ExpenseAPIUploadTask(restApiURLBuilder: restApiURLBuilder, modelID: item.objectID))
        }

        syncTasks.append(.fetch(task: UserAPIUpdateTask(restApiURLBuilder: restApiURLBuilder)))
        syncTasks.append(.fetch(task: BudgetAPIUpdateTask(restApiURLBuilder: restApiURLBuilder)))
        syncTasks.append(.fetch(task: UserGroupsAPIUpdateTask(restApiURLBuilder: restApiURLBuilder)))
        syncTasks.append(.fetch(task: BudgetLimitAPIUpdateTask(restApiURLBuilder: restApiURLBuilder)))
        syncTasks.append(.fetch(task: CategoryAPIUpdateTask(restApiURLBuilder: restApiURLBuilder)))
        syncTasks.append(.fetch(task: ExpenseAPIUpdateTask(restApiURLBuilder: restApiURLBuilder)))

        if let nextTask = syncTasks.first {
            handle(syncTask: nextTask)
        } else {
            scheduleNextUpdate()
        }
    }

    private func scheduleNextUpdate() {
        Observable.just(0).delay(.seconds(10), scheduler: MainScheduler.instance).subscribe { [weak self] _ in
            self?.run()
        }.disposed(by: disposeBag)
    }

    private func handle(syncTask: SyncTask) {
        let errorHandler: ((ErrorTypeAPI) -> Void) = { [weak self] error in
            if error == .tokenExpired || error == .tokenNotValid {
                guard let disposeBag = self?.disposeBag else {
                    return
                }
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
        syncTasks.removeAll()
        disposeBag = DisposeBag()
    }
}
