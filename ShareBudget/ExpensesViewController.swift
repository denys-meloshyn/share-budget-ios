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

class ExpensesViewController: UIViewController, NSFetchedResultsControllerDelegate {
    var budgetID: NSManagedObjectID?
    var categoryID: NSManagedObjectID?
    private let managedObjectContext = ModelManager.managedObjectContext
    var fc: NSFetchedResultsController<Expense>?
    var calculator: ExpenseCalculator?
    private var category: Category?
    @IBOutlet var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.estimatedRowHeight = 80.0
        self.tableView?.sectionHeaderHeight = 40.0
        self.tableView?.register(R.nib.expenseTableViewHeader(), forHeaderFooterViewReuseIdentifier: "ExpenseTableViewHeader")
        
        if let categoryID = self.categoryID {
            self.category = self.managedObjectContext.object(with: categoryID) as? Category
        }
        
        self.fc = ModelManager.expenseFetchController(self.managedObjectContext, for: self.budgetID!, categoryID: category?.objectID)
        self.fc?.delegate = self
        self.calculator = ExpenseCalculator(fetchedResultsController: self.fc!)
        
        do {
            try self.fc?.performFetch()
        }
        catch {
            
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView?.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell") as? ExpenseTableViewCell
        let expense = self.fc?.object(at: indexPath)
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        
        cell?.titleLabel?.text = expense?.name
        cell?.priceLabel?.text = formatter.string(from: expense?.price as NSNumber? ?? 0)
        cell?.categoryLabel?.text = expense?.category?.name
        
        if let date = expense?.creationDate as Date? {
            cell?.dateLabel?.text = UtilityFormatter.expenseFormatter.string(for: date)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ExpenseTableViewHeader") as? ExpenseTableViewHeader
        
        let sectionModel = self.fc?.sections?[section]
        var expense: Expense?
        if sectionModel?.numberOfObjects ?? 0 > 0 {
            expense = self.fc?.object(at: IndexPath(row: 0, section: section))
        }
        let creationDate = expense?.creationDate ?? NSDate()
        
        headerView?.monthLabel?.text = UtilityFormatter.yearMonthFormatter.string(from: creationDate as Date)
        
        headerView?.monthExpensesLabel?.text = String(self.calculator?.totalExpense(for: section) ?? 0.0)
        
        return headerView
    }
}

// MARK: - UITableViewDelegate

extension ExpensesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let viewController = R.storyboard.main.editExpenseViewController() {
            let expense = self.fc?.object(at: indexPath)
            
            viewController.budgetID = self.budgetID
            viewController.expenseID = expense?.objectID
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
