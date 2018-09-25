//
//  HELG+NSDate.swift
//  LebensfitFirebase
//
//  Created by Leon Helg on 25.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

extension NSDate {
    func getHourAndMinuteAsStringFromDate() -> (String){
        let hour    = Calendar.current.component(.hour, from: self as Date)
        let minutes = Calendar.current.component(.minute, from: self as Date)
        var minutesAsString: String = String(minutes)
        while minutesAsString.count <= 1{
            minutesAsString.insert("0", at: minutesAsString.startIndex)
        }
        let string  = "\(hour):\(minutesAsString)"
        return string
    }
}
