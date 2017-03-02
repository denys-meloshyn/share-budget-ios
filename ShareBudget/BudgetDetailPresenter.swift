//
//  BudgetDetailPresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 03.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CorePlot

protocol BudgetDetailPresenterDelegate: BasePresenterDelegate {
    func updateBalance(_ balance: String)
    func updateMonthLimit(_ limit: String)
    func updateTotalExpense(_ total: String)
}

class BudgetDetailPresenter: BasePresenter {
    weak var delegate: BudgetDetailPresenterDelegate?
    
    fileprivate var budgetDetailInteraction: BudgetDetailInteraction {
        get {
            return self.interaction as! BudgetDetailInteraction
        }
    }
    
    private var budgetDetailRouter: BudgetDetailRouter {
        get {
            return self.router as! BudgetDetailRouter
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate?.showPage(title: self.budgetDetailInteraction.budget.name)
        
        self.configureTotalExpenses()
        self.configureMonthBudget()
        self.configureBalance()
    }
    
    private func configureTotalExpenses() {
        let total = self.budgetDetailInteraction.totalExpenses()
        self.delegate?.updateTotalExpense(String(total))
    }
    
    private func configureMonthBudget() {
        let month = self.budgetDetailInteraction.lastMonthLimit()
        self.delegate?.updateMonthLimit(String(month?.limit ?? 0.0))
    }
    
    private func configureBalance() {
        self.delegate?.updateBalance(String(self.budgetDetailInteraction.balance()))
    }
    
    func createNewExpense() {
        self.budgetDetailRouter.openEditExpensePage(with: self.budgetDetailInteraction.budgetID)
    }
    
    func showAllExpenses() {
        self.budgetDetailRouter.showAllExpensesPage(with: self.budgetDetailInteraction.budgetID)
    }
}

// MARK: - CPTPieChartDataSource

extension BudgetDetailPresenter: CPTPieChartDataSource {
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        if self.budgetDetailInteraction.isEmpty() {
            return 1
        }
        
        return UInt(self.budgetDetailInteraction.numberOfCategoryExpenses())
    }
    
    func number(for plot: CPTPlot, field: UInt, record: UInt) -> Any? {
        if self.budgetDetailInteraction.isEmpty() {
            return 1 as NSNumber
        }
        
        switch CPTPieChartField(rawValue: Int(field))! {
        case .sliceWidth:
            return NSNumber(value: self.budgetDetailInteraction.totalExpenses(for: Int(record)))
            
        default:
            return record as NSNumber
        }
    }
    
    func dataLabel(for plot: CPTPlot, record: UInt) -> CPTLayer? {
        if self.budgetDetailInteraction.isEmpty() {
            return nil
        }
        
        let label = CPTTextLayer(text:self.budgetDetailInteraction.categoryTitle(for: Int(record)))
        
        if let textStyle = label.textStyle?.mutableCopy() as? CPTMutableTextStyle {
            textStyle.color = .lightGray()
            
            label.textStyle = textStyle
        }
        
        return label
    }
    
    func sliceFill(for pieChart: CPTPieChart, record idx: UInt) -> CPTFill? {
        if self.budgetDetailInteraction.isEmpty() {
            return CPTFill(color: CPTColor.gray())
        }
        
        return nil
    }
}

// MARK: - CPTPieChartDelegate

extension BudgetDetailPresenter: CPTPieChartDelegate {
    func pieChart(_ plot: CPTPieChart, sliceTouchDownAtRecord idx: UInt) {
        
    }
}
