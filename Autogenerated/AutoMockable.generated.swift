// Generated using Sourcery 0.12.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif













class BaseViewProtocolMock: BaseViewProtocol {

    //MARK: - viewDidLoad

    var viewDidLoadCallsCount = 0
    var viewDidLoadCalled: Bool {
        return viewDidLoadCallsCount > 0
    }
    var viewDidLoadClosure: (() -> Void)?

    func viewDidLoad() {
        viewDidLoadCallsCount += 1
        viewDidLoadClosure?()
    }

    //MARK: - viewWillAppear

    var viewWillAppearCallsCount = 0
    var viewWillAppearCalled: Bool {
        return viewWillAppearCallsCount > 0
    }
    var viewWillAppearReceivedAnimated: Bool?
    var viewWillAppearClosure: ((Bool) -> Void)?

    func viewWillAppear(_ animated: Bool) {
        viewWillAppearCallsCount += 1
        viewWillAppearReceivedAnimated = animated
        viewWillAppearClosure?(animated)
    }

    //MARK: - viewDidAppear

    var viewDidAppearCallsCount = 0
    var viewDidAppearCalled: Bool {
        return viewDidAppearCallsCount > 0
    }
    var viewDidAppearReceivedAnimated: Bool?
    var viewDidAppearClosure: ((Bool) -> Void)?

    func viewDidAppear(_ animated: Bool) {
        viewDidAppearCallsCount += 1
        viewDidAppearReceivedAnimated = animated
        viewDidAppearClosure?(animated)
    }

    //MARK: - viewWillDisappear

    var viewWillDisappearCallsCount = 0
    var viewWillDisappearCalled: Bool {
        return viewWillDisappearCallsCount > 0
    }
    var viewWillDisappearReceivedAnimated: Bool?
    var viewWillDisappearClosure: ((Bool) -> Void)?

    func viewWillDisappear(_ animated: Bool) {
        viewWillDisappearCallsCount += 1
        viewWillDisappearReceivedAnimated = animated
        viewWillDisappearClosure?(animated)
    }

    //MARK: - viewDidDisappear

    var viewDidDisappearCallsCount = 0
    var viewDidDisappearCalled: Bool {
        return viewDidDisappearCallsCount > 0
    }
    var viewDidDisappearReceivedAnimated: Bool?
    var viewDidDisappearClosure: ((Bool) -> Void)?

    func viewDidDisappear(_ animated: Bool) {
        viewDidDisappearCallsCount += 1
        viewDidDisappearReceivedAnimated = animated
        viewDidDisappearClosure?(animated)
    }

}
class BudgetDetailPresenterProtocolMock: BudgetDetailPresenterProtocol {
    var delegate: BudgetDetailPresenterDelegate?

    //MARK: - editMembers

    var editMembersCallsCount = 0
    var editMembersCalled: Bool {
        return editMembersCallsCount > 0
    }
    var editMembersClosure: (() -> Void)?

    func editMembers() {
        editMembersCallsCount += 1
        editMembersClosure?()
    }

    //MARK: - closePageAction

    var closePageActionCallsCount = 0
    var closePageActionCalled: Bool {
        return closePageActionCallsCount > 0
    }
    var closePageActionClosure: (() -> Void)?

    func closePageAction() {
        closePageActionCallsCount += 1
        closePageActionClosure?()
    }

    //MARK: - showAllExpenses

    var showAllExpensesCallsCount = 0
    var showAllExpensesCalled: Bool {
        return showAllExpensesCallsCount > 0
    }
    var showAllExpensesClosure: (() -> Void)?

    func showAllExpenses() {
        showAllExpensesCallsCount += 1
        showAllExpensesClosure?()
    }

    //MARK: - createNewExpense

    var createNewExpenseCallsCount = 0
    var createNewExpenseCalled: Bool {
        return createNewExpenseCallsCount > 0
    }
    var createNewExpenseClosure: (() -> Void)?

    func createNewExpense() {
        createNewExpenseCallsCount += 1
        createNewExpenseClosure?()
    }

    //MARK: - changeBudgetLimit

    var changeBudgetLimitCallsCount = 0
    var changeBudgetLimitCalled: Bool {
        return changeBudgetLimitCallsCount > 0
    }
    var changeBudgetLimitClosure: (() -> Void)?

    func changeBudgetLimit() {
        changeBudgetLimitCallsCount += 1
        changeBudgetLimitClosure?()
    }

    //MARK: - createHandler

    var createHandlerWithCallsCount = 0
    var createHandlerWithCalled: Bool {
        return createHandlerWithCallsCount > 0
    }
    var createHandlerWithReceivedAlertController: UIAlertController?
    var createHandlerWithReturnValue: ((UIAlertAction) -> Swift.Void)?
    var createHandlerWithClosure: ((UIAlertController) -> ((UIAlertAction) -> Swift.Void)?)?

    func createHandler(with alertController: UIAlertController) -> ((UIAlertAction) -> Swift.Void)? {
        createHandlerWithCallsCount += 1
        createHandlerWithReceivedAlertController = alertController
        return createHandlerWithClosure.map({ $0(alertController) }) ?? createHandlerWithReturnValue
    }

    //MARK: - viewDidLoad

    var viewDidLoadCallsCount = 0
    var viewDidLoadCalled: Bool {
        return viewDidLoadCallsCount > 0
    }
    var viewDidLoadClosure: (() -> Void)?

    func viewDidLoad() {
        viewDidLoadCallsCount += 1
        viewDidLoadClosure?()
    }

    //MARK: - viewWillAppear

    var viewWillAppearCallsCount = 0
    var viewWillAppearCalled: Bool {
        return viewWillAppearCallsCount > 0
    }
    var viewWillAppearReceivedAnimated: Bool?
    var viewWillAppearClosure: ((Bool) -> Void)?

    func viewWillAppear(_ animated: Bool) {
        viewWillAppearCallsCount += 1
        viewWillAppearReceivedAnimated = animated
        viewWillAppearClosure?(animated)
    }

    //MARK: - viewDidAppear

    var viewDidAppearCallsCount = 0
    var viewDidAppearCalled: Bool {
        return viewDidAppearCallsCount > 0
    }
    var viewDidAppearReceivedAnimated: Bool?
    var viewDidAppearClosure: ((Bool) -> Void)?

    func viewDidAppear(_ animated: Bool) {
        viewDidAppearCallsCount += 1
        viewDidAppearReceivedAnimated = animated
        viewDidAppearClosure?(animated)
    }

    //MARK: - viewWillDisappear

    var viewWillDisappearCallsCount = 0
    var viewWillDisappearCalled: Bool {
        return viewWillDisappearCallsCount > 0
    }
    var viewWillDisappearReceivedAnimated: Bool?
    var viewWillDisappearClosure: ((Bool) -> Void)?

    func viewWillDisappear(_ animated: Bool) {
        viewWillDisappearCallsCount += 1
        viewWillDisappearReceivedAnimated = animated
        viewWillDisappearClosure?(animated)
    }

    //MARK: - viewDidDisappear

    var viewDidDisappearCallsCount = 0
    var viewDidDisappearCalled: Bool {
        return viewDidDisappearCallsCount > 0
    }
    var viewDidDisappearReceivedAnimated: Bool?
    var viewDidDisappearClosure: ((Bool) -> Void)?

    func viewDidDisappear(_ animated: Bool) {
        viewDidDisappearCallsCount += 1
        viewDidDisappearReceivedAnimated = animated
        viewDidDisappearClosure?(animated)
    }

}
class BudgetDetailViewProtocolMock: BudgetDetailViewProtocol {
    var monthLabel: UILabel?
    var minusLabel: UILabel?
    var equalLabel: UILabel?
    var budgetLabel: UILabel?
    var balanceLabel: UILabel?
    var expenseLabel: UILabel?
    var animationView: UIView?
    var navigationView: UIView?
    var expenseCoverView: UIView?
    var backButton: ButtonListener?
    var budgetContainerView: UIView?
    var expenseContainerView: UIView?
    var balanceContainerView: UIView?
    var budgetButton: ButtonListener?
    var expenseButton: ButtonListener?
    var navigationTitleLabel: UILabel?
    var chartView: CPTGraphHostingView?
    var safeAreaPlaceholderView: UIView?
    var budgetDescriptionLabel: UILabel?
    var editMemberButton: ButtonListener?
    var balanceDescriptionLabel: UILabel?
    var expenseDescriptionLabel: UILabel?
    var createExpenseButton: ButtonListener?
    var createNewExpenseContainerView: UIView?
    var constraintChartViewWidth: NSLayoutConstraint?
    var constraintChartViewHeight: NSLayoutConstraint?
    var constraintAnimationViewWidth: NSLayoutConstraint?
    var constraintAnimationViewHeight: NSLayoutConstraint?

    //MARK: - viewDidLoad

    var viewDidLoadCallsCount = 0
    var viewDidLoadCalled: Bool {
        return viewDidLoadCallsCount > 0
    }
    var viewDidLoadClosure: (() -> Void)?

    func viewDidLoad() {
        viewDidLoadCallsCount += 1
        viewDidLoadClosure?()
    }

    //MARK: - viewWillAppear

    var viewWillAppearCallsCount = 0
    var viewWillAppearCalled: Bool {
        return viewWillAppearCallsCount > 0
    }
    var viewWillAppearReceivedAnimated: Bool?
    var viewWillAppearClosure: ((Bool) -> Void)?

    func viewWillAppear(_ animated: Bool) {
        viewWillAppearCallsCount += 1
        viewWillAppearReceivedAnimated = animated
        viewWillAppearClosure?(animated)
    }

    //MARK: - viewDidAppear

    var viewDidAppearCallsCount = 0
    var viewDidAppearCalled: Bool {
        return viewDidAppearCallsCount > 0
    }
    var viewDidAppearReceivedAnimated: Bool?
    var viewDidAppearClosure: ((Bool) -> Void)?

    func viewDidAppear(_ animated: Bool) {
        viewDidAppearCallsCount += 1
        viewDidAppearReceivedAnimated = animated
        viewDidAppearClosure?(animated)
    }

    //MARK: - viewWillDisappear

    var viewWillDisappearCallsCount = 0
    var viewWillDisappearCalled: Bool {
        return viewWillDisappearCallsCount > 0
    }
    var viewWillDisappearReceivedAnimated: Bool?
    var viewWillDisappearClosure: ((Bool) -> Void)?

    func viewWillDisappear(_ animated: Bool) {
        viewWillDisappearCallsCount += 1
        viewWillDisappearReceivedAnimated = animated
        viewWillDisappearClosure?(animated)
    }

    //MARK: - viewDidDisappear

    var viewDidDisappearCallsCount = 0
    var viewDidDisappearCalled: Bool {
        return viewDidDisappearCallsCount > 0
    }
    var viewDidDisappearReceivedAnimated: Bool?
    var viewDidDisappearClosure: ((Bool) -> Void)?

    func viewDidDisappear(_ animated: Bool) {
        viewDidDisappearCallsCount += 1
        viewDidDisappearReceivedAnimated = animated
        viewDidDisappearClosure?(animated)
    }

}
class BudgetViewProtocolMock: BudgetViewProtocol {
    var tableView: UITableView?
    var createNewGroupLabel: UILabel?
    var createNewGroupRootView: UIView?
    var constantCreateNewGroupRootViewBottom: NSLayoutConstraint?

    //MARK: - viewDidLoad

    var viewDidLoadCallsCount = 0
    var viewDidLoadCalled: Bool {
        return viewDidLoadCallsCount > 0
    }
    var viewDidLoadClosure: (() -> Void)?

    func viewDidLoad() {
        viewDidLoadCallsCount += 1
        viewDidLoadClosure?()
    }

    //MARK: - viewWillAppear

    var viewWillAppearCallsCount = 0
    var viewWillAppearCalled: Bool {
        return viewWillAppearCallsCount > 0
    }
    var viewWillAppearReceivedAnimated: Bool?
    var viewWillAppearClosure: ((Bool) -> Void)?

    func viewWillAppear(_ animated: Bool) {
        viewWillAppearCallsCount += 1
        viewWillAppearReceivedAnimated = animated
        viewWillAppearClosure?(animated)
    }

    //MARK: - viewDidAppear

    var viewDidAppearCallsCount = 0
    var viewDidAppearCalled: Bool {
        return viewDidAppearCallsCount > 0
    }
    var viewDidAppearReceivedAnimated: Bool?
    var viewDidAppearClosure: ((Bool) -> Void)?

    func viewDidAppear(_ animated: Bool) {
        viewDidAppearCallsCount += 1
        viewDidAppearReceivedAnimated = animated
        viewDidAppearClosure?(animated)
    }

    //MARK: - viewWillDisappear

    var viewWillDisappearCallsCount = 0
    var viewWillDisappearCalled: Bool {
        return viewWillDisappearCallsCount > 0
    }
    var viewWillDisappearReceivedAnimated: Bool?
    var viewWillDisappearClosure: ((Bool) -> Void)?

    func viewWillDisappear(_ animated: Bool) {
        viewWillDisappearCallsCount += 1
        viewWillDisappearReceivedAnimated = animated
        viewWillDisappearClosure?(animated)
    }

    //MARK: - viewDidDisappear

    var viewDidDisappearCallsCount = 0
    var viewDidDisappearCalled: Bool {
        return viewDidDisappearCallsCount > 0
    }
    var viewDidDisappearReceivedAnimated: Bool?
    var viewDidDisappearClosure: ((Bool) -> Void)?

    func viewDidDisappear(_ animated: Bool) {
        viewDidDisappearCallsCount += 1
        viewDidDisappearReceivedAnimated = animated
        viewDidDisappearClosure?(animated)
    }

}
class CategoryViewProtocolMock: CategoryViewProtocol {
    var tableView: UITableView?

    //MARK: - viewDidLoad

    var viewDidLoadCallsCount = 0
    var viewDidLoadCalled: Bool {
        return viewDidLoadCallsCount > 0
    }
    var viewDidLoadClosure: (() -> Void)?

    func viewDidLoad() {
        viewDidLoadCallsCount += 1
        viewDidLoadClosure?()
    }

    //MARK: - viewWillAppear

    var viewWillAppearCallsCount = 0
    var viewWillAppearCalled: Bool {
        return viewWillAppearCallsCount > 0
    }
    var viewWillAppearReceivedAnimated: Bool?
    var viewWillAppearClosure: ((Bool) -> Void)?

    func viewWillAppear(_ animated: Bool) {
        viewWillAppearCallsCount += 1
        viewWillAppearReceivedAnimated = animated
        viewWillAppearClosure?(animated)
    }

    //MARK: - viewDidAppear

    var viewDidAppearCallsCount = 0
    var viewDidAppearCalled: Bool {
        return viewDidAppearCallsCount > 0
    }
    var viewDidAppearReceivedAnimated: Bool?
    var viewDidAppearClosure: ((Bool) -> Void)?

    func viewDidAppear(_ animated: Bool) {
        viewDidAppearCallsCount += 1
        viewDidAppearReceivedAnimated = animated
        viewDidAppearClosure?(animated)
    }

    //MARK: - viewWillDisappear

    var viewWillDisappearCallsCount = 0
    var viewWillDisappearCalled: Bool {
        return viewWillDisappearCallsCount > 0
    }
    var viewWillDisappearReceivedAnimated: Bool?
    var viewWillDisappearClosure: ((Bool) -> Void)?

    func viewWillDisappear(_ animated: Bool) {
        viewWillDisappearCallsCount += 1
        viewWillDisappearReceivedAnimated = animated
        viewWillDisappearClosure?(animated)
    }

    //MARK: - viewDidDisappear

    var viewDidDisappearCallsCount = 0
    var viewDidDisappearCalled: Bool {
        return viewDidDisappearCallsCount > 0
    }
    var viewDidDisappearReceivedAnimated: Bool?
    var viewDidDisappearClosure: ((Bool) -> Void)?

    func viewDidDisappear(_ animated: Bool) {
        viewDidDisappearCallsCount += 1
        viewDidDisappearReceivedAnimated = animated
        viewDidDisappearClosure?(animated)
    }

}
class EditExpenseViewProtocolMock: EditExpenseViewProtocol {
    var categoryButton: ButtonListener?
    var dateContainerView: UIView?
    var nameSeparatorLine: UIView?
    var dateTextField: UITextField?
    var nameTextField: UITextField?
    var priceTextField: UITextField?
    var categoryContainerView: UIView?

    //MARK: - viewDidLoad

    var viewDidLoadCallsCount = 0
    var viewDidLoadCalled: Bool {
        return viewDidLoadCallsCount > 0
    }
    var viewDidLoadClosure: (() -> Void)?

    func viewDidLoad() {
        viewDidLoadCallsCount += 1
        viewDidLoadClosure?()
    }

    //MARK: - viewWillAppear

    var viewWillAppearCallsCount = 0
    var viewWillAppearCalled: Bool {
        return viewWillAppearCallsCount > 0
    }
    var viewWillAppearReceivedAnimated: Bool?
    var viewWillAppearClosure: ((Bool) -> Void)?

    func viewWillAppear(_ animated: Bool) {
        viewWillAppearCallsCount += 1
        viewWillAppearReceivedAnimated = animated
        viewWillAppearClosure?(animated)
    }

    //MARK: - viewDidAppear

    var viewDidAppearCallsCount = 0
    var viewDidAppearCalled: Bool {
        return viewDidAppearCallsCount > 0
    }
    var viewDidAppearReceivedAnimated: Bool?
    var viewDidAppearClosure: ((Bool) -> Void)?

    func viewDidAppear(_ animated: Bool) {
        viewDidAppearCallsCount += 1
        viewDidAppearReceivedAnimated = animated
        viewDidAppearClosure?(animated)
    }

    //MARK: - viewWillDisappear

    var viewWillDisappearCallsCount = 0
    var viewWillDisappearCalled: Bool {
        return viewWillDisappearCallsCount > 0
    }
    var viewWillDisappearReceivedAnimated: Bool?
    var viewWillDisappearClosure: ((Bool) -> Void)?

    func viewWillDisappear(_ animated: Bool) {
        viewWillDisappearCallsCount += 1
        viewWillDisappearReceivedAnimated = animated
        viewWillDisappearClosure?(animated)
    }

    //MARK: - viewDidDisappear

    var viewDidDisappearCallsCount = 0
    var viewDidDisappearCalled: Bool {
        return viewDidDisappearCallsCount > 0
    }
    var viewDidDisappearReceivedAnimated: Bool?
    var viewDidDisappearClosure: ((Bool) -> Void)?

    func viewDidDisappear(_ animated: Bool) {
        viewDidDisappearCallsCount += 1
        viewDidDisappearReceivedAnimated = animated
        viewDidDisappearClosure?(animated)
    }

}
class ExpensesViewProtocolMock: ExpensesViewProtocol {
    var tableView: UITableView!

    //MARK: - viewDidLoad

    var viewDidLoadCallsCount = 0
    var viewDidLoadCalled: Bool {
        return viewDidLoadCallsCount > 0
    }
    var viewDidLoadClosure: (() -> Void)?

    func viewDidLoad() {
        viewDidLoadCallsCount += 1
        viewDidLoadClosure?()
    }

    //MARK: - viewWillAppear

    var viewWillAppearCallsCount = 0
    var viewWillAppearCalled: Bool {
        return viewWillAppearCallsCount > 0
    }
    var viewWillAppearReceivedAnimated: Bool?
    var viewWillAppearClosure: ((Bool) -> Void)?

    func viewWillAppear(_ animated: Bool) {
        viewWillAppearCallsCount += 1
        viewWillAppearReceivedAnimated = animated
        viewWillAppearClosure?(animated)
    }

    //MARK: - viewDidAppear

    var viewDidAppearCallsCount = 0
    var viewDidAppearCalled: Bool {
        return viewDidAppearCallsCount > 0
    }
    var viewDidAppearReceivedAnimated: Bool?
    var viewDidAppearClosure: ((Bool) -> Void)?

    func viewDidAppear(_ animated: Bool) {
        viewDidAppearCallsCount += 1
        viewDidAppearReceivedAnimated = animated
        viewDidAppearClosure?(animated)
    }

    //MARK: - viewWillDisappear

    var viewWillDisappearCallsCount = 0
    var viewWillDisappearCalled: Bool {
        return viewWillDisappearCallsCount > 0
    }
    var viewWillDisappearReceivedAnimated: Bool?
    var viewWillDisappearClosure: ((Bool) -> Void)?

    func viewWillDisappear(_ animated: Bool) {
        viewWillDisappearCallsCount += 1
        viewWillDisappearReceivedAnimated = animated
        viewWillDisappearClosure?(animated)
    }

    //MARK: - viewDidDisappear

    var viewDidDisappearCallsCount = 0
    var viewDidDisappearCalled: Bool {
        return viewDidDisappearCallsCount > 0
    }
    var viewDidDisappearReceivedAnimated: Bool?
    var viewDidDisappearClosure: ((Bool) -> Void)?

    func viewDidDisappear(_ animated: Bool) {
        viewDidDisappearCallsCount += 1
        viewDidDisappearReceivedAnimated = animated
        viewDidDisappearClosure?(animated)
    }

}
class LoginViewProtocolMock: LoginViewProtocol {
    var stackView: UIStackView?
    var scrollView: UIScrollView?
    var authorisationButton: UIButton?
    var authorisationModeButton: UIButton?

    //MARK: - viewDidLoad

    var viewDidLoadCallsCount = 0
    var viewDidLoadCalled: Bool {
        return viewDidLoadCallsCount > 0
    }
    var viewDidLoadClosure: (() -> Void)?

    func viewDidLoad() {
        viewDidLoadCallsCount += 1
        viewDidLoadClosure?()
    }

    //MARK: - viewWillAppear

    var viewWillAppearCallsCount = 0
    var viewWillAppearCalled: Bool {
        return viewWillAppearCallsCount > 0
    }
    var viewWillAppearReceivedAnimated: Bool?
    var viewWillAppearClosure: ((Bool) -> Void)?

    func viewWillAppear(_ animated: Bool) {
        viewWillAppearCallsCount += 1
        viewWillAppearReceivedAnimated = animated
        viewWillAppearClosure?(animated)
    }

    //MARK: - viewDidAppear

    var viewDidAppearCallsCount = 0
    var viewDidAppearCalled: Bool {
        return viewDidAppearCallsCount > 0
    }
    var viewDidAppearReceivedAnimated: Bool?
    var viewDidAppearClosure: ((Bool) -> Void)?

    func viewDidAppear(_ animated: Bool) {
        viewDidAppearCallsCount += 1
        viewDidAppearReceivedAnimated = animated
        viewDidAppearClosure?(animated)
    }

    //MARK: - viewWillDisappear

    var viewWillDisappearCallsCount = 0
    var viewWillDisappearCalled: Bool {
        return viewWillDisappearCallsCount > 0
    }
    var viewWillDisappearReceivedAnimated: Bool?
    var viewWillDisappearClosure: ((Bool) -> Void)?

    func viewWillDisappear(_ animated: Bool) {
        viewWillDisappearCallsCount += 1
        viewWillDisappearReceivedAnimated = animated
        viewWillDisappearClosure?(animated)
    }

    //MARK: - viewDidDisappear

    var viewDidDisappearCallsCount = 0
    var viewDidDisappearCalled: Bool {
        return viewDidDisappearCallsCount > 0
    }
    var viewDidDisappearReceivedAnimated: Bool?
    var viewDidDisappearClosure: ((Bool) -> Void)?

    func viewDidDisappear(_ animated: Bool) {
        viewDidDisappearCallsCount += 1
        viewDidDisappearReceivedAnimated = animated
        viewDidDisappearClosure?(animated)
    }

}
class TeamMembersViewProtocolMock: TeamMembersViewProtocol {
    var tableView: UITableView?

    //MARK: - viewDidLoad

    var viewDidLoadCallsCount = 0
    var viewDidLoadCalled: Bool {
        return viewDidLoadCallsCount > 0
    }
    var viewDidLoadClosure: (() -> Void)?

    func viewDidLoad() {
        viewDidLoadCallsCount += 1
        viewDidLoadClosure?()
    }

    //MARK: - viewWillAppear

    var viewWillAppearCallsCount = 0
    var viewWillAppearCalled: Bool {
        return viewWillAppearCallsCount > 0
    }
    var viewWillAppearReceivedAnimated: Bool?
    var viewWillAppearClosure: ((Bool) -> Void)?

    func viewWillAppear(_ animated: Bool) {
        viewWillAppearCallsCount += 1
        viewWillAppearReceivedAnimated = animated
        viewWillAppearClosure?(animated)
    }

    //MARK: - viewDidAppear

    var viewDidAppearCallsCount = 0
    var viewDidAppearCalled: Bool {
        return viewDidAppearCallsCount > 0
    }
    var viewDidAppearReceivedAnimated: Bool?
    var viewDidAppearClosure: ((Bool) -> Void)?

    func viewDidAppear(_ animated: Bool) {
        viewDidAppearCallsCount += 1
        viewDidAppearReceivedAnimated = animated
        viewDidAppearClosure?(animated)
    }

    //MARK: - viewWillDisappear

    var viewWillDisappearCallsCount = 0
    var viewWillDisappearCalled: Bool {
        return viewWillDisappearCallsCount > 0
    }
    var viewWillDisappearReceivedAnimated: Bool?
    var viewWillDisappearClosure: ((Bool) -> Void)?

    func viewWillDisappear(_ animated: Bool) {
        viewWillDisappearCallsCount += 1
        viewWillDisappearReceivedAnimated = animated
        viewWillDisappearClosure?(animated)
    }

    //MARK: - viewDidDisappear

    var viewDidDisappearCallsCount = 0
    var viewDidDisappearCalled: Bool {
        return viewDidDisappearCallsCount > 0
    }
    var viewDidDisappearReceivedAnimated: Bool?
    var viewDidDisappearClosure: ((Bool) -> Void)?

    func viewDidDisappear(_ animated: Bool) {
        viewDidDisappearCallsCount += 1
        viewDidDisappearReceivedAnimated = animated
        viewDidDisappearClosure?(animated)
    }

}
