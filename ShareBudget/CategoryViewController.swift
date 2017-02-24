//
//  CategoryViewController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 06.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData
import XCGLogger

protocol CategoryViewControllerDelegate: class {
    func didSelectCategory(_ categoryID: NSManagedObjectID)
}

class CategoryViewController: UIViewController {
    var expenseID: NSManagedObjectID?
    var fc: NSFetchedResultsController<Category>?
    var managedObjectContext: NSManagedObjectContext?
    weak var delegate: CategoryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let expense = self.managedObjectContext?.object(with: self.expenseID!) as? Expense
        
        fc = ModelManager.categoryFetchController(self.managedObjectContext!, for: expense!.budget!.objectID)
        
        do {
            try fc?.performFetch()
        }
        catch {
            
        }
    }
}

// MARK: - UITableViewDataSource

extension CategoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fc?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionModel = fc?.sections?[section]
        
        return sectionModel?.numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = fc?.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell")
        cell?.textLabel?.text = model?.name
        
        XCGLogger.info(model)
        
        return cell!
    }
}

// MARK: - UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = self.fc?.object(at: indexPath)
        self.delegate?.didSelectCategory(category!.objectID)
        _ = self.navigationController?.popViewController(animated: true)
    }
}
