//
//  DatePicker.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 14.01.2018.
//  Copyright © 2018 Denys Meloshyn. All rights reserved.
//

import UIKit

typealias DatePickerActionBlock = (DatePicker) -> Void

class DatePicker: UIDatePicker {
    private var valueChangedBlock: DatePickerActionBlock?

    func addValueChangedListener(completion: DatePickerActionBlock?) {
        valueChangedBlock = completion
        addTarget(self, action: #selector(DatePicker.valueChangedAction), for: .valueChanged)
    }

    @objc func valueChangedAction() {
        valueChangedBlock?(self)
    }
}
