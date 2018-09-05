//
//  HELG+UIColor.swift
//  helgcreating
//
//  Created by testbenutzer on 13.08.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func rgb(_ red: CGFloat,_ green: CGFloat,_ blue: CGFloat,_ alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}
