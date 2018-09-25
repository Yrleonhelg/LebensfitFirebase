//
//  HELG+Date.swift
//  LebensfitFirebase
//
//  Created by Leon Helg on 09.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
    
    func addDaysToToday(amount: Int) -> Date{
        return Calendar.current.date(byAdding: .day, value: amount, to: noon)!
    }
    
    func formatDateEEEEddMMMyyyy() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_CH")
        formatter.dateFormat = "EEEE, dd. MMM yyyy"
        let result = formatter.string(from: self)
        return result
    }
    
    func formatDateddMMMyyyy() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_CH")
        formatter.dateFormat = "dd. MMM yyyy"
        let result = formatter.string(from: self)
        return result
    }
    
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
    
    func getHourAndMinuteAsStringFromDate() -> (String){
        let hour    = Calendar.current.component(.hour, from: self)
        let minutes = Calendar.current.component(.minute, from: self)
        var minutesAsString: String = String(minutes)
        while minutesAsString.count <= 1{
            minutesAsString.insert("0", at: minutesAsString.startIndex)
        }
        let string  = "\(hour):\(minutesAsString)"
        return string
    }
}
