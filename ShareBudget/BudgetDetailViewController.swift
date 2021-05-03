//
//  BudgetDetailViewController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 02.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData
import CorePlot
import UIKit

class BudgetDetailViewController: BaseViewController {
    @IBOutlet private var monthLabel: UILabel?
    @IBOutlet private var minusLabel: UILabel?
    @IBOutlet private var equalLabel: UILabel?
    @IBOutlet private var backButton: ButtonListener?
    @IBOutlet private var budgetLabel: UILabel?
    @IBOutlet private var balanceLabel: UILabel?
    @IBOutlet private var expenseLabel: UILabel?
    @IBOutlet private var animationView: UIView?
    @IBOutlet private var budgetButton: ButtonListener?
    @IBOutlet private var navigationView: UIView?
    @IBOutlet private var expenseButton: ButtonListener?
    @IBOutlet private var expenseCoverView: UIView?
    @IBOutlet private var editMemberButton: ButtonListener?
    @IBOutlet private var budgetContainerView: UIView?
    @IBOutlet private var expenseContainerView: UIView?
    @IBOutlet private var balanceContainerView: UIView?
    @IBOutlet private var navigationTitleLabel: UILabel?
    @IBOutlet private var createExpenseButton: ButtonListener?
    @IBOutlet private var chartView: CPTGraphHostingView?
    @IBOutlet private var budgetDescriptionLabel: UILabel?
    @IBOutlet private var safeAreaPlaceholderView: UIView?
    @IBOutlet private var balanceDescriptionLabel: UILabel?
    @IBOutlet private var expenseDescriptionLabel: UILabel?
    @IBOutlet private var createNewExpenseContainerView: UIView?
    @IBOutlet private var constraintChartViewWidth: NSLayoutConstraint?
    @IBOutlet private var constraintChartViewHeight: NSLayoutConstraint?
    @IBOutlet private var constraintAnimationViewWidth: NSLayoutConstraint?
    @IBOutlet private var constraintAnimationViewHeight: NSLayoutConstraint?

    var budgetID: NSManagedObjectID!

    override func viewDidLoad() {
        super.viewDidLoad()

        let router = BudgetDetailRouter(with: self)
        let interaction = BudgetDetailInteraction(with: budgetID, managedObjectContext: ModelManager.managedObjectContext)
        let presenter = BudgetDetailPresenter(with: interaction, router: router)
        viperView = BudgetDetailView(with: presenter, and: self)

        linkStoryboardViews()
        viperView?.viewDidLoad()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func linkStoryboardViews() {
        guard let view = viperView as? BudgetDetailViewProtocol else {
            return
        }

        view.chartView = chartView
        view.minusLabel = minusLabel
        view.equalLabel = equalLabel
        view.monthLabel = monthLabel
        view.backButton = backButton
        view.budgetLabel = budgetLabel
        view.balanceLabel = balanceLabel
        view.budgetButton = budgetButton
        view.expenseLabel = expenseLabel
        view.expenseButton = expenseButton
        view.animationView = animationView
        view.navigationView = navigationView
        view.editMemberButton = editMemberButton
        view.expenseCoverView = expenseCoverView
        view.createExpenseButton = createExpenseButton
        view.budgetContainerView = budgetContainerView
        view.expenseContainerView = expenseContainerView
        view.balanceContainerView = balanceContainerView
        view.navigationTitleLabel = navigationTitleLabel
        view.budgetDescriptionLabel = budgetDescriptionLabel
        view.balanceDescriptionLabel = balanceDescriptionLabel
        view.expenseDescriptionLabel = expenseDescriptionLabel
        view.safeAreaPlaceholderView = safeAreaPlaceholderView
        view.constraintChartViewWidth = constraintChartViewWidth
        view.constraintChartViewHeight = constraintChartViewHeight
        view.constraintAnimationViewWidth = constraintAnimationViewWidth
        view.constraintAnimationViewHeight = constraintAnimationViewHeight
        view.createNewExpenseContainerView = createNewExpenseContainerView
    }
}
