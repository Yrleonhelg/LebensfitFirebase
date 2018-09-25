//
//  HELG+Int.swift
//  LebensfitFirebase
//
//  Created by Leon Helg on 25.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

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
    
    //month index should go from 0-11 instead of 1-12
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
        return month
    }
}
