//
//  UtilityFormatter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 12.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class UtilityFormatter: NSObject {
    class var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }
    
    class var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.roundingMode = .halfUp
        numberFormatter.maximumFractionDigits = 2
        
        return numberFormatter
    }
    
    class func string(from date: Date) -> String {
        return UtilityFormatter.dateFormatter.string(from: date)
    }
    
    class func date(from string: String) -> Date? {
        return UtilityFormatter.dateFormatter.date(from: string)
    }
    
    class func stringAmount(amount: NSNumber) -> String? {
        let numberFormatter = UtilityFormatter.numberFormatter
        
        return numberFormatter.string(from: amount)
    }
    
    class func amount(from string: String) -> NSNumber? {
        return UtilityFormatter.numberFormatter.number(from: string)
    }
    
    class func roundStringDecimalForTwoPlacesToNumber(_ value: NSNumber) -> NSNumber? {
        let formatter = UtilityFormatter.numberFormatter
        guard let formattedNumber = formatter.string(from: value) else {
            return NSNumber(value: 0.0)
        }
        
        return formatter.number(from: formattedNumber)
    }
}
