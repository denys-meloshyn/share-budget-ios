//
//  BudgetDetailView.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 03.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CorePlot
import UIKit

protocol BudgetDetailViewProtocol: BaseViewProtocol {
    var monthLabel: UILabel? { get set }
    var minusLabel: UILabel? { get set }
    var equalLabel: UILabel? { get set }
    var budgetLabel: UILabel? { get set }
    var balanceLabel: UILabel? { get set }
    var expenseLabel: UILabel? { get set }
    var animationView: UIView? { get set }
    var navigationView: UIView? { get set }
    var expenseCoverView: UIView? { get set }
    var backButton: ButtonListener? { get set }
    var budgetContainerView: UIView? { get set }
    var expenseContainerView: UIView? { get set }
    var balanceContainerView: UIView? { get set }
    var budgetButton: ButtonListener? { get set }
    var expenseButton: ButtonListener? { get set }
    var navigationTitleLabel: UILabel? { get set }
    var chartView: CPTGraphHostingView? { get set }
    var safeAreaPlaceholderView: UIView? { get set }
    var budgetDescriptionLabel: UILabel? { get set }
    var editMemberButton: ButtonListener? { get set }
    var balanceDescriptionLabel: UILabel? { get set }
    var expenseDescriptionLabel: UILabel? { get set }
    var createExpenseButton: ButtonListener? { get set }
    var createNewExpenseContainerView: UIView? { get set }
    var constraintChartViewWidth: NSLayoutConstraint? { get set }
    var constraintChartViewHeight: NSLayoutConstraint? { get set }
    var constraintAnimationViewWidth: NSLayoutConstraint? { get set }
    var constraintAnimationViewHeight: NSLayoutConstraint? { get set }
}

class BudgetDetailView<T: BudgetDetailPresenterProtocol>: BaseView<T>, BudgetDetailViewProtocol {
    weak var monthLabel: UILabel?
    weak var minusLabel: UILabel?
    weak var equalLabel: UILabel?
    weak var budgetLabel: UILabel?
    weak var balanceLabel: UILabel?
    weak var expenseLabel: UILabel?
    weak var animationView: UIView?
    weak var navigationView: UIView?
    weak var expenseCoverView: UIView?
    weak var backButton: ButtonListener?
    weak var budgetContainerView: UIView?
    weak var expenseContainerView: UIView?
    weak var balanceContainerView: UIView?
    weak var budgetButton: ButtonListener?
    weak var expenseButton: ButtonListener?
    weak var navigationTitleLabel: UILabel?
    weak var chartView: CPTGraphHostingView?
    weak var safeAreaPlaceholderView: UIView?
    weak var budgetDescriptionLabel: UILabel?
    weak var balanceDescriptionLabel: UILabel?
    weak var expenseDescriptionLabel: UILabel?
    weak var editMemberButton: ButtonListener?
    weak var createExpenseButton: ButtonListener?
    weak var createNewExpenseContainerView: UIView?
    weak var constraintChartViewWidth: NSLayoutConstraint?
    weak var constraintChartViewHeight: NSLayoutConstraint?
    weak var constraintAnimationViewWidth: NSLayoutConstraint?
    weak var constraintAnimationViewHeight: NSLayoutConstraint?

    fileprivate var piePlot: CPTPieChart!
    fileprivate var pieGraph: CPTXYGraph?

    override init(with presenter: T, and viewController: UIViewController) {
        super.init(with: presenter, and: viewController)

        presenter.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        editMemberButton?.tintColor = Constants.color.dflt.actionColor
        animationView?.backgroundColor = Constants.color.dflt.actionColor
        viewController?.view.backgroundColor = Constants.color.dflt.backgroundColor
        createNewExpenseContainerView?.backgroundColor = Constants.color.dflt.actionColor

        backButton?.addTouchUpInsideListener(completion: { _ in
            self.presenter.closePageAction()
        })

        editMemberButton?.addTouchUpInsideListener(completion: { _ in
            self.presenter.editMembers()
        })

        expenseButton?.addTouchUpInsideListener(completion: { _ in
            self.presenter.showAllExpenses()
        })

        budgetButton?.addTouchUpInsideListener(completion: { _ in
            self.presenter.changeBudgetLimit()
        })

        createExpenseButton?.addTouchUpInsideListener(completion: { _ in
            self.presenter.createNewExpense()
        })

        backButton?.addTouchUpInsideListener(completion: { _ in
            self.presenter.closePageAction()
        })

        configureBorder(for: budgetContainerView, color: Constants.color.dflt.actionColor)
        configureBorder(for: expenseContainerView, color: Constants.color.dflt.actionColor)
        configureBorder(for: balanceContainerView, color: UIColor(white: 1.0, alpha: 0.5))

        configureChart()
    }

    override func showPage(title: String?) {
        navigationTitleLabel?.text = title
    }

    private func configureBorder(for view: UIView?, color: UIColor? = UIColor.white) {
        view?.layer.borderWidth = 1.0
        view?.layer.cornerRadius = 5.0
        view?.layer.borderColor = color?.cgColor
    }

    private func configureChart() {
        // Create graph from theme
        pieGraph = CPTXYGraph(frame: .zero)
        pieGraph?.apply(CPTTheme(named: .plainWhiteTheme))
        pieGraph?.axisSet = nil
        pieGraph?.fill = CPTFill(color: CPTColor(cgColor: UIColor.clear.cgColor))
        pieGraph?.plotAreaFrame?.fill = CPTFill(color: CPTColor(cgColor: UIColor.clear.cgColor))
        pieGraph?.plotAreaFrame?.borderLineStyle = nil

        // Paddings
        pieGraph?.paddingTop = 0.0
        pieGraph?.paddingLeft = 0.0
        pieGraph?.paddingRight = 0.0
        pieGraph?.paddingBottom = 0.0

        chartView?.hostedGraph = pieGraph

        chartView?.layoutIfNeeded()
        let width = chartView?.frame.width ?? 0.0
        let height = chartView?.frame.height ?? 0.0
        let radius = min(width, height) * 0.5
        let innerRadius = radius * 0.5

        // Add pie chart
        piePlot = CPTPieChart(frame: .zero)
        piePlot.pieRadius = radius
        piePlot.pieInnerRadius = innerRadius
        piePlot.identifier = NSString(string: "Pie Chart 1")
        piePlot.startAngle = CGFloat(Double.pi / 4)
        piePlot.sliceDirection = .clockwise
        piePlot.labelOffset = -60.0
        piePlot.labelRotationRelativeToRadius = true

        piePlot.delegate = presenter
        piePlot.dataSource = presenter

        pieGraph?.add(piePlot)

        configureChartFrame()
    }

    private func configureChartFrame() {
        let buttonSize = piePlot.pieInnerRadius * 0.8 * 2
        constraintChartViewWidth?.constant = buttonSize
        constraintChartViewHeight?.constant = buttonSize
        createNewExpenseContainerView?.layer.cornerRadius = buttonSize * 0.5

        constraintAnimationViewWidth?.constant = (constraintChartViewWidth?.constant ?? 0.0)
        constraintAnimationViewHeight?.constant = (constraintChartViewHeight?.constant ?? 0.0)
        animationView?.layer.cornerRadius = (constraintAnimationViewWidth?.constant ?? 0.0) / 2.0
        viewController?.view.layoutIfNeeded()
    }

    fileprivate func stopAnimation() {
        animationView?.layer.removeAllAnimations()
    }

    fileprivate func startAnimation() {
        stopAnimation()

        UIView.animate(withDuration: 5.0, animations: { [weak self] in
            self?.animationView?.alpha = 0.0
            self?.animationView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { [weak self] finished in
            if finished {
                self?.animationView?.alpha = 1.0
                self?.animationView?.transform = .identity

                self?.startAnimation()
            }
        })
    }

    fileprivate func updateContrastColor(to color: UIColor) {
        let newColor = color

        configureBorder(for: budgetContainerView, color: newColor)
        configureBorder(for: expenseContainerView, color: newColor)
        configureBorder(for: balanceContainerView, color: UIColor.lightGray)

        minusLabel?.textColor = newColor
        equalLabel?.textColor = newColor
        monthLabel?.textColor = newColor
        budgetLabel?.textColor = newColor
        balanceLabel?.textColor = newColor
        expenseLabel?.textColor = newColor
        budgetDescriptionLabel?.textColor = newColor
        balanceDescriptionLabel?.textColor = newColor
        expenseDescriptionLabel?.textColor = newColor
    }
}

// MARK: - BudgetDetailPresenterDelegate

extension BudgetDetailView: BudgetDetailPresenterDelegate {
    func updateNativeNavigationVisibility(_ isVisible: Bool) {
        if isVisible {
            viewController?.navigationController?.setNavigationBarHidden(false, animated: true)
        } else {
            viewController?.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }

    func updateCreateButtonAnimation(_ isActive: Bool) {
        if isActive {
            startAnimation()
        } else {
            stopAnimation()
        }
    }

    func updateChart() {
        piePlot.reloadData()
    }

    func updateTotalExpense(_ total: String) {
        expenseLabel?.text = total
    }

    func updateMonthLimit(_ limit: String) {
        budgetLabel?.text = limit
    }

    func updateBalance(_ balance: String) {
        balanceLabel?.text = balance
    }

    func updateCurrentMonthDate(_ date: String) {
        monthLabel?.text = date
    }

    func updateExpenseCoverColor(_ color: UIColor?) {
        navigationView?.backgroundColor = color
        expenseCoverView?.backgroundColor = color
        safeAreaPlaceholderView?.backgroundColor = color
    }

    func showEditBudgetLimitView(with title: String, message: String, create: String, cancel: String, placeholder: String, budgetLimit: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let createAction = UIAlertAction(title: create, style: .default, handler: presenter.createHandler(with: alertController))

        let cancelAction = UIAlertAction(title: cancel, style: .cancel)

        alertController.addTextField { textField in
            textField.text = budgetLimit
            textField.keyboardType = .decimalPad
            textField.placeholder = placeholder
            textField.autocapitalizationType = .none

            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { _ in
                guard let text = textField.text else {
                    return
                }

                if UtilityFormatter.priceEditFormatter.number(from: text) != nil {
                    createAction.isEnabled = true
                } else {
                    createAction.isEnabled = false
                }
            }
        }

        alertController.addAction(createAction)
        alertController.addAction(cancelAction)

        viewController?.present(alertController, animated: true, completion: nil)
    }
}
