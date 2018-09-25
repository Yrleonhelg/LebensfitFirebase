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
    var myDate:     Date        = Date()
    
    
    //MARK: - GUI Objects
    let dayLabel: UILabel = {
        let label           = UILabel()
        label.text          = "00"
        label.textAlignment = .center
        label.font          = UIFont.systemFont(ofSize: 16)
        label.textColor     = LebensfitSettings.Colors.darkGray
        return label
    }()
    
    let selectionView: UIView = {
        let view = UIView()
        return view
    }()
    
    let thereIsAnEventView: UIView = {
        let view = UIView()
        view.backgroundColor = LebensfitSettings.Colors.basicBackColor
        return view
    }()
    
    //MARK: - Init & View Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor     = LebensfitSettings.Colors.basicBackColor
        layer.cornerRadius  = frame.height/2
        layer.masksToBounds = true
    }
    
    //MARK: - Setup
    override func setupViews() {
        addSubview(dayLabel)
        addSubview(selectionView)
        sendSubviewToBack(selectionView)
        addSubview(thereIsAnEventView)
    }
    
    override func confBounds(){
        dayLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        dayLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        selectionView.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: nil, paddingTop: 1, paddingLeft: 0, paddingBottom: 1, paddingRight: 0, width: frame.height-2, height: frame.height-2)
        selectionView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        selectionView.layer.cornerRadius = frame.height / 2 - 1
        
        thereIsAnEventView.anchor(top: dayLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 5, height: 5)
        thereIsAnEventView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        thereIsAnEventView.layer.cornerRadius = 2.5
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
