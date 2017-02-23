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
    weak var budgetDescriptionLabel: UILabel?
    weak var balanceDescriptionLabel: UILabel?
    weak var expenseDescriptionLabel: UILabel?
    weak var chartView: CPTGraphHostingView? {
        didSet {
            self.configureChart()
        }
    }
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
        
        self.chartView?.hostedGraph = newGraph
        
        // Paddings
        newGraph.paddingLeft   = 0.0
        newGraph.paddingRight  = 0.0
        newGraph.paddingTop    = 0.0
        newGraph.paddingBottom = 0.0
        
        newGraph.axisSet = nil
        
        let whiteText = CPTMutableTextStyle()
        whiteText.color = .white()
        
//        newGraph.titleTextStyle = whiteText
//        newGraph.title          = "Graph Title"
        
        let width = self.chartView?.frame.width ?? 0.0
        let radius = width / 2.0
        let innerRadius = radius * 0.3
        
        // Add pie chart
        let piePlot = CPTPieChart(frame: .zero)
        piePlot.plotArea?.borderLineStyle = nil
        piePlot.dataSource = self
        piePlot.pieRadius = radius
        piePlot.pieInnerRadius = innerRadius
        piePlot.identifier = NSString.init(string: "Pie Chart 1")
        piePlot.startAngle = CGFloat(M_PI_4)
        piePlot.sliceDirection = .counterClockwise
//        piePlot.centerAnchor = CGPoint(x: 0.5, y: 0.38)
        piePlot.borderLineStyle = CPTLineStyle()
        piePlot.delegate = self
        newGraph.add(piePlot)
        
        self.pieGraph = newGraph
    }
}

// MARK: - Plot Data Source Methods

extension BudgetDetailView: CPTPieChartDataSource {
    func numberOfRecords(for plot: CPTPlot) -> UInt
    {
        return 10
    }
    
    func number(for plot: CPTPlot, field: UInt, record: UInt) -> Any?
    {
        return record + 1 as NSNumber
//        if Int(record) > 10 {
//            return nil
//        }
//        else {
//            switch CPTPieChartField(rawValue: Int(field))! {
//            case .sliceWidth:
//                return NSNumber(value: record)
//                
//            default:
//                return record as NSNumber
//            }
//        }
    }
    
    func dataLabel(for plot: CPTPlot, record: UInt) -> CPTLayer?
    {
        let label = CPTTextLayer(text:"\(record)")
        
        if let textStyle = label.textStyle?.mutableCopy() as? CPTMutableTextStyle {
            textStyle.color = .lightGray()
            
            label.textStyle = textStyle
        }
        
        return label
    }
    
//    func radialOffset(for piePlot: CPTPieChart, record recordIndex: UInt) -> CGFloat
//    {
//        var offset: CGFloat = 0.0
//        
//        if ( recordIndex == 0 ) {
//            offset = piePlot.pieRadius / 8.0
//        }
//        
//        return offset
//    }
}

// MARK: - Delegate Methods

extension BudgetDetailView: CPTPieChartDelegate {
    func pieChart(_ plot: CPTPieChart, sliceTouchDownAtRecord idx: UInt) {
        
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
