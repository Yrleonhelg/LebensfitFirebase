//
//  HELG+UIScrollView.swift
//  LebensfitFirebase
//
//  Created by Leon on 25.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

extension UIScrollView {
    func scrollToTop() {
        
        //let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        let desiredOffset = CGPoint(x: 0, y: -adjustedContentInset.top)
        setContentOffset(desiredOffset, animated: true)
        
    }
}
