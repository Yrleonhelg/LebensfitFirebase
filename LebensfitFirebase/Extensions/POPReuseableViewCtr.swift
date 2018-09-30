//
//  ReuseableView.swift
//  HelgWeather
//
//  Created by Leon on 27.08.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

protocol ReusableViewCtr: class {}

extension ReusableViewCtr {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
