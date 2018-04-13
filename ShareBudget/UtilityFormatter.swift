//
//  UtilityFormatter.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 12.02.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class UtilityFormatter: NSObject {
    class var expenseCreationFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        
        return dateFormatter
    }
    
    class var yearMonthFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MMMM"
        
        return dateFormatter
    }
    
    class var expenseFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        return dateFormatter
    }
    
    class var priceEditFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = false
        
        return formatter
    }
    
    class var priceFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        return formatter
    }
    
    class var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }
    
    class var iso8601DateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale as Locale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        return dateFormatter
    }
    
    class var pareseDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale as Locale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return dateFormatter
    }
    
    static let dateComponentsUnits = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second, .nanosecond])
    
    class func roundToTwoSeconds(date: Date) -> Date? {
        let roundedStr = self.pareseDateFormatter.string(from: date)
        
        return self.pareseDateFormatter.date(from: roundedStr)
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
    
    class func calendarComponentTilDay(date: Date = Date()) -> DateComponents {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents(UtilityFormatter.dateComponentsUnits, from: date)
        dateComponents.calendar = calendar
        
        return dateComponents
    }
    
    class func firstMonthDay(date: Date = Date()) -> Date {
        var dateComponents = calendarComponentTilDay(date: date)
        dateComponents.day = 1
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        
        return dateComponents.date!
    }
    
    class func lastMonthDay(date: Date = Date()) -> Date {
        let calendar = Calendar.current
        let days = calendar.range(of: Calendar.Component.day, in: Calendar.Component.month, for: date)
        
        var dateComponents = calendarComponentTilDay(date: date)
        dateComponents.day = days!.count
        dateComponents.hour = 23
        dateComponents.minute = 59
        dateComponents.second = 59
        
        return dateComponents.date!
    }
}
