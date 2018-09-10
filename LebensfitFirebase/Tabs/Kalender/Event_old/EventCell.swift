//
//  EventCell.swift
//  LebensfitFirebase
//
//  Created by Leon on 06.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

enum currentStatus {
    case small
    case expanded
}

class EventCell: UICollectionViewCell, ReusableView {
    //MARK: - Properties & Variables
    class var smallHeight: CGFloat  { get { return 80  } }
    class var expandedHeight: CGFloat { get { return 200 } }

    
    //MARK: - GUI Objects
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Titel"
         label.textColor = .black
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Beschreibung"
        label.textColor = .black
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.text = "11:00 bis 14:00"
        label.textColor = .gray
        return label
    }()
    
    let checkIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "check")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var smallView: UIView = {
        let sview = UIView()
        return sview
    }()
    
    let smallViewDividerView: UIView = {
        let tdv = UIView()
        tdv.backgroundColor = UIColor.lightGray
        return tdv
    }()
    
    lazy var additionalView: UIView = {
        let aview = UIView()
        aview.backgroundColor = UIColor.rgb(0, 0, 0, 0.1)
        return aview
    }()
    
    let buttonDividerView: UIView = {
        let tdv = UIView()
        tdv.backgroundColor = UIColor.lightGray
        return tdv
    }()
    
    let participateButton: UIButton = {
        let button = UIButton()
        //button.backgroundColor = .gray
        button.setTitle("Teilnehmen", for: .normal)
        button.setTitleColor(CalendarSettings.Colors.darkRed, for: .normal)
        return button
    }()
    
    //MARK: - Init & View Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init")
        self.backgroundColor=UIColor.clear
        self.layer.borderColor = EventSettings.Style.borderColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 5
        setupViewsSmall()
        confBoundsSmall()
    }
    
    
    //MARK: - Setup
    //MARK: - Small View
    func setupViewsSmall() {
        addSubview(smallView)
        addSubview(titleLabel)
        addSubview(descLabel)
        addSubview(timeLabel)
    }
    
    func confBoundsSmall(){
        smallView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: EventCell.smallHeight)
        titleLabel.anchor(top: smallView.topAnchor, left: smallView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        descLabel.anchor(top: nil, left: smallView.leftAnchor, bottom: smallView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 10, paddingRight: 0, width: 0, height: 0)
        timeLabel.anchor(top: nil, left: nil, bottom: descLabel.bottomAnchor, right: smallView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -3, paddingRight: 10, width: 0, height: 0)
    }
    
    //MARK: - Expanded View
    func setupViewsExpanded() {
        addSubview(participateButton)
        addSubview(buttonDividerView)
        addSubview(additionalView)
        addSubview(smallViewDividerView)
        smallViewDividerView.anchor(top: smallView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        participateButton.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        buttonDividerView.anchor(top: nil, left: leftAnchor, bottom: participateButton.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        additionalView.anchor(top: smallViewDividerView.bottomAnchor, left: leftAnchor, bottom: buttonDividerView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    //MARK: - Methods
    func changeToExpanded() {
        EventSettings.Style.cellExpanded()
        self.layer.borderColor = EventSettings.Style.borderColor
        setupViewsExpanded()
    }
    
    func changeToSmall() {
        EventSettings.Style.cellSmall()
        self.layer.borderColor = EventSettings.Style.borderColor
        willRemoveSubview(participateButton)
        willRemoveSubview(buttonDividerView)
        willRemoveSubview(additionalView)
        willRemoveSubview(smallViewDividerView)
    
        participateButton.removeFromSuperview()
        buttonDividerView.removeFromSuperview()
        smallViewDividerView.removeFromSuperview()
        additionalView.removeFromSuperview()
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
