//
//  EditExpenseViewController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 05.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

class EditExpenseViewController: BaseViewController {
    @IBOutlet private var categoryButton: UIButton?
    @IBOutlet private var dateContainerView: UIView?
    @IBOutlet private var nameSeparatorLine: UIView?
    @IBOutlet private var dateTextField: UITextField?
    @IBOutlet private var nameTextField: UITextField?
    @IBOutlet private var priceTextField: UITextField?
    @IBOutlet private var categoryContainerView: UIView?
    
    var budgetID: NSManagedObjectID?
    var expenseID: NSManagedObjectID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let router = EditExpenseRouter(with: self)
        let interactin = EditExpenseInteraction(with: self.budgetID!, expenseID: self.expenseID)
        let presenter = EditExpensePresenter(with: interactin, router: router)
        self.viperView = EditExpenseView(with: presenter, and: self)
        
        self.linkStoryboardViews()
        self.viperView?.viewDidLoad()
    }
    
    override func linkStoryboardViews() {
        guard let view = self.viperView as? EditExpenseView else {
            return
        }
        
        view.dateTextField = self.dateTextField
        view.nameTextField = self.nameTextField
        view.categoryButton = self.categoryButton
        view.priceTextField = self.priceTextField
        view.nameSeparatorLine = self.nameSeparatorLine
        view.dateContainerView = self.dateContainerView
        view.categoryContainerView = self.categoryContainerView
    }
}
