//
//  CalendarSettings.swift
//  LebensfitFirebase
//
//  Created by Leon on 05.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

struct CalendarSettings {
    struct Colors {
        static var darkGray = #colorLiteral(red: 0.3764705882, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
        static var darkRed = #colorLiteral(red: 0.5019607843, green: 0.1529411765, blue: 0.1764705882, alpha: 1)
        static var disabled = UIColor.gray
    }
    
    struct Style {
        static var bgColor = UIColor.white
        static var monthViewLblColor = UIColor.black
        static var monthViewBtnRightColor = UIColor.black
        static var monthViewBtnLeftColor = UIColor.black
        static var activeCellLblColor = UIColor.black
        static var activeCellLblColorHighlighted = UIColor.white
        static var weekdaysLblColor = UIColor.black
        
        static func themeDark(){
            bgColor = Colors.darkGray
            monthViewLblColor = UIColor.white
            monthViewBtnRightColor = UIColor.white
            monthViewBtnLeftColor = UIColor.white
            activeCellLblColor = UIColor.white
            activeCellLblColorHighlighted = UIColor.black
            weekdaysLblColor = UIColor.white
        }
        
        static func themeLight(){
            bgColor = UIColor.white
            monthViewLblColor = UIColor.black
            monthViewBtnRightColor = UIColor.black
            monthViewBtnLeftColor = UIColor.black
            activeCellLblColor = UIColor.black
            activeCellLblColorHighlighted = UIColor.white
            weekdaysLblColor = UIColor.black
        }
    }
}
