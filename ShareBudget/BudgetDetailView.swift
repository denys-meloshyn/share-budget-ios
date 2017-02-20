//
//  BudgetDetailView.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 03.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import Charts

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
    weak var chartView: PieChartView? {
        didSet {
            self.configureChart()
            self.configureChartData()
        }
    }
    
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
        self.chartView?.usePercentValuesEnabled = true
        self.chartView?.drawSlicesUnderHoleEnabled = true
        self.chartView?.holeRadiusPercent = 0.58
        self.chartView?.drawEntryLabelsEnabled = true
        self.chartView?.transparentCircleRadiusPercent = 0.61
        self.chartView?.chartDescription?.enabled = true
        self.chartView?.delegate = self
        
//        self.chartView?.setExtraOffsets(left: 5.0, top: 10.0, right: 5.0, bottom: 5.0)
        
        self.chartView?.drawCenterTextEnabled = false
        
        self.chartView?.drawHoleEnabled = true
        self.chartView?.rotationAngle = 0.0
        self.chartView?.rotationEnabled = true
        self.chartView?.highlightPerTapEnabled = true
        
        let legend = self.chartView?.legend
        legend?.drawInside = true
    }
    
//    - (void)setupPieChartView:(PieChartView *)chartView
//    {
//    
//    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
//    paragraphStyle.alignment = NSTextAlignmentCenter;
//    
//    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"Charts\nby Daniel Cohen Gindi"];
//    [centerText setAttributes:@{
//    NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:13.f],
//    NSParagraphStyleAttributeName: paragraphStyle
//    } range:NSMakeRange(0, centerText.length)];
//    [centerText addAttributes:@{
//    NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f],
//    NSForegroundColorAttributeName: UIColor.grayColor
//    } range:NSMakeRange(10, centerText.length - 10)];
//    [centerText addAttributes:@{
//    NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:11.f],
//    NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]
//    } range:NSMakeRange(centerText.length - 19, 19)];
//    chartView.centerAttributedText = centerText;
//    
//    ChartLegend *l = chartView.legend;
//    l.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
//    l.verticalAlignment = ChartLegendVerticalAlignmentTop;
//    l.orientation = ChartLegendOrientationVertical;
//    l.drawInside = NO;
//    l.xEntrySpace = 7.0;
//    l.yEntrySpace = 0.0;
//    l.yOffset = 0.0;
//    }
    
    func configureChartData() {
        var values = [PieChartDataEntry]()
        
        for i in 1..<20 {
            let item = PieChartDataEntry(value: Double(i * 10), label: "#\(i)")
            values.append(item)
        }
        
        let dataSet = PieChartDataSet(values: values, label: "Results")
        dataSet.drawValuesEnabled = true
        dataSet.sliceSpace = 5.0
        
        let data = PieChartData(dataSet: dataSet)
        self.chartView?.data = data
    }
    
//    - (void)setDataCount:(int)count range:(double)range
//    {
//    double mult = range;
//
//    NSMutableArray *values = [[NSMutableArray alloc] init];
//
//    for (int i = 0; i < count; i++)
//    {
//    [values addObject:[[PieChartDataEntry alloc] initWithValue:(arc4random_uniform(mult) + mult / 5) label:parties[i % parties.count] icon: [UIImage imageNamed:@"icon"]]];
//    }
//    
//    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@"Election Results"];
//    
//    dataSet.drawIconsEnabled = NO;
//    
//    dataSet.sliceSpace = 2.0;
//    dataSet.iconsOffset = CGPointMake(0, 40);
//    
//    // add a lot of colors
//    
//    NSMutableArray *colors = [[NSMutableArray alloc] init];
//    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
//    [colors addObjectsFromArray:ChartColorTemplates.joyful];
//    [colors addObjectsFromArray:ChartColorTemplates.colorful];
//    [colors addObjectsFromArray:ChartColorTemplates.liberty];
//    [colors addObjectsFromArray:ChartColorTemplates.pastel];
//    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
//    
//    dataSet.colors = colors;
//    
//    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
//    
//    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
//    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
//    pFormatter.maximumFractionDigits = 1;
//    pFormatter.multiplier = @1.f;
//    pFormatter.percentSymbol = @" %";
//    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
//    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
//    [data setValueTextColor:UIColor.whiteColor];
//    
//    _chartView.data = data;
//    [_chartView highlightValues:nil];
//    }
}

extension BudgetDetailView: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
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
