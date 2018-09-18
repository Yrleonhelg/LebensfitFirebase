//
//  WeekDayHeader.swift
//  LebensfitFirebase
//
//  Created by Leon on 07.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class WeekDayHeader: UITableViewHeaderFooterView, ReusableView, Shakeable {
    //MARK: - Properties & Variables
    var isCurrentDay: Bool  = false
    var isSelected: Bool    = false
    var myDate              = Date()
    let padding: CGFloat    = 20
    
    //MARK: - GUI Objects
    let dayLabel: UILabel = {
        let label       = UILabel()
        label.textColor = .black
        label.font      = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label       = UILabel()
        label.textColor = .gray
        label.text      = "1. Jan. 2018"
        label.font      = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let chevronLabel: UILabel = {
        let label       = UILabel()
        label.textColor = .black
        label.text      = "›"
        label.font      = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let selectionDot: UIView = {
        let sv                  = UIView()
        //sv.frame              = CGRect(x: 0, y: 0, width: 20, height: 20)
        sv.backgroundColor      = CalendarSettings.Colors.darkRed
        sv.layer.cornerRadius   = 7.5
        return sv
    }()
    
    let bottomDividerView: UIView = {
        let tdv             = UIView()
        tdv.backgroundColor = UIColor.lightGray
        return tdv
    }()
    
    //MARK: - Init & View Loading
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundView                     = UIView(frame: self.bounds)
        self.tintColor                          = .white
        self.isUserInteractionEnabled           = true
        setupViews()
        confBoundsDefault()
    }
    
    //MARK: - Setup
     func setupViews() {
        addSubview(dayLabel)
        addSubview(chevronLabel)
        addSubview(dateLabel)
        //addSubview(bottomDividerView)
    }
    
    func removeDot() {
        dayLabel.removeFromSuperview()
        selectionDot.removeFromSuperview()
        addSubview(dayLabel)
        confBoundsDefault()
        
    }
    
     func confBoundsDefault(){

        dayLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        dateLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 10, paddingRight: 0, width: 0, height: 0)
        chevronLabel.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        //bottomDividerView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0.5, paddingRight: 20, width: 0, height: 0.5)

    }
    
    func confBoundsToday() {
        dayLabel.removeFromSuperview()
        addSubview(selectionDot)
        addSubview(dayLabel)
        
        dayLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        selectionDot.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor).isActive = true
        selectionDot.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 15, height: 15)
        //selectionDot.pulse()
    }
    
    func setDate() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_CH")
        formatter.dateFormat = "dd. MMM yyyy"
        
        let result = formatter.string(from: myDate)
        dateLabel.text = result
    }

    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
