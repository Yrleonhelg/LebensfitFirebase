//
//  ActivityCell.swift
//  PilatesTest
//
//  Created by Leon on 28.08.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class ActivityCell: BaseCell, ReusableView, CustomAnchor {
    
    //MARK: - GUI Objects
    let colorView: UIImageView = {
        let colview = UIImageView()
        colview.backgroundColor = .red
        colview.clipsToBounds = true
        return colview
    }()
    
    let iconView: UIImageView = {
        let icview = UIImageView()
        icview.contentMode = .scaleAspectFill
        icview.clipsToBounds = true
        return icview
    }()
    
    let activityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.clipsToBounds = true
        label.font = UIFont.boldSystemFont( ofSize: 25)
        label.isUserInteractionEnabled = false
        return label
    }()
    
    //MARK: - Init & View Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = self.bounds.width / 10
        self.clipsToBounds = true
    }
    
    //MARK: - Setup
    override func setupViews() {
        super.setupViews()
        addSubview(colorView)
        addSubview(iconView)
        addSubview(activityLabel)
    }
    
    override func confBounds() {
        super.confBounds()
        colorView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        iconView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 25, paddingRight: 0, width: 0, height: 0)

        activityLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: self.frame.height/10*1.5)
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
