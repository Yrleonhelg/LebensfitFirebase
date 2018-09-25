//
//  HELG+String.swift
//  LebensfitFirebase
//
//  Created by Leon Helg on 25.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

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
