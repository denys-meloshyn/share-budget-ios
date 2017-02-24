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
    weak var expenseButton: UIButton? {
        didSet {
            self.expenseButton?.addTarget(self.budgetDetailPresenter, action: #selector(BudgetDetailPresenter.showAllExpenses), for: .touchUpInside)
        }
    }
    weak var budgetContainerView: UIView? {
        didSet {
            self.configureBorder(for: self.budgetContainerView)
        }
    }
    weak var expenseContainerView: UIView? {
        didSet {
            self.configureBorder(for: self.expenseContainerView)
        }
    }
    weak var createExpenseButton: UIButton? {
        didSet {
            self.createExpenseButton?.addTarget(self.budgetDetailPresenter, action: #selector(BudgetDetailPresenter.createNewExpense), for: .touchUpInside)
        }
    }
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
        
        
    }
    
    private func configureBorder(for view: UIView?) {
        view?.layer.borderWidth = 1.0
        view?.layer.cornerRadius = 5.0
        view?.layer.borderColor = UIColor.white.cgColor
    }
    
    private func configureChart() {
        // Create graph from theme
        let newGraph = CPTXYGraph(frame: .zero)
        newGraph.fill = CPTFill(color: CPTColor.clear())
        newGraph.apply(CPTTheme(named: .plainWhiteTheme))
        newGraph.borderLineStyle = nil
        newGraph.plotAreaFrame?.borderLineStyle = nil
        
        self.chartView?.hostedGraph = newGraph
        
        // Paddings
        newGraph.paddingLeft   = 0.0
        newGraph.paddingRight  = 0.0
        newGraph.paddingTop    = 0.0
        newGraph.paddingBottom = 0.0
        
        newGraph.axisSet = nil
        
        
        let width = self.chartView?.frame.width ?? 0.0
        let height = self.chartView?.frame.height ?? 0.0
        let radius = min(width, height) * 0.4
        let innerRadius = radius * 0.4
        
        // Add pie chart
        self.piePlot = CPTPieChart(frame: .zero)
        self.piePlot.plotArea?.borderLineStyle = nil
        self.piePlot.borderLineStyle = nil
        self.piePlot.pieRadius = radius
        self.piePlot.pieInnerRadius = innerRadius
        self.piePlot.identifier = NSString.init(string: "Pie Chart 1")
        self.piePlot.startAngle = CGFloat(M_PI_4)
        self.piePlot.sliceDirection = .counterClockwise
        
        piePlot.delegate = self.budgetDetailPresenter
        piePlot.dataSource = self.budgetDetailPresenter
        
        newGraph.add(piePlot)
        
        self.pieGraph = newGraph
        
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
