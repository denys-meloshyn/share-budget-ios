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

class ExpensesView<Presenter: ExpensesPresenterProtocol>: BaseView<Presenter>,
        ExpensesViewProtocol,
        UITableViewDataSource,
        UITableViewDelegate,
        UISearchControllerDelegate,
        UISearchResultsUpdating {
    var tableView: UITableView!

    private var searchController: UISearchController!
    private var addBarButtonItem: BarButtonItemListener?
    private var searchTableViewController = UITableViewController()

    fileprivate let headerViewReuseIdentifier = "ExpenseTableViewHeader"

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSearchTable()
        configureTable()

        viewController?.navigationItem.searchController = searchController
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.interaction().numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.interaction().numberOfRows(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.expenseCell, for: indexPath) else {
            fatalError("Cell \(R.reuseIdentifier.expenseCell) should exist")
        }

        let viewModel = presenter.cellViewModel(for: indexPath)
        cell.titleLabel?.text = viewModel.title
        cell.priceLabel?.text = viewModel.price
        cell.categoryLabel?.text = viewModel.category
        cell.budgetRestLabel?.text = viewModel.budget
        cell.dateLabel?.text = viewModel.date

        let labelsToHighlight: [UILabel?] = [cell.titleLabel,
                                 cell.priceLabel,
                                 cell.categoryLabel,
                                 cell.dateLabel]

        labelsToHighlight.forEach { label in
            label?.highlightAllOrNothing(viewModel.highlightedText ?? "", color: Constants.color.dflt.actionColor)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ExpenseTableViewHeader") as? ExpenseTableViewHeader

        let viewModel = presenter.headerViewModel(for: section)

        headerView?.monthLabel?.text = viewModel.month
        headerView?.monthExpensesLabel?.text = viewModel.expenses

        return headerView
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        presenter.expenseSelected(at: indexPath)
    }

    // MARK: - UISearchControllerDelegate

    func willPresentSearchController(_ searchController: UISearchController) {
    }

    func didPresentSearchController(_ searchController: UISearchController) {
    }

    func willDismissSearchController(_ searchController: UISearchController) {
    }

    func didDismissSearchController(_ searchController: UISearchController) {
    }

    func presentSearchController(_ searchController: UISearchController) {
    }

    // MARK: - UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {
        presenter.updateSearchText(newValue: searchController.searchBar.text)
    }

    private func configureTableWithDefaultProperties(tableView: UITableView) {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80.0
        tableView.sectionHeaderHeight = 40.0
        addCells(to: tableView)

        tableView.delegate = self
        tableView.dataSource = self
    }

    private func addCells(to tableView: UITableView) {
        tableView.register(R.nib.expenseTableViewCell)
        tableView.register(R.nib.expenseTableViewHeader(), forHeaderFooterViewReuseIdentifier: headerViewReuseIdentifier)
    }

    private func configureTable() {
        configureTableWithDefaultProperties(tableView: tableView)
    }

    private func configureSearchTable() {
        configureTableWithDefaultProperties(tableView: searchTableViewController.tableView)
        searchController = UISearchController(searchResultsController: searchTableViewController)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
    }
}

extension ExpensesView: ExpensesPresenterDelegate {
    func showCreateNewExpenseButton(action: @escaping BarButtonItemListenerActionBlock) {
        addBarButtonItem = BarButtonItemListener(with: .add, action: action)
        viewController?.navigationItem.rightBarButtonItem = addBarButtonItem?.barButtonItem
        viewController?.navigationItem.hidesSearchBarWhenScrolling = false
        viewController?.definesPresentationContext = true
    }

    func refresh() {
        tableView.reloadData()
        searchTableViewController.tableView.reloadData()
    }
}
