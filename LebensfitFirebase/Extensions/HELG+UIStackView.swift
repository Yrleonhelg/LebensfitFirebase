//
//  HELG+UIStackView.swift
//  LebensfitFirebase
//
//  Created by Leon Helg on 30.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

extension UIStackView {
    
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
    
}
