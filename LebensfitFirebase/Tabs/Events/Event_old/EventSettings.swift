//
//  EventSettings.swift
//  LebensfitFirebase
//
//  Created by Leon on 06.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

struct EventSettings {
    
    struct Style {
        static var cellHeight: CGFloat = 100
        static var borderColor: CGColor = CalendarSettings.Colors.darkGray.cgColor

        
        static func cellSmall(){
            cellHeight = 100
            borderColor = CalendarSettings.Colors.darkGray.cgColor
        }
        
        static func cellExpanded(){
            cellHeight = 250
            borderColor = CalendarSettings.Colors.darkRed.cgColor
        }
    }
}
