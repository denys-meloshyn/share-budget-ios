//
//  UIButton+Listener.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 10.01.2018.
//  Copyright © 2018 Denys Meloshyn. All rights reserved.
//

import UIKit

protocol ButtonListenerProtocol {
}

typealias UIButtonActionBlock = (ButtonListenerProtocol) -> Void

class ButtonListener: UIButton, ButtonListenerProtocol {
    private var touchUpInsideBlock: UIButtonActionBlock?
    
    func addTouchUpInsideListener(completion: UIButtonActionBlock?) {
        addTarget(self, action: #selector(ButtonListener.touchUpInsideAction), for: .touchUpInside)
    }
    
    @objc func touchUpInsideAction() {
        touchUpInsideBlock?(self)
    }
}
