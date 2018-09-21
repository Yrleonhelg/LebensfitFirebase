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
    
    func thisDate(value: Int) -> Date{
        return Calendar.current.date(byAdding: .day, value: value, to: noon)!
    }
    
    func formatDateEEEEddMMMyyyy() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_CH")
        formatter.dateFormat = "EEEE, dd. MMM yyyy"
        let result = formatter.string(from: self)
        return result
    }
}
