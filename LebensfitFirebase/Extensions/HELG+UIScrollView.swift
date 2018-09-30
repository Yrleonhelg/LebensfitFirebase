//
//  HELG+UIScrollView.swift
//  LebensfitFirebase
//
//  Created by Leon on 25.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

extension UIScrollView {
    func scrollToTop(_ animated: Bool) {
        //let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        let desiredOffset = CGPoint(x: 0, y: -adjustedContentInset.top)
        setContentOffset(desiredOffset, animated: animated)
    }
    
    func scrollToPoint(pointY: CGFloat) {
        let desiredOffset = CGPoint(x: 0, y: pointY)
        setContentOffset(desiredOffset, animated: true)
    }
    
//    func scrollToBottom() {
//        print("safe: ",self.safeAreaLayoutGuide.layoutFrame)
//        print("frame: ",self.frame)
//        print("contentsize: ",self.contentSize.height)
//        print("bounds: ",self.bounds.size.height)
//        print("contentinset: ",self.contentInset.bottom)
//        
//        let safe = self.frame.height - self.safeAreaLayoutGuide.layoutFrame.height
//        //let desiredOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height + self.contentInset.bottom + safe)
//        let desiredOffset = CGPoint(x: 0, y: 356)
//        setContentOffset(desiredOffset, animated: true)
//    }
}
