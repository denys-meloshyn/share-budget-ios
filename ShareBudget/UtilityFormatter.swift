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
    
    class var iso8601DateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale as Locale!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        return dateFormatter
    }
    
    class func iso8601Date(from date: String) -> Date? {
        return self.iso8601DateFormatter.date(from: date)
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
    
    class func firstMonthDay() -> Date {
        let calendar = Calendar.current
        let units = Set<Calendar.Component>([.year, .month, .day])
        
        var dateComponents = calendar.dateComponents(units, from: Date())
        dateComponents.day = 1
        dateComponents.calendar = calendar
        
        return dateComponents.date!
    }
}
