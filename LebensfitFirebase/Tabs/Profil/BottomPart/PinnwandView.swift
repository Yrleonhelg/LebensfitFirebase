//
//  PinnwandView.swift
//  LebensfitFirebase
//
//  Created by Leon Helg on 17.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class PinnwandView: UIView, UITextFieldDelegate {
    var heightOfLabelIsZero = NSLayoutConstraint()
    var heightOfPinnwandIsZero = NSLayoutConstraint()
    var heightOftextFieldIsZero = NSLayoutConstraint()
    
    //MARK: - GUI Objects
    let ueberMich: UILabel = {
        let label       = UILabel()
        label.font      = UIFont.systemFont(ofSize: 20)
        label.text      = "Über Leon Helg:"
        label.textColor = LebensfitSettings.Colors.basicTextColor
        label.sizeToFit()
        //label.clipsToBounds = true
        return label
    }()
    
    let pinnwandLabel: UILabel = {
        let label           = UILabel()
        label.font          = UIFont.systemFont(ofSize: 16)
        label.text          = "Cooler Typ, - Umur Hackerman"
        label.textColor     = LebensfitSettings.Colors.NITextColor
        label.numberOfLines = 0
        label.sizeToFit()
        //label.clipsToBounds = true
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
        //textfield.clipsToBounds = true
        //textfield.delegate = self
        return textfield
    }()
    
    //MARK: - Init & View Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        heightOfLabelIsZero = ueberMich.heightAnchor.constraint(equalToConstant: 0)
        heightOfPinnwandIsZero = pinnwandLabel.heightAnchor.constraint(equalToConstant: 0)
        heightOftextFieldIsZero = textField.heightAnchor.constraint(equalToConstant: 0)
        
        fillPinnwand()
        setupViews()
        confBounds()
        setHeightToZero()
    }
    
    func fillPinnwand() {
        pinnwandLabel.text = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,"
    }
    
    //MARK: - Setup Methods
    func setupViews() {
        addSubview(ueberMich)
        addSubview(pinnwandLabel)
        addSubview(textField)
    }
    
    func confBounds() {
        ueberMich.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        textField.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 0)
        pinnwandLabel.anchor(top: ueberMich.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 0)
    }
    
    func setHeightToZero() {
        heightOfLabelIsZero.isActive = true
        heightOfPinnwandIsZero.isActive = true
        heightOftextFieldIsZero.isActive = true
    }
    
    func resetHeight() {
        heightOfLabelIsZero.isActive = false
        heightOfPinnwandIsZero.isActive = false
        heightOftextFieldIsZero.isActive = false
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

