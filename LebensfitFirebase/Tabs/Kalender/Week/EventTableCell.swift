//
//  WeekDayEvent.swift
//  LebensfitFirebase
//
//  Created by Leon Helg on 09.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class EventTableCell: UITableViewCell, ReusableView {
    
    //MARK: - GUI Objects
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Titel"
        label.textColor = .black
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "11:00 bis 14:00"
        label.textColor = .gray
        return label
    }()
    
    let bottomDividerView: UIView = {
        let tdv = UIView()
        tdv.backgroundColor = UIColor.lightGray
        return tdv
    }()
    
    //MARK: - Init & View Loading
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        bottomDividerView.anchor(top: bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0.25)
        timeLabel.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
    }
    
    //MARK: - Methods
    func isLastMethod(last: Bool) {
        bottomDividerView.removeFromSuperview()
        addSubview(bottomDividerView)
        
        if last {
            bottomDividerView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.25)
        } else {
            bottomDividerView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0.25)
        }
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
