//
//  ButtonStackView.swift
//  LebensfitFirebase
//
//  Created by Leon Helg on 30.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

protocol participateButtonStackViewDelegate {
    func removeFromAllParticipantsList()
    func addUserToList(list: participateLists)
}

//MARK: FOR_STACKOVERFLOW

class ParticipateButton: UIButton {
    
    var typeOfButton: participateLists!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor  = LebensfitSettings.Colors.buttonBG
        self.tintColor        = LebensfitSettings.Colors.basicTintColor
        self.imageView?.contentMode = .scaleAspectFit
        self.contentEdgeInsets = UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 0)
    }
    
    convenience init(type: participateLists) {
        self.init()
        self.typeOfButton = type
        setImage(type: type)
    }
    
    func setImage(type: participateLists) {
        var buttonImage: UIImage?
        switch type {
        case .sure:
            buttonImage = UIImage(named: "pb_sure")?.withRenderingMode(.alwaysTemplate)
        case .maybe:
            buttonImage = UIImage(named: "pb_maybe")?.withRenderingMode(.alwaysTemplate)
        case .nope:
            buttonImage = UIImage(named: "pb_nope")?.withRenderingMode(.alwaysTemplate)
        }
        self.setImage(buttonImage, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ParticipateButtonStackView: UIStackView {
    //MARK: - Properties & Variables
    var delegate: participateButtonStackViewDelegate?
    
    //MARK: - GUI Objects
    var buttons: [ParticipateButton]!
    let sureButton = ParticipateButton(type: .sure)
    let maybeButton = ParticipateButton(type: .maybe)
    let nopeButton = ParticipateButton(type: .nope)
    
    //MARK: - Init & View Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addBackground(color: UIColor.gray)
        buttons = [sureButton, maybeButton, nopeButton]
        setupStackView()
        setupButtons()
    }
    
    //MARK: - Setup
    func setupStackView() {
        self.axis           = .horizontal
        self.spacing        = 0
        self.alignment      = .leading
        self.distribution   = .fillEqually
    }
    
    func setupButtons() {
        for button in buttons {
            addArrangedSubview(button)
            button.addTarget(self, action: #selector (self.buttonClick(sender:)), for: .touchUpInside)
        }
    }
    
    //MARK: - Methods
    @objc func buttonClick(sender: ParticipateButton) {
        let selected = !sender.isSelected
        print(sender.typeOfButton)
        deselectAllButtons()
        delegate?.removeFromAllParticipantsList()
        selectButton(button: sender, selected: selected)
        if selected {
            delegate?.addUserToList(list: sender.typeOfButton)
        }
    }
    
    func deselectAllButtons() {
        for button in buttons {
            button.backgroundColor      = LebensfitSettings.Colors.buttonBG
            button.imageView?.tintColor = LebensfitSettings.Colors.basicTintColor
            button.isSelected           = false
        }
    }
    
    func selectButton(button: UIButton, selected: Bool) {
        if selected {
            button.backgroundColor      = LebensfitSettings.Colors.basicTintColor
            button.imageView?.tintColor = .white
            button.isSelected           = true
        } else {
            button.backgroundColor      = .white
            button.imageView?.tintColor = LebensfitSettings.Colors.basicTintColor
            button.isSelected           = false
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

