//
//  DateCell.swift
//  LebensfitFirebase
//
//  Created by Leon on 05.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class DateCell: UICollectionViewCell, ReusableView {
    
    //MARK: - GUI Objects
    let lbl: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font=UIFont.systemFont(ofSize: 16)
        label.textColor=CalendarSettings.Colors.darkGray
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    //MARK: - Init & View Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor=UIColor.clear
        layer.cornerRadius=5
        layer.masksToBounds=true
        setupViews()
        confBounds()
    }
    
    //MARK: - Setup
    func setupViews() {
        addSubview(lbl)
    }
    
    func confBounds(){
        lbl.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
