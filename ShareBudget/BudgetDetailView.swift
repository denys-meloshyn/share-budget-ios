//
//  BudgetDetailView.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 03.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CorePlot
import ChameleonFramework

class BudgetDetailView: BaseView {
    weak var monthLabel: UILabel?
    weak var minusLabel: UILabel?
    weak var equalLabel: UILabel?
    weak var budgetLabel: UILabel?
    weak var balanceLabel: UILabel?
    weak var expenseLabel: UILabel?
    weak var budgetButton: UIButton?
    weak var expenseButton: UIButton?
    weak var expenseCoverView: UIView?
    weak var budgetContainerView: UIView?
    weak var expenseContainerView: UIView?
    weak var balanceContainerView: UIView?
    weak var createExpenseButton: UIButton?
    weak var chartView: CPTGraphHostingView?
    weak var budgetDescriptionLabel: UILabel?
    weak var balanceDescriptionLabel: UILabel?
    weak var expenseDescriptionLabel: UILabel?
    weak var createNewExpenseContainerView: UIView?
    weak var constraintChartViewWidth: NSLayoutConstraint?
    weak var constraintChartViewHeight: NSLayoutConstraint?
    
    fileprivate var piePlot: CPTPieChart!
    fileprivate var pieGraph : CPTXYGraph?
    
    override init(with presenter: BasePresenter, and viewController: UIViewController) {
        super.init(with: presenter, and: viewController)
        
        self.budgetDetailPresenter.delegate = self
    }
    
    fileprivate var budgetDetailPresenter: BudgetDetailPresenter {
        get {
            return self.presenter as! BudgetDetailPresenter
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewController?.view.backgroundColor = Constants.defaultBackgroundColor
        self.expenseButton?.addTarget(self.budgetDetailPresenter, action: #selector(BudgetDetailPresenter.showAllExpenses), for: .touchUpInside)
        self.budgetButton?.addTarget(self.budgetDetailPresenter, action: #selector(BudgetDetailPresenter.changeBudgetLimit), for: .touchUpInside)
        self.createExpenseButton?.addTarget(self.budgetDetailPresenter, action: #selector(BudgetDetailPresenter.createNewExpense), for: .touchUpInside)
        
        self.configureBorder(for: self.budgetContainerView, color: .white)
        self.configureBorder(for: self.expenseContainerView, color: .white)
        self.configureBorder(for: self.balanceContainerView, color: .lightGray)
        
        self.configureChart()
    }
    
    private func configureBorder(for view: UIView?, color: UIColor? = UIColor.white) {
        view?.layer.borderWidth = 1.0
        view?.layer.cornerRadius = 5.0
        view?.layer.borderColor = color?.cgColor
    }
    
    private func configureChart() {
        // Create graph from theme
        self.pieGraph = CPTXYGraph(frame: .zero)
        self.pieGraph?.apply(CPTTheme(named: .plainWhiteTheme))
        self.pieGraph?.axisSet = nil
        self.pieGraph?.fill = CPTFill(color: CPTColor(cgColor: UIColor.clear.cgColor))
        self.pieGraph?.plotAreaFrame?.fill = CPTFill(color: CPTColor(cgColor: UIColor.clear.cgColor))
        self.pieGraph?.plotAreaFrame?.borderLineStyle = nil
        
        // Paddings
        self.pieGraph?.paddingTop = 0.0
        self.pieGraph?.paddingLeft = 0.0
        self.pieGraph?.paddingRight = 0.0
        self.pieGraph?.paddingBottom = 0.0
        
        self.chartView?.hostedGraph = self.pieGraph
        
        let width = self.chartView?.frame.width ?? 0.0
        let height = self.chartView?.frame.height ?? 0.0
        let radius = min(width, height) * 0.5
        let innerRadius = radius * 0.5
        
        // Add pie chart
        self.piePlot = CPTPieChart(frame: .zero)
        self.piePlot.pieRadius = radius
        self.piePlot.pieInnerRadius = innerRadius
        self.piePlot.identifier = NSString.init(string: "Pie Chart 1")
        self.piePlot.startAngle = CGFloat(M_PI_4)
        self.piePlot.sliceDirection = .clockwise
        self.piePlot.labelOffset = -60.0
        self.piePlot.labelRotationRelativeToRadius = true
        
        self.piePlot.delegate = self.budgetDetailPresenter
        self.piePlot.dataSource = self.budgetDetailPresenter
        
        self.pieGraph?.add(piePlot)
        
        self.configureChartFrame()
    }
    
    private func configureChartFrame() {
        let buttonSize = self.piePlot.pieInnerRadius * 0.8 * 2
        self.constraintChartViewWidth?.constant = buttonSize
        self.constraintChartViewHeight?.constant = buttonSize
        self.createNewExpenseContainerView?.layer.cornerRadius = buttonSize * 0.5
    }
    
    fileprivate func updateContrastColor(to color: UIColor) {
        let newColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
        
        self.configureBorder(for: self.budgetContainerView, color: newColor)
        self.configureBorder(for: self.expenseContainerView, color: newColor)
        self.configureBorder(for: self.balanceContainerView, color: UIColor.lightGray)
        
        self.minusLabel?.textColor = newColor
        self.equalLabel?.textColor = newColor
        self.monthLabel?.textColor = newColor
        self.budgetLabel?.textColor = newColor
        self.balanceLabel?.textColor = newColor
        self.expenseLabel?.textColor = newColor
        self.budgetDescriptionLabel?.textColor = newColor
        self.balanceDescriptionLabel?.textColor = newColor
        self.expenseDescriptionLabel?.textColor = newColor
    }
}

// MARK: - BudgetDetailPresenterDelegate

extension BudgetDetailView: BudgetDetailPresenterDelegate {
    func updateChart() {
        self.piePlot.reloadData()
    }
    
    func updateTotalExpense(_ total: String) {
        self.expenseLabel?.text = total
    }
    
    func updateMonthLimit(_ limit: String) {
        self.budgetLabel?.text = limit
    }
    
    func updateBalance(_ balance: String) {
        self.balanceLabel?.text = balance
    }
    
    func updateCurrentMonthDate(_ date: String) {
        self.monthLabel?.text = date
    }
    
    func updateExpenseCoverColor(_ color: UIColor?) {
        self.expenseCoverView?.backgroundColor = color
    }
    
    func showEditBudgetLimitView(with title: String, message: String, create: String, cancel: String, placeholder: String, budgetLimit: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let createAction = UIAlertAction(title: create, style: .default, handler:  self.budgetDetailPresenter.createHandler(with: alertController))
        
        let cancelAction = UIAlertAction(title: cancel, style: .cancel)
        
        alertController.addTextField { (textField) in
            textField.text = budgetLimit
            textField.keyboardType = .numbersAndPunctuation
            textField.placeholder = placeholder
            textField.autocapitalizationType = .none
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                guard let text = textField.text else {
                    return
                }
                
                createAction.isEnabled = Validator.isNumberValid(text)
            }
        }
        
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        
        self.viewController?.present(alertController, animated: true, completion: nil)
    }
}
