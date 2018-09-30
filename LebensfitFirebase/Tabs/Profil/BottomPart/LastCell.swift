//
//  LastCell.swift
//  LebensfitFirebase
//
//  Created by Leon on 28.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import Firebase

class LastCell: UITableViewCell, ReusableView {
    //MARK: - Properties & Variables
    //MARK: - GUI Objects
    let createNewPinLabel: UILabel = {
        let label   = UILabel()
        label.text  = "Neuen Pin erstellen"
        label.font  = UIFont.systemFont(ofSize: 25)
        label.numberOfLines = 2
        return label
    }()
    
    let chevronLabel: UILabel = {
        let label       = UILabel()
        label.textColor = .black
        label.text      = "›"
        label.font      = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()

    //MARK: - Init & View Loading
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setupViews()
    }
    
    //MARK: - Setup
    func setupViews() {
        addSubview(createNewPinLabel)
        addSubview(chevronLabel)
        chevronLabel.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        chevronLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        createNewPinLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: chevronLabel.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        createNewPinLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
