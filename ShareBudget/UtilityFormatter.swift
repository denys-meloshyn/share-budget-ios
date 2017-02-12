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
        
        return numberFormatter
    }
    
    class func string(from date: Date) -> String {
        return self.dateFormatter.string(from: date)
    }
    
    class func date(from string: String) -> Date? {
        return self.dateFormatter.date(from: string)
    }
    
    class func stringAmount(amount: NSNumber) -> String? {
        let numberFormatter = self.numberFormatter
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        return numberFormatter.string(from: amount)
    }
    
    class func amount(from string: String) -> NSNumber? {
        return self.numberFormatter.number(from: string)
    }
    
    class func amountRoundDecimal(from string: String) -> NSNumber? {
        let numberFormatter = self.numberFormatter
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        return numberFormatter.number(from: string)
    }
}
