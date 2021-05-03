//
//  UIButton+Listener.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 10.01.2018.
//  Copyright © 2018 Denys Meloshyn. All rights reserved.
//

import UIKit

typealias UIButtonActionBlock = (ButtonListener) -> Void

class ButtonListener: UIButton {
    private var touchUpInsideBlock: UIButtonActionBlock?

    func addTouchUpInsideListener(completion: UIButtonActionBlock?) {
        touchUpInsideBlock = completion
        addTarget(self, action: #selector(ButtonListener.touchUpInsideAction), for: .touchUpInside)
    }

    @objc func touchUpInsideAction() {
        touchUpInsideBlock?(self)
    }
}
