//
//  BaseCell.swift
//  PilatesTest
//
//  Created by Leon on 28.08.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        confBounds()
    }
    
    func setupViews() {
        
    }
    
    func confBounds(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
