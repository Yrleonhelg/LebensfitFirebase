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
    let stackView: UIStackView = {
        let sv          = UIStackView()
        sv.distribution = .fillEqually
        return sv
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
        addSubview(stackView)
    }
    
    func confBounds(){
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func setupValues() {
        var daysArr = ["So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"]
        for i in 0..<7 {
            let lbl             = UILabel()
            lbl.text            = daysArr[i]
            lbl.textAlignment   = .center
            lbl.textColor       = LebensfitSettings.Calendar.Style.weekdaysLblColor
            stackView.addArrangedSubview(lbl)
        }
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
