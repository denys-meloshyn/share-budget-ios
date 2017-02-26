//
//  BudgetDetailView.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 03.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CorePlot

class BudgetDetailView: BaseView {
    weak var monthLabel: UILabel?
    weak var budgetLabel: UILabel?
    weak var balanceLabel: UILabel?
    weak var expenseLabel: UILabel?
    weak var expenseButton: UIButton?
    weak var budgetContainerView: UIView?
    weak var expenseContainerView: UIView?
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
        
        self.configureBorder(for: self.budgetContainerView)
        self.configureBorder(for: self.expenseContainerView)
        self.expenseButton?.addTarget(self.budgetDetailPresenter, action: #selector(BudgetDetailPresenter.showAllExpenses), for: .touchUpInside)
        self.createExpenseButton?.addTarget(self.budgetDetailPresenter, action: #selector(BudgetDetailPresenter.createNewExpense), for: .touchUpInside)
        
        self.configureChart()
    }
    
    private func configureBorder(for view: UIView?) {
        view?.layer.borderWidth = 1.0
        view?.layer.cornerRadius = 5.0
        view?.layer.borderColor = UIColor.white.cgColor
    }
    
    private func configureChart() {
        // Create graph from theme
        self.pieGraph = CPTXYGraph(frame: .zero)
        self.pieGraph?.apply(CPTTheme(named: .plainWhiteTheme))
        self.pieGraph?.axisSet = nil
        self.pieGraph?.plotAreaFrame?.borderLineStyle = nil
        
        // Paddings
        self.pieGraph?.paddingTop = 0.0
        self.pieGraph?.paddingLeft = 0.0
        self.pieGraph?.paddingRight = 0.0
        self.pieGraph?.paddingBottom = 0.0
        
        self.chartView?.hostedGraph = self.pieGraph
        
        let width = self.chartView?.frame.width ?? 0.0
        let height = self.chartView?.frame.height ?? 0.0
        let radius = min(width, height) * 0.4
        let innerRadius = radius * 0.4
        
        // Add pie chart
        self.piePlot = CPTPieChart(frame: .zero)
        self.piePlot.pieRadius = radius
        self.piePlot.pieInnerRadius = innerRadius
        self.piePlot.identifier = NSString.init(string: "Pie Chart 1")
        self.piePlot.startAngle = CGFloat(M_PI_4)
        self.piePlot.sliceDirection = .clockwise
        
        self.piePlot.delegate = self.budgetDetailPresenter
        self.piePlot.dataSource = self.budgetDetailPresenter
        
        self.pieGraph?.add(piePlot)
        
        self.configureChartFrame()
    }
    
    private func configureChartFrame() {
        let buttonSize = self.piePlot.pieInnerRadius * 0.9 * 2
        self.constraintChartViewWidth?.constant = buttonSize
        self.constraintChartViewHeight?.constant = buttonSize
        self.createNewExpenseContainerView?.layer.cornerRadius = buttonSize / 2.0
    }
}

extension BudgetDetailView: BudgetDetailPresenterDelegate {
    func updateTotalExpense(_ total: String) {
        self.expenseLabel?.text = total
    }
    
    func updateMonthLimit(_ limit: String) {
        self.budgetLabel?.text = limit
    }
    
    func updateBalance(_ balance: String) {
        self.balanceLabel?.text = balance
    }
}
