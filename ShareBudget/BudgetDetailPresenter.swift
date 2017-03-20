//
//  BudgetDetailPresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 03.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CorePlot
import ChameleonFramework

protocol BudgetDetailPresenterDelegate: BasePresenterDelegate {
    func updateChart()
    func updateBalance(_ balance: String)
    func updateMonthLimit(_ limit: String)
    func updateTotalExpense(_ total: String)
    func updateCurrentMonthDate(_ date: String)
    func updateExpenseCoverColor(_ color: UIColor?)
    func showEditBudgetLimitView(with title: String, message: String, create: String, cancel: String, placeholder: String, budgetLimit: String)
}

class BudgetDetailPresenter: BasePresenter {
    weak var delegate: BudgetDetailPresenterDelegate?
    
    fileprivate var selectedSlice: UInt?
    fileprivate var pieChartColors = [UIColor]()
    
    private var colorsRange = [Range<Double>]()
    private let colors = [UIColor.flatGreen, UIColor.flatYellow, UIColor.flatRed]
    
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
        
        self.budgetDetailInteraction.delegate = self
        
        self.delegate?.showPage(title: self.budgetDetailInteraction.budget.name)
        self.delegate?.updateCurrentMonthDate(UtilityFormatter.yearMonthFormatter.string(from: Date()))
        self.configureColors()
        self.configurePiChartColors()
        self.configureTotalExpenses()
        self.configureMonthBudget()
        self.configureBalance()
        self.updateTotalSpentExpensesColor()
    }
    
    private func configurePiChartColors() {
        self.pieChartColors.append(UIColor.flatRed)
        self.pieChartColors.append(UIColor.flatOrange)
        self.pieChartColors.append(UIColor.flatYellow)
        self.pieChartColors.append(UIColor.flatSkyBlue)
        self.pieChartColors.append(UIColor.flatGreen)
        self.pieChartColors.append(UIColor.flatWatermelon)
        self.pieChartColors.append(UIColor.flatLime)
        self.pieChartColors.append(UIColor.flatBlue)
        self.pieChartColors.append(UIColor.flatMint)
        self.pieChartColors.append(UIColor.flatPink)
        self.pieChartColors.append(UIColor.flatPlum)
        self.pieChartColors.append(UIColor.flatSand)
        self.pieChartColors.append(UIColor.flatTeal)
        self.pieChartColors.append(UIColor.flatMagenta)
        self.pieChartColors.append(UIColor.flatBrown)
        self.pieChartColors.append(UIColor.flatGray)
    }
    
    private func configureColors() {
        let rangeLength = 1.0 / Double(self.colors.count)
        
        for i in 0..<self.colors.count {
            let start = rangeLength * Double(i)
            let end = rangeLength * Double(i + 1)
            
            self.colorsRange.append(start..<end)
        }
    }
    
    fileprivate func updateTotalSpentExpensesColor() {
        let budget = self.budgetDetailInteraction.lastMonthLimit()?.limit ?? 0.0
        
        let totalExpenses = self.budgetDetailInteraction.totalExpenses()
        
        if totalExpenses == 0.0 {
            self.delegate?.updateExpenseCoverColor(self.colors.first)
            return
        }
        
        if budget == 0.0 {
            self.delegate?.updateExpenseCoverColor(self.colors.last)
            return
        }
        
        let percent = totalExpenses / budget
        let percentColor = Double(self.colors.count) * percent
        let percentColorIndex = Int(floor(percentColor))
        
        if percentColorIndex == 0 {
            let resColor = self.colors[percentColorIndex]
            self.delegate?.updateExpenseCoverColor(resColor)
        }
        else if percentColorIndex >= self.colors.count {
            let resColor = self.colors.last
            self.delegate?.updateExpenseCoverColor(resColor)
        }
        else {
            for range in self.colorsRange {
                if range.contains(percent) {
                    guard let rangeIndex = self.colorsRange.index(of: range) else {
                        continue
                    }
                    
                    let dif = percent - range.lowerBound
                    let rangeLength = range.upperBound - range.lowerBound
                    let rangePercantage = dif / rangeLength
                    
                    let fromColor = self.colors[rangeIndex - 1]
                    let toColor = self.colors[rangeIndex]
                    
                    let cgiColors = fromColor.cgColor.components ?? []
                    var resCGIColors = [Float]()
                    for i in 0..<cgiColors.count {
                        let toColorValue = toColor.cgColor.components![i]
                        let fromColorValue = cgiColors[i]
                        let resValue = (Double(toColorValue) - Double(fromColorValue)) * rangePercantage + Double(fromColorValue)
                        resCGIColors.append(Float(resValue))
                    }
                    
                    let resColor = UIColor(colorLiteralRed: resCGIColors[0], green: resCGIColors[1], blue: resCGIColors[2], alpha: resCGIColors[3])
                    self.delegate?.updateExpenseCoverColor(resColor)
                }
            }
        }
    }
    
    fileprivate func configureTotalExpenses() {
        let total = self.budgetDetailInteraction.totalExpenses()
        self.delegate?.updateTotalExpense(String(total))
    }
    
    fileprivate func configureMonthBudget() {
        let month = self.budgetDetailInteraction.lastMonthLimit()
        self.delegate?.updateMonthLimit(String(month?.limit ?? 0.0))
    }
    
    fileprivate func configureBalance() {
        self.delegate?.updateBalance(String(self.budgetDetailInteraction.balance()))
    }
    
    func createNewExpense() {
        self.budgetDetailRouter.openEditExpensePage(with: self.budgetDetailInteraction.budgetID)
    }
    
    func showAllExpenses() {
        self.budgetDetailRouter.showAllExpensesPage(with: self.budgetDetailInteraction.budgetID)
    }
    
    func createHandler(with alertController: UIAlertController) -> ((UIAlertAction) -> Swift.Void)? {
        let res: ((UIAlertAction) -> Swift.Void)? = { (action) in
            guard let text = alertController.textFields?.first?.text  else {
                return
            }
            
            let newLimit = UtilityFormatter.amount(from: text)
            self.budgetDetailInteraction.createOrUpdateCurrentBudgetLimit(newLimit?.doubleValue ?? 0.0)
            self.configureMonthBudget()
            self.updateTotalSpentExpensesColor()
            self.configureBalance()
        }
        
        return res
    }
    
    func changeBudgetLimit() {
        self.delegate?.showEditBudgetLimitView(with: LocalisedManager.edit.budgetLimit.changeLimitTitle,
                                               message: LocalisedManager.edit.budgetLimit.changeLimitMessage,
                                               create: LocalisedManager.generic.create,
                                               cancel: LocalisedManager.generic.cancel,
                                               placeholder: LocalisedManager.edit.budgetLimit.changeLimitTextPlaceholder,
                                               budgetLimit: String(self.budgetDetailInteraction.lastMonthLimit()?.limit ?? 0.0))
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
    
    func sliceFill(for pieChart: CPTPieChart, record idx: UInt) -> CPTFill? {
        if self.budgetDetailInteraction.isEmpty() {
            return CPTFill(color: CPTColor.gray())
        }
        
        let index = Int(idx)
        if index < self.pieChartColors.count - 1 {
            return CPTFill(color: CPTColor(cgColor: self.pieChartColors[index].cgColor))
        }
        
        return nil
    }
}

// MARK: - CPTPieChartDelegate

extension BudgetDetailPresenter: CPTPieChartDelegate {
    func pieChart(_ plot: CPTPieChart, sliceTouchDownAtRecord idx: UInt) {
        if self.selectedSlice == idx {
            self.selectedSlice = nil
        }
        else {
            self.selectedSlice = idx
        }
        
        self.delegate?.updateChart()
    }
}

// MARK: - BudgetDetailInteractionDelegate

extension BudgetDetailPresenter: BudgetDetailInteractionDelegate {
    func didChangeContent() {
        self.configureTotalExpenses()
        self.configureBalance()
        self.updateTotalSpentExpensesColor()
        self.delegate?.updateChart()
    }
    
    func limitChanged() {
        self.configureMonthBudget()
    }
}
