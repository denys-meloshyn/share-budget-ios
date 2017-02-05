//
//  BudgetDetailPresenter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 03.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

protocol BudgetDetailPresenterDelegate: class {
    
}

class BudgetDetailPresenter: BasePresenter {
    weak var delegate: BudgetDetailPresenterDelegate?
    fileprivate var budgetDetailInteraction: BudgetDetailInteraction {
        get {
            return self.interaction as! BudgetDetailInteraction
        }
    }

}
