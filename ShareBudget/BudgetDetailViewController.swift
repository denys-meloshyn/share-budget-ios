//
//  BudgetDetailViewController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 02.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CorePlot
import CoreData
import XCGLogger

class BudgetDetailViewController: BaseViewController {
    @IBOutlet var monthLabel: UILabel?
    @IBOutlet var budgetLabel: UILabel?
    @IBOutlet var balanceLabel: UILabel?
    @IBOutlet var expenseLabel: UILabel?
    @IBOutlet var budgetButton: UIButton?
    @IBOutlet var expenseButton: UIButton?
    @IBOutlet var expenseCoverView: UIView?
    @IBOutlet var budgetContainerView: UIView?
    @IBOutlet var expenseContainerView: UIView?
    @IBOutlet var balanceContainerView: UIView?
    @IBOutlet var createExpenseButton: UIButton?
    @IBOutlet var chartView: CPTGraphHostingView?
    @IBOutlet var budgetDescriptionLabel: UILabel?
    @IBOutlet var balanceDescriptionLabel: UILabel?
    @IBOutlet var expenseDescriptionLabel: UILabel?
    @IBOutlet var createNewExpenseContainerView: UIView?
    @IBOutlet var constraintChartViewWidth: NSLayoutConstraint?
    @IBOutlet var constraintChartViewHeight: NSLayoutConstraint?
    
    var budgetID: NSManagedObjectID!
    private let managedObjectContext = ModelManager.managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let router = BudgetDetailRouter(with: self)
        let interactin = BudgetDetailInteraction(with: self.budgetID)
        let presenter = BudgetDetailPresenter(with: interactin, router: router)
        self.viperView = BudgetDetailView(with: presenter, and: self)
        
        self.linkStoryboardViews()
        self.viperView?.viewDidLoad()
    }
    
    private func linkStoryboardViews() {
        guard let view = self.viperView as? BudgetDetailView else {
            return
        }
        
        view.chartView = self.chartView
        view.monthLabel = self.monthLabel
        view.budgetLabel = self.budgetLabel
        view.balanceLabel = self.balanceLabel
        view.budgetButton = self.budgetButton
        view.expenseLabel = self.expenseLabel
        view.expenseButton = self.expenseButton
        view.expenseCoverView = self.expenseCoverView
        view.createExpenseButton = self.createExpenseButton
        view.budgetContainerView = self.budgetContainerView
        view.expenseContainerView = self.expenseContainerView
        view.balanceContainerView = self.balanceContainerView
        view.budgetDescriptionLabel = self.budgetDescriptionLabel
        view.balanceDescriptionLabel = self.balanceDescriptionLabel
        view.expenseDescriptionLabel = self.expenseDescriptionLabel
        view.constraintChartViewWidth = self.constraintChartViewWidth
        view.constraintChartViewHeight = self.constraintChartViewHeight
        view.createNewExpenseContainerView = self.createNewExpenseContainerView
    }
}
