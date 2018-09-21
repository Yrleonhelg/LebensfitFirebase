//
//  EventScrollView.swift
//  LebensfitFirebase
//
//  Created by Leon on 21.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class EventScrollView: UIScrollView {
    
    //MARK: - Properties & Variables
    
    //MARK: - GUI Objects
    
    //MARK: - Init & View Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupViews()
        confBounds()
    }
    
    //MARK: - Setup
    func setupViews() {
        //TODO:
    }
    
    func confBounds(){
        //TODO:
    }
    
    //MARK: - Methods
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
