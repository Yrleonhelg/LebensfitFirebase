//
//  WeekDayEvent.swift
//  LebensfitFirebase
//
//  Created by Leon Helg on 09.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class EventTableCell: UITableViewCell, ReusableView {
    let padding: CGFloat = 20
    
    //MARK: - GUI Objects
    let titleLabel: UILabel = {
        let label       = UILabel()
        label.font      = UIFont.systemFont(ofSize: 20)
        label.text      = "Titel"
        label.textColor = .white
        return label
    }()
    
    let timeLabel: UILabel = {
        let label       = UILabel()
        label.font      = UIFont.systemFont(ofSize: 20)
        label.text      = "00:00 bis 00:00"
        label.textColor = .white
        return label
    }()
    
    let bottomDividerView: UIView = {
        let view             = UIView()
        view.backgroundColor = LebensfitSettings.Colors.basicBackColor
        return view
    }()
    
    //MARK: - Init & View Loading
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = LebensfitSettings.Colors.basicTintColor
        setupViews()
        confBounds()
    }
    
    //MARK: - Setup
    func setupViews() {
        addSubview(titleLabel)
        addSubview(timeLabel)
        addSubview(bottomDividerView)
    }
    
    func confBounds(){
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: padding, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        timeLabel.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
        bottomDividerView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: padding, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }

    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
