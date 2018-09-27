//
//  PinnwandView.swift
//  LebensfitFirebase
//
//  Created by Leon Helg on 17.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class PinnwandView: UIView, UITextFieldDelegate {
    var heightOfLabel = NSLayoutConstraint()
    var heightOfPinnwand = NSLayoutConstraint()
    var heightOftextField = NSLayoutConstraint()
    
    //MARK: - GUI Objects
    let ueberMich: UILabel = {
        let label       = UILabel()
        label.font      = UIFont.systemFont(ofSize: 20)
        label.text      = "Über Leon Helg:"
        label.textColor = LebensfitSettings.Colors.basicTextColor
        label.sizeToFit()
        return label
    }()
    
    let pinnwandLabel: UILabel = {
        let label           = UILabel()
        label.font          = UIFont.systemFont(ofSize: 16)
        label.text          = "Cooler Typ, - Umur Hackerman"
        label.textColor     = LebensfitSettings.Colors.NITextColor
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    let textField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter text here"
        textfield.font = UIFont.systemFont(ofSize: 15)
        textfield.borderStyle = UITextField.BorderStyle.roundedRect
        textfield.autocorrectionType = UITextAutocorrectionType.no
        textfield.keyboardType = UIKeyboardType.default
        textfield.returnKeyType = UIReturnKeyType.done
        textfield.clearButtonMode = UITextField.ViewMode.whileEditing;
        textfield.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textfield.sizeToFit()
        //textfield.delegate = self
        return textfield
    }()
    
    //MARK: - Init & View Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        heightOfLabel = ueberMich.heightAnchor.constraint(equalToConstant: 0)
        heightOfPinnwand = pinnwandLabel.heightAnchor.constraint(equalToConstant: 0)
        heightOftextField = textField.heightAnchor.constraint(equalToConstant: 0)
        setupViews()
        confBounds()
        setHeightToZero()
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.borderWidth = 1
    }
    
    //MARK: - Setup Methods
    func setupViews() {
        addSubview(ueberMich)
        addSubview(pinnwandLabel)
        addSubview(textField)
    }
    
    func confBounds() {
        ueberMich.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        textField.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        pinnwandLabel.anchor(top: ueberMich.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: 0, height: 0)
    }
    
    func setHeightToZero() {
        heightOfLabel.isActive = true
        heightOfPinnwand.isActive = true
        heightOftextField.isActive = true
    }
    
    func resetHeight() {
        heightOfLabel.isActive = false
        heightOfPinnwand.isActive = false
        heightOftextField.isActive = false
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

