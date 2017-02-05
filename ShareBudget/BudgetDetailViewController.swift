//
//  BudgetDetailViewController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 02.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData
import XCGLogger

class BudgetDetailViewController: BaseViewController {
    var budgetID: NSManagedObjectID?
    private let managedObjectContext = ModelManager.managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let router = BudgetDetailRouter(with: self)
        let interactin = BudgetDetailInteraction()
        let presenter = BudgetDetailPresenter(with: interactin, router: router)
        self.viperView = BudgetDetailView(with: presenter, and: self)
        
        if let budgetID = self.budgetID {
            let fc = ModelManager.budgetLimitFetchController(managedObjectContext, for: budgetID)
            
            do {
                try fc.performFetch()
                guard let sections = fc.sections else {
                    return
                }
                
                for i in 0..<sections.count {
                    let section = sections[i]
                    for j in 0..<section.numberOfObjects {
                        let indexPath = IndexPath(row: i, section: j)
                        let limit = fc.object(at: indexPath)
                        XCGLogger.info("\(limit.limit), \(limit.date)")
                    }
                }
            }
            catch {
                
            }
        }
    }
}
