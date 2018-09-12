//
//  WeekOverVIew.swift
//  LebensfitFirebase
//
//  Created by Leon on 07.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//


import UIKit

protocol WeekViewDelegate: class {
    func didChangeWeek(week: Int, year: Int)
}

class WeekOverView: UIView {
    //MARK: - Properties & Variables
    var currentYear: Int = 0
    var currentWeek: Int = 0
    var delegate: WeekViewDelegate?
    
    //MARK: - GUI Objects
    let currentWeekLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Default Month / Year"
        lbl.textColor = CalendarSettings.Style.monthViewLblColor
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let nextWeekButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(">", for: .normal)
        btn.setTitleColor(CalendarSettings.Style.monthViewBtnRightColor, for: .normal)
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    let previousWeekButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("<", for: .normal)
        btn.setTitleColor(CalendarSettings.Style.monthViewBtnLeftColor, for: .normal)
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        btn.setTitleColor(CalendarSettings.Colors.disabled, for: .disabled)
        return btn
    }()
    
    //MARK: - Init & View Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        setupViews()
        confBounds()
        
        previousWeekButton.isEnabled=false
        currentYear = Calendar.current.component(.year, from: Date())
        currentWeek = Calendar.current.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
        
        setValues(week: currentWeek, Year: currentYear)
    }
    
    //MARK: - Setup
    func setupViews() {
        addSubview(currentWeekLabel)
        addSubview(previousWeekButton)
        addSubview(nextWeekButton)
    }
    
    func confBounds(){
        currentWeekLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        currentWeekLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 35)
        previousWeekButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 35)
        nextWeekButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 35)
    }
    
    func setValues(week: Int, Year: Int) {
        currentWeekLabel.text = "KW\(currentWeek) \(currentYear)"
    }
    
    //MARK: - Methods
    @objc func btnLeftRightAction(sender: UIButton) {
        
        if sender == nextWeekButton {
            currentWeek += 1
            if currentWeek > 52 {
                currentWeek = 0
                currentYear += 1
            }
        } else {
            currentWeek -= 1
            if currentWeek < 0 {
                currentWeek = 52
                currentYear -= 1
            }
        }
        
        currentWeekLabel.text = "KW\(currentWeek) \(currentYear)"
        delegate?.didChangeWeek(week: currentWeek, year: currentYear)
    }
    
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

