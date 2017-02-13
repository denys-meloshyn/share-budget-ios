//
//  ExpensesViewController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData
import XCGLogger

class ExpensesViewController: UIViewController {
    var budgetID: NSManagedObjectID?
    private let managedObjectContext = ModelManager.managedObjectContext
    var fc: NSFetchedResultsController<Expense>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fc = ModelManager.expenseFetchController(self.managedObjectContext, for: self.budgetID!)
        
        do {
            try self.fc?.performFetch()
        }
        catch {
            
        }
    }
}

// MARK: - UITableViewDataSource

extension ExpensesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fc?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionModel = self.fc?.sections?[section]
        
        return sectionModel?.numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell")
        let expense = self.fc?.object(at: indexPath)
        cell?.textLabel?.text = expense?.name
        cell?.detailTextLabel?.text = String(expense?.price ?? 0)
        XCGLogger.info(expense?.budget)
        
        return cell!
    }
}
