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
    @IBOutlet private var monthLabel: UILabel?
    @IBOutlet private var minusLabel: UILabel?
    @IBOutlet private var equalLabel: UILabel?
    @IBOutlet private var budgetLabel: UILabel?
    @IBOutlet private var balanceLabel: UILabel?
    @IBOutlet private var expenseLabel: UILabel?
    @IBOutlet private var budgetButton: UIButton?
    @IBOutlet private var expenseButton: UIButton?
    @IBOutlet private var expenseCoverView: UIView?
    @IBOutlet private var budgetContainerView: UIView?
    @IBOutlet private var expenseContainerView: UIView?
    @IBOutlet private var balanceContainerView: UIView?
    @IBOutlet private var createExpenseButton: UIButton?
    @IBOutlet private var chartView: CPTGraphHostingView?
    @IBOutlet private var budgetDescriptionLabel: UILabel?
    @IBOutlet private var balanceDescriptionLabel: UILabel?
    @IBOutlet private var expenseDescriptionLabel: UILabel?
    @IBOutlet private var createNewExpenseContainerView: UIView?
    @IBOutlet private var constraintChartViewWidth: NSLayoutConstraint?
    @IBOutlet private var constraintChartViewHeight: NSLayoutConstraint?
    
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
        view.minusLabel = self.minusLabel
        view.equalLabel = self.equalLabel
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
