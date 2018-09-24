//
//  WeekDayEvent.swift
//  LebensfitFirebase
//
//  Created by Leon Helg on 09.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class EventTableCell: UITableViewCell, ReusableView {
    var eventId: Int32?
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
        label.text      = "11:00 bis 14:00"
        label.textColor = .white
        return label
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
    }
    
    func confBounds(){
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: padding, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        timeLabel.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
    }
    
    //MARK: - Methods

    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
