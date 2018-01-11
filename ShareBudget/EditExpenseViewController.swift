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
        let interactin = EditExpenseInteraction(with: budgetID!, expenseID: expenseID)
        let presenter = EditExpensePresenter(with: interactin, router: router)
        viperView = EditExpenseView(with: presenter, and: self)
        
        linkStoryboardViews()
        viperView?.viewDidLoad()
    }
    
    override func linkStoryboardViews() {
        guard let view = viperView as? EditExpenseViewProtocol else {
            return
        }
        
        view.dateTextField = dateTextField
        view.nameTextField = nameTextField
        view.categoryButton = categoryButton
        view.priceTextField = priceTextField
        view.nameSeparatorLine = nameSeparatorLine
        view.dateContainerView = dateContainerView
        view.categoryContainerView = categoryContainerView
    }
}
