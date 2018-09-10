//
//  POPShakeable.swift
//  LebensfitFirebase
//
//  Created by Leon on 07.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

protocol Shakeable {
    
}

extension Shakeable where Self: UIView {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}
