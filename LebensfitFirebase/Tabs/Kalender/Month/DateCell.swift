//
//  DateCell.swift
//  LebensfitFirebase
//
//  Created by Leon on 05.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class DateCell: BaseCell, ReusableView {
    
    //MARK: - Properties & Variables
    var cellSelected: Bool      = false
    var thisDay:    Int         = 0
    var thisMonth:  Int         = 0
    var thisYear:   Int         = 0
    var myDate:     Date        = Date()
    
    
    //MARK: - GUI Objects
    let dayLabel: UILabel = {
        let label           = UILabel()
        label.text          = "00"
        label.textAlignment = .center
        label.font          = UIFont.systemFont(ofSize: 16)
        label.textColor     = CalendarSettings.Colors.darkGray
        return label
    }()
    
    let selectionView: UIView = {
        let sv = UIView()
        return sv
    }()
    
    //MARK: - Init & View Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor     = UIColor.clear
        layer.cornerRadius  = frame.height/2
        layer.masksToBounds = true
        
    }
    
    //MARK: - Setup
    override func setupViews() {
        addSubview(dayLabel)
        addSubview(selectionView)
        sendSubview(toBack: selectionView)
    }
    
    override func confBounds(){
        dayLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        selectionView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        selectionView.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: nil, paddingTop: 1, paddingLeft: 0, paddingBottom: 1, paddingRight: 0, width: frame.height-2, height: frame.height-2)
        selectionView.layer.cornerRadius = frame.height / 2 - 1
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
