//
//  WeekdayView.swift
//  LebensfitFirebase
//
//  Created by Leon on 05.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class WeekdayView: UIView {
    
    //MARK: - GUI Objects
    let dayOfTheWeekStackView: UIStackView = {
        let stackview          = UIStackView()
        stackview.distribution = .fillEqually
        return stackview
    }()
    
    //MARK: - Init & View Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = LebensfitSettings.Colors.basicBackColor
        setupViews()
        confBounds()
        setupValues()
    }
    
    //MARK: - Setup
    func setupViews() {
        addSubview(dayOfTheWeekStackView)
    }
    
    func confBounds(){
        dayOfTheWeekStackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func setupValues() {
        var daysArr = ["So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"]
        for i in 0..<7 {
            let lbl             = UILabel()
            lbl.text            = daysArr[i]
            lbl.textAlignment   = .center
            lbl.textColor       = LebensfitSettings.Calendar.Style.weekdaysLblColor
            dayOfTheWeekStackView.addArrangedSubview(lbl)
        }
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
