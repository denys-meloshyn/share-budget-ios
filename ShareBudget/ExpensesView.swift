//
//  ExpensesView.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 05.06.2018.
//  Copyright © 2018 Denys Meloshyn. All rights reserved.
//

import UIKit

protocol ExpensesViewProtocol: BaseViewProtocol {
    var tableView: UITableView! { get set }
}

class ExpensesView<Presenter: ExpensesPresenterProtocol>: BaseView<Presenter>, ExpensesViewProtocol {
    var tableView: UITableView!

    private var searchController: UISearchController!
    private var addBarButtonItem: BarButtonItemListener?
    private var searchTableViewController = UITableViewController()

    fileprivate let headerViewReuseIdentifier = "ExpenseTableViewHeader"

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSearchTable()
        configureTable()
    }

    private func configureTableWithDefaultProperties(tableView: UITableView) {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80.0
        tableView.sectionHeaderHeight = 40.0
        addCells(to: tableView)

        tableView.delegate = presenter
        tableView.dataSource = presenter
    }

    private func addCells(to tableView: UITableView) {
        tableView.register(R.nib.expenseTableViewCell)
        tableView.register(R.nib.expenseTableViewHeader(), forHeaderFooterViewReuseIdentifier: headerViewReuseIdentifier)
    }

    private func configureTable() {
        configureTableWithDefaultProperties(tableView: tableView)
        tableView.tableHeaderView = searchController.searchBar
    }

    private func configureSearchTable() {
        configureTableWithDefaultProperties(tableView: searchTableViewController.tableView)

        searchController = UISearchController(searchResultsController: searchTableViewController)
        searchController.delegate = presenter
        searchController.searchResultsUpdater = presenter
    }
}

extension ExpensesView: ExpensesPresenterDelegate {
    func showCreateNewExpenseButton(action: @escaping BarButtonItemListenerActionBlock) {
        addBarButtonItem = BarButtonItemListener(with: .add, action: action)
        viewController?.navigationItem.rightBarButtonItem = addBarButtonItem?.barButtonItem
    }
    
    func createExpenseDateSectionHeaderView(month: String?, expenses: String?) -> ExpenseTableViewHeader? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ExpenseTableViewHeader") as? ExpenseTableViewHeader
        headerView?.monthLabel?.text = month
        headerView?.monthExpensesLabel?.text = expenses

        return headerView
    }
    
    func createExpenseTableViewCell(at indexPath: IndexPath,
                                    title: String?,
                                    price: String?,
                                    category: String?,
                                    budget: String?,
                                    date: String?) -> ExpenseTableViewCell? {
        let cell = searchTableViewController.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.expenseCell, for: indexPath)

        cell?.titleLabel?.text = title
        cell?.priceLabel?.text = price
        cell?.categoryLabel?.text = category
        cell?.budgetRestLabel?.text = budget
        cell?.dateLabel?.text = date

        return cell
    }

    func refresh() {
        tableView.reloadData()
        searchTableViewController.tableView.reloadData()
    }
}
