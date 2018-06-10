//
//  UILabel+HighlightText.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 10.06.2018.
//  Copyright © 2018 Denys Meloshyn. All rights reserved.
//

import UIKit

extension UILabel {
    func highlightAllOrNothing(_ characters: String, color: UIColor) {
        guard let text = text else {
            return
        }

        let rangeEnd = text.endIndex
        let attributedString = NSMutableAttributedString(string: text)
        var lastFoundIndex = 0

        for character in characters {
            let rangeStart = text.index(text.startIndex, offsetBy: lastFoundIndex)

            let rangeStartEnd = rangeStart..<rangeEnd
            if let range = text.range(of: "\(character)", options: .caseInsensitive, range: rangeStartEnd, locale: nil) {
                let nsRange = NSRange(range, in: text)
                lastFoundIndex = nsRange.location + nsRange.length
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: nsRange)
            } else {
                attributedText = NSMutableAttributedString(string: text)
                return
            }
        }

        attributedText = attributedString
    }
}
