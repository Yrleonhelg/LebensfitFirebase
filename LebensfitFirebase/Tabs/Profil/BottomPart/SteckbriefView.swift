//
//  SteckbriefView.swift
//  LebensfitFirebase
//
//  Created by Leon Helg on 17.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class SteckbriefView: UIView {
    
    //MARK: - GUI Objects
    let ueberMich: UILabel = {
        let label       = UILabel()
        label.font      = UIFont.systemFont(ofSize: 20)
        label.text      = "Über mich:"
        label.textColor = LebensfitSettings.Colors.basicTextColor
        return label
    }()
    
    let steckbriefLabel: UILabel = {
        let label           = UILabel()
        label.font          = UIFont.systemFont(ofSize: 16)
        label.text          = "Ich heisse Leon und bin 19 Jahre alt. \nIn meiner Freizeit programmiere ich gerne iOS Apps. \nIch wohne in Frauenfeld in der Nähe der Kantonsschule"
        label.textColor     = LebensfitSettings.Colors.NITextColor
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
