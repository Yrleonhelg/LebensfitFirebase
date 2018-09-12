//
//  POPMorse.swift
//  LebensfitFirebase
//
//  Created by Leon Helg on 08.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

extension UIView {
//    func pulse() {
//        let animation = CABasicAnimation(keyPath: "pulse")
//        animation.duration = 0.07
//        animation.repeatCount = 2
//        animation.autoreverses = true
//        let point = CGPoint(x: self.center.x, y: self.center.y)
//        let divSize: CGFloat = 3
//
//        let startSize = CGSize(width: self.frame.width, height: self.frame.height)
//        let startRect = CGRect(origin: point, size: startSize)
//
//        let endSize = CGSize(width: startSize.width / divSize, height: startSize.height / divSize)
//        let endRect = CGRect(origin: point, size: endSize)
//
//        animation.fromValue = NSValue(cgRect: startRect)
//        animation.toValue = NSValue(cgRect: endRect)
//        self.layer.add(animation, forKey: "position")
//    }
    
    func pulse() {

        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.2
        animation.duration = 0.8
        animation.repeatCount = 2
        animation.autoreverses = true
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        //animation.repeatCount = Float.infinity
        
        self.layer.add(animation, forKey: "pulsing")
    }
    

}
