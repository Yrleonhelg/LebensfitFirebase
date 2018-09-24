//
//  PILATESSettings.swift
//  PilatesTest
//
//  Created by Leon on 31.08.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

struct LebensfitSettings {
    
    struct Colors {
        static var darkGray = #colorLiteral(red: 0.3764705882, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
        static var darkRed = #colorLiteral(red: 0.5019607843, green: 0.1529411765, blue: 0.1764705882, alpha: 1)
        static var disabled = UIColor.gray
        static var buttonBG = UIColor.rgb(249, 249, 249, 1)
        static var basicBackColor = UIColor.white
        static var basicTextColor = UIColor.black
        static var NITextColor = UIColor.darkGray
        static var basicTintColor = darkRed
    }
    
    struct UI {
        
        struct iconNames {
            static let calendar = "calendar"
            static let home = "home"
            static let shop = "shop75"
            static let profile = "profile"
            static let benutzer = "user75"
            static let map = "map"
            static let menu = "menu"
            
            
            static let calendarS = "calendar_selected"
            static let calendarUS = "calendar_unselected"
            
            static let homeS = "home_selected"
            static let homeUS = "home_unselected"
            
            static let profileS = "profile_selected"
            static let profileUS = "profile_unselected"
            
        }
    }
    
    struct Calendar {
        struct Style {
            static var bgColor                          = UIColor.white
            static var monthViewLblColor                = UIColor.black
            static var monthViewBtnRightColor           = UIColor.black
            static var monthViewBtnLeftColor            = UIColor.black
            static var activeCellLblColor               = UIColor.black
            static var activeCellLblColorHighlighted    = UIColor.white
            static var weekdaysLblColor                 = UIColor.black
        }
    }
}
