//
//  KeyboardProtocol.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 13.05.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

@objc protocol KeyBoardProtocol {
    @objc func keyboardWillShow(notification: NSNotification)
    @objc func keyboardWillHide(notification: NSNotification)
}

extension KeyBoardProtocol {
    func keyboardHeight(from notification: NSNotification) -> Double {
        guard let info = notification.userInfo else {
            return 0.0
        }
            
        guard let kbSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return 0.0
        }
            
        return Double(kbSize.height)
    }
    
    func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}
