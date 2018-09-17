//
//  PinnwandView.swift
//  LebensfitFirebase
//
//  Created by Leon Helg on 17.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class PinnwandView: UIView {
    
    //MARK: - GUI Objects
    let ueberMich: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Über Leon Helg:"
        label.textColor = .white
        return label
    }()
    
    let steckbriefLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Cooler Typ, - Umur Hackerman"
        label.textColor = UIColor.gray
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Init & View Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        confBounds()
    }
    
    //MARK: - Setup Methods
    func setupViews() {
        addSubview(ueberMich)
        addSubview(steckbriefLabel)
    }
    
    func confBounds() {
        ueberMich.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        steckbriefLabel.anchor(top: ueberMich.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

