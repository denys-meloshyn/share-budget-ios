//
//  BudgetDetailPresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 03.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CorePlot
import CoreData
import MaterialColor

protocol BudgetDetailPresenterDelegate: BasePresenterDelegate {
    func updateChart()
    func updateBalance(_ balance: String)
    func updateMonthLimit(_ limit: String)
    func updateTotalExpense(_ total: String)
    func updateCurrentMonthDate(_ date: String)
    func updateExpenseCoverColor(_ color: UIColor?)
    func updateCreateButtonAnimation(_ isActive: Bool)
    func updateNativeNavigationVisibility(_ isVisible: Bool)
    func showEditBudgetLimitView(with title: String, message: String, create: String, cancel: String, placeholder: String, budgetLimit: String)
}

protocol BudgetDetailPresenterProtocol: BasePresenterProtocol, CPTPieChartDataSource, CPTPieChartDelegate, AutoMockable {
    var delegate: BudgetDetailPresenterDelegate? { get set }

    func editMembers()
    func closePageAction()
    func showAllExpenses()
    func createNewExpense()
    func changeBudgetLimit()
    func createHandler(with alertController: UIAlertController) -> ((UIAlertAction) -> Swift.Void)?
}

class BudgetDetailPresenter<I: BudgetDetailInteractionProtocol, R: BudgetDetailRouterProtocol>: BasePresenter<I, R>, BudgetDetailPresenterProtocol {
    weak var delegate: BudgetDetailPresenterDelegate?

    fileprivate var selectedSlice: UInt?
    fileprivate var pieChartColors = [UIColor]()

    private var colorsRange = [Range<Double>]()
    private let colors = [MaterialColor.green.dark1, MaterialColor.yellow.dark1, MaterialColor.red.dark1]

    // MARK: - Life cycle methods

    func viewDidLoad() {
        interaction.delegate = self

        delegate?.showPage(title: interaction.budget.name)
        delegate?.updateCurrentMonthDate(UtilityFormatter.yearMonthFormatter.string(from: Date()))
        configureColors()
        configurePiChartColors()
        configureTotalExpenses()
        configureMonthBudget()
        configureBalance()
        updateTotalSpentExpensesColor()
    }

    func viewWillAppear(_ animated: Bool) {
        delegate?.updateNativeNavigationVisibility(false)
        delegate?.updateCreateButtonAnimation(true)
    }

    func viewWillDisappear(_ animated: Bool) {
        delegate?.updateNativeNavigationVisibility(true)
        delegate?.updateCreateButtonAnimation(false)
    }

    func viewDidAppear(_ animated: Bool) {
    }

    func viewDidDisappear(_ animated: Bool) {
    }

    // MARK: - CPTPieChartDataSource

    func numberOfRecords(for plot: CPTPlot) -> UInt {
        if interaction.isEmpty() {
            return 1
        }

        return UInt(interaction.numberOfCategoryExpenses())
    }

    func number(for plot: CPTPlot, field: UInt, record: UInt) -> Any? {
        if interaction.isEmpty() {
            return 1 as NSNumber
        }

        switch CPTPieChartField(rawValue: Int(field))! {
        case .sliceWidth:
            return NSNumber(value: interaction.totalExpenses(for: Int(record)))

        default:
            return record as NSNumber
        }
    }

    func dataLabel(for plot: CPTPlot, record: UInt) -> CPTLayer? {
        if interaction.isEmpty() {
            return nil
        }

        let label = CPTTextLayer(text: interaction.categoryTitle(for: Int(record)))

        if let textStyle = label.textStyle?.mutableCopy() as? CPTMutableTextStyle {
            textStyle.color = CPTColor.white()

            label.textStyle = textStyle
        }

        return label
    }

    func sliceFill(for pieChart: CPTPieChart, record idx: UInt) -> CPTFill? {
        if interaction.isEmpty() {
            return CPTFill(color: CPTColor.gray())
        }

        let index = Int(idx)
        if index < pieChartColors.count - 1 {
            return CPTFill(color: CPTColor(cgColor: pieChartColors[index].cgColor))
        }

        return nil
    }

    // MARK: - CPTPieChartDelegate

    func pieChart(_ plot: CPTPieChart, sliceTouchDownAtRecord idx: UInt) {
        if interaction.isEmpty() {
            return
        }

        if selectedSlice == idx {
            selectedSlice = nil
        } else {
            selectedSlice = idx
        }

        delegate?.updateChart()
        router.showAllExpensesPage(with: interaction.budgetID, categoryID: interaction.category(for: Int(idx))?.objectID)
    }

    // MARK: - Private methods

    private func configurePiChartColors() {
        let base: [ColorPalette.Type] = [MaterialColor.indigo.self,
                                         MaterialColor.blue.self,
                                         MaterialColor.lightBlue.self,
                                         MaterialColor.cyan.self,
                                         MaterialColor.teal.self,
                                         MaterialColor.green.self,
                                         MaterialColor.lightGreen.self,
                                         MaterialColor.lime.self,
                                         MaterialColor.yellow.self,
                                         MaterialColor.amber.self,
                                         MaterialColor.orange.self,
                                         MaterialColor.deepOrange.self,
                                         MaterialColor.brown.self,
                                         MaterialColor.red.self,
                                         MaterialColor.pink.self,
                                         MaterialColor.purple.self,
                                         MaterialColor.deepPurple.self,
                                         MaterialColor.grey.self,
                                         MaterialColor.blueGrey.self
        ]
        pieChartColors += base.map {
            $0.base
        }
        pieChartColors += base.map {
            $0.light1
        }
        pieChartColors += base.map {
            $0.dark1
        }
        pieChartColors += base.map {
            $0.light2
        }
        pieChartColors += base.map {
            $0.dark2
        }
        pieChartColors += base.map {
            $0.light3
        }
        pieChartColors += base.map {
            $0.dark3
        }
        pieChartColors += base.map {
            $0.light4
        }
        pieChartColors += base.map {
            $0.dark4
        }
        pieChartColors += base.map {
            $0.light5
        }
    }

    private func configureColors() {
        let rangeLength = 1.0 / Double(colors.count)

        for i in 0..<colors.count {
            let start = rangeLength * Double(i)
            let end = rangeLength * Double(i + 1)

            self.colorsRange.append(start..<end)
        }
    }

    fileprivate func updateTotalSpentExpensesColor() {
        let budget = interaction.lastMonthLimit()?.limit?.doubleValue ?? 0.0

        let totalExpenses = interaction.totalExpenses()

        if totalExpenses == 0.0 {
            delegate?.updateExpenseCoverColor(colors.first)
            return
        }

        if budget == 0.0 {
            delegate?.updateExpenseCoverColor(colors.last)
            return
        }

        let percent = totalExpenses / budget
        let percentColor = Double(colors.count) * percent
        let percentColorIndex = Int(floor(percentColor))

        if percentColorIndex == 0 {
            let resColor = colors[percentColorIndex]
            delegate?.updateExpenseCoverColor(resColor)
        } else if percentColorIndex >= colors.count {
            let resColor = colors.last
            delegate?.updateExpenseCoverColor(resColor)
        } else {
            for range in colorsRange {
                if range.contains(percent) {
                    guard let rangeIndex = colorsRange.index(of: range) else {
                        continue
                    }

                    let dif = percent - range.lowerBound
                    let rangeLength = range.upperBound - range.lowerBound
                    let rangePercantage = dif / rangeLength

                    let fromColor = colors[rangeIndex - 1]
                    let toColor = colors[rangeIndex]

                    let cgiColors = fromColor.cgColor.components ?? []
                    var resCGIColors = [CGFloat]()
                    for i in 0..<cgiColors.count {
                        let toColorValue = toColor.cgColor.components![i]
                        let fromColorValue = cgiColors[i]
                        let resValue = (Double(toColorValue) - Double(fromColorValue)) * rangePercantage + Double(fromColorValue)
                        resCGIColors.append(CGFloat(resValue))
                    }

                    let resColor = UIColor(red: resCGIColors[0],
                                           green: resCGIColors[1],
                                           blue: resCGIColors[2],
                                           alpha: resCGIColors[3])
                    delegate?.updateExpenseCoverColor(resColor)
                }
            }
        }
    }

    fileprivate func configureTotalExpenses() {
        let total = interaction.totalExpenses()
        delegate?.updateTotalExpense(UtilityFormatter.priceFormatter.string(for: total) ?? "0")
    }

    fileprivate func configureMonthBudget() {
        let month = interaction.lastMonthLimit()
        delegate?.updateMonthLimit(UtilityFormatter.priceFormatter.string(for: month?.limit ?? 0) ?? "0")
    }

    fileprivate func configureBalance() {
        delegate?.updateBalance(UtilityFormatter.priceFormatter.string(for: interaction.balance()) ?? "0")
    }

    func createNewExpense() {
        router.openEditExpensePage(with: interaction.budgetID)
    }

    func showAllExpenses() {
        router.showAllExpensesPage(with: interaction.budgetID, categoryID: nil)
    }

    func createHandler(with alertController: UIAlertController) -> ((UIAlertAction) -> Swift.Void)? {
        let res: ((UIAlertAction) -> Swift.Void)? = { (action) in
            guard let text = alertController.textFields?.first?.text else {
                return
            }

            let newLimit = UtilityFormatter.amount(from: text)
            self.interaction.createOrUpdateCurrentBudgetLimit(newLimit?.doubleValue ?? 0.0)
            self.configureMonthBudget()
            self.updateTotalSpentExpensesColor()
            self.configureBalance()
        }

        return res
    }

    func changeBudgetLimit() {
        let limit = NSNumber(value: interaction.lastMonthLimit()?.limit?.doubleValue ?? 0.0)
        let formattedLimit = UtilityFormatter.priceEditFormatter.string(from: limit) ?? ""

        delegate?.showEditBudgetLimitView(with: LocalisedManager.edit.budgetLimit.changeLimitTitle,
                                          message: LocalisedManager.edit.budgetLimit.changeLimitMessage,
                                          create: LocalisedManager.generic.create,
                                          cancel: LocalisedManager.generic.cancel,
                                          placeholder: LocalisedManager.edit.budgetLimit.changeLimitTextPlaceholder,
                                          budgetLimit: formattedLimit)
    }

    func closePageAction() {
        router.closePage()
    }

    func editMembers() {
        router.openTeamMembersPage(with: interaction.budget.objectID)
    }
}

// MARK: - BudgetDetailInteractionDelegate

extension BudgetDetailPresenter: BudgetDetailInteractionDelegate {
    func willChangeContent() {
    }

    func changed(at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    }

    func didChangeContent() {
        configureTotalExpenses()
        configureBalance()
        updateTotalSpentExpensesColor()
        delegate?.updateChart()
    }

    func limitChanged() {
        configureMonthBudget()
    }
}
