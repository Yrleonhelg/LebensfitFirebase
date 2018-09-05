//
//  ReuseableView.swift
//  PilatesTest
//
//  Created by Leon on 28.08.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

protocol ReusableView: class {}

extension ReusableView where Self: UIView{
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

