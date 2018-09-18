//
//  CalendarExtensions.swift
//  LebensfitFirebase
//
//  Created by Leon on 05.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

//get first day of the month
extension Date {
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
            minutesAsString.append("0")
        }
        let string  = "\(hour):\(minutesAsString)"
        return string
    }
}

//get date from string
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter           = DateFormatter()
        formatter.dateFormat    = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}

extension Int {
    //Usually Sunday is 1, Monday is 2, Saturday is 7
    var formatedWeekDay: Int {
        var day = self
        if self == 1 {
            day = 6
        } else {
            day -= 2
        }
        //Now Monday is 0 and Sunday is 6
        return day
    }
    
    var formattedMonthIndex: Int {
        var month = self
        if self == 12 {
            month = 0
        } else if self == 0 {
            month = 0
        }
        else {
            month -= 1
        }
//        print("Formatted: ",month)
        return month
    }
}

