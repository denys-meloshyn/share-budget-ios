//
//  BudgetView.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 28.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import Rswift

protocol BudgetViewProtocol: BaseViewProtocol {
    var tableView: UITableView? { get set }
    var createNewGroupLabel: UILabel? { get set }
    var createNewGroupRootView: UIView? { get set }
    var constantCreateNewGroupRootViewBottom: NSLayoutConstraint? { get set }
}

class BudgetView<T: BudgetPresenterProtocol>: BaseView<T>, BudgetViewProtocol {
    fileprivate let tableBudgetCellReuseIdentifier = "BudgetTableViewCell"
    fileprivate let tableHeaderReuseIdentifier = "CreateSearchTableViewHeader"
    
    weak var tableView: UITableView?
    weak var createNewGroupLabel: UILabel?
    weak var createNewGroupRootView: UIView?
    weak var constantCreateNewGroupRootViewBottom: NSLayoutConstraint?
    
    override init(with presenter: T, and viewController: UIViewController) {
        super.init(with: presenter, and: viewController)
        
        presenter.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTable()
        viewController?.view.backgroundColor = Constants.color.dflt.backgroundColor
    }
    
    func configureTable() {
        let nib = R.nib.createSearchTableViewHeader()
        tableView?.register(nib, forHeaderFooterViewReuseIdentifier: tableHeaderReuseIdentifier)
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: tableBudgetCellReuseIdentifier)
        tableView?.delegate = presenter
        tableView?.dataSource = presenter
    }
    
    // Method of BudgetPresenterDelegate, need here to be able to test it
    func refreshData(for mode: BudgetHeaderMode) {
        tableView?.reloadData()
        let header = tableView?.headerView(forSection: 0) as? CreateSearchTableViewHeader
        header?.mode = mode
    }
    
    func showCreateNewGroupMessage(message: NSAttributedString) {
        tableView?.separatorStyle = .none
        createNewGroupRootView?.isHidden = false
        
        createNewGroupLabel?.attributedText = message
    }
    
    func showGroupList() {
        tableView?.separatorStyle = .singleLine
        createNewGroupRootView?.isHidden = true
    }
    
    func cancelSearch() {
        searchView()?.textField?.resignFirstResponder()
    }
}

// MARK: - BudgetPresenterDelegate

extension BudgetView: BudgetPresenterDelegate {
    func searchView() -> CreateSearchTableViewHeader? {
        let searchView = tableView?.headerView(forSection: 0) as? CreateSearchTableViewHeader
        
        return searchView
    }
    
    func createSearchTableHeaderView(with mode: BudgetHeaderMode, placeholder: String) -> CreateSearchTableViewHeader? {
        let header = tableView?.dequeueReusableHeaderFooterView(withIdentifier: tableHeaderReuseIdentifier) as? CreateSearchTableViewHeader
        header?.delegate = presenter
        header?.textField?.placeholder = placeholder
        header?.mode = mode
        
        return header
    }
    
    func createBudgetCell(with title: String?) -> UITableViewCell {
        let cell = tableView?.dequeueReusableCell(withIdentifier: tableBudgetCellReuseIdentifier)
        cell?.backgroundColor = UIColor.clear
        cell?.textLabel?.text = title
        
        return cell!
    }
    
    func clearSearch() {
        searchView()?.textField?.text = ""
    }
    
    func removeBottomOffset() {
        guard var inset = tableView?.contentInset else {
            return
        }
        inset.bottom = viewController.view.safeAreaInsets.bottom
        
        tableView?.contentInset = inset
        tableView?.scrollIndicatorInsets = inset
        constantCreateNewGroupRootViewBottom?.constant = 0.0
    }
    
    func setBottomOffset(_ offset: Double) {
        guard var inset = tableView?.contentInset else {
            return
        }
        inset.bottom = CGFloat(offset)
        
        tableView?.contentInset = inset
        tableView?.scrollIndicatorInsets = inset
        constantCreateNewGroupRootViewBottom?.constant = CGFloat(offset)
    }
}
