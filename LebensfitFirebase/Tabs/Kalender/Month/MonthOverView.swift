//
//  MonthView.swift
//  LebensfitFirebase
//
//  Created by Leon on 05.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

protocol MonthViewDelegate: class {
    func didChangeMonth(monthIndex: Int, year: Int)
}

class MonthOverView: UIView {
    //MARK: - Properties & Variables
    var monthsArr           = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var currentMonthIndex   = 0
    var currentYear: Int    = 0
    var delegate: MonthViewDelegate?
    
    //MARK: - GUI Objects
    let currentMonthLabel: UILabel = {
        let lbl             = UILabel()
        lbl.text            = "Default Month / Year"
        lbl.textColor       = LebensfitSettings.Calendar.Style.monthViewLblColor
        lbl.textAlignment   = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    let nextMonthButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(">", for: .normal)
        btn.setTitleColor(LebensfitSettings.Calendar.Style.monthViewBtnRightColor, for: .normal)
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    let previousMonthButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("<", for: .normal)
        btn.setTitleColor(LebensfitSettings.Calendar.Style.monthViewBtnLeftColor, for: .normal)
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        btn.setTitleColor(LebensfitSettings.Colors.disabled, for: .disabled)
        return btn
    }()
    
    //MARK: - Init & View Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = LebensfitSettings.Colors.basicBackColor
        setupViews()
        confBounds()
        setDefaultValues()
    }
    
    //MARK: - Setup
    func setupViews() {
        addSubview(currentMonthLabel)
        addSubview(previousMonthButton)
        addSubview(nextMonthButton)
    }
    
    func confBounds(){
        currentMonthLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive=true
        currentMonthLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 35)
        
        previousMonthButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 35)
        nextMonthButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 35)
    }
    
    func setDefaultValues() {
        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        previousMonthButton.isEnabled=false
        currentMonthLabel.text="\(monthsArr[currentMonthIndex]) \(currentYear)"
    }
    
    //MARK: - Methods
    @objc func btnLeftRightAction(sender: UIButton) {
        if sender == nextMonthButton {
            currentMonthIndex += 1
            if currentMonthIndex > 11 {
                currentMonthIndex = 0
                currentYear += 1
            }
        } else {
            currentMonthIndex -= 1
            if currentMonthIndex < 0 {
                currentMonthIndex = 11
                currentYear -= 1
            }
        }
        currentMonthLabel.text="\(monthsArr[currentMonthIndex]) \(currentYear)"
        delegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

