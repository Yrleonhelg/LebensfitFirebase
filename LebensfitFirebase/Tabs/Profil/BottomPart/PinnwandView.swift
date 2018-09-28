//
//  PinnwandView.swift
//  LebensfitFirebase
//
//  Created by Leon Helg on 17.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

@objc protocol pinnwandToSV: Any {
    //@objc func handleKeyboardNotification(notification: NSNotification)
    //func scrollViewUp()
}

class PinnwandView: UIView {
    var heightOfLabelIsZero = NSLayoutConstraint()
    var heightOfPinnwandIsZero = NSLayoutConstraint()
    var heightOftextField = NSLayoutConstraint()
    
    var textFieldBottomConstraint = NSLayoutConstraint()
    var tabbarHeight: CGFloat?
    
    let padding: CGFloat = 20
    
    let textfieldHeight: CGFloat = 40
    var delegate: pinnwandToSV?
    
    //MARK: - GUI Objects
    let ueberMich: UILabel = {
        let label       = UILabel()
        label.font      = UIFont.systemFont(ofSize: 20)
        label.text      = "Über Leon Helg:"
        label.textColor = LebensfitSettings.Colors.basicTextColor
        label.sizeToFit()
        //label.clipsToBounds = true //not possible bc bounds-height = 0
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
        let textfield                       = UITextField()
        textfield.placeholder               = "Enter text here"
        textfield.font                      = UIFont.systemFont(ofSize: 15)
        textfield.borderStyle               = UITextField.BorderStyle.roundedRect
        textfield.autocorrectionType        = UITextAutocorrectionType.no
        textfield.keyboardType              = UIKeyboardType.default
        textfield.returnKeyType             = UIReturnKeyType.done
        textfield.clearButtonMode           = UITextField.ViewMode.whileEditing;
        textfield.contentVerticalAlignment  = UIControl.ContentVerticalAlignment.center
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.sizeToFit()
        //textfield.clipsToBounds = true
        return textfield
    }()
    
    //MARK: - Init & View Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        heightOfLabelIsZero = ueberMich.heightAnchor.constraint(equalToConstant: 0)
        heightOfPinnwandIsZero = pinnwandLabel.heightAnchor.constraint(equalToConstant: 0)
        heightOftextField = textField.heightAnchor.constraint(equalToConstant: textfieldHeight)
        heightOftextField.isActive = true
        
        textField.delegate = self
        fillPinnwand()
        setupViews()
        setupKeyboard()
        confBounds()
        setHeightToZero()
    }
    
    func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            self.layoutIfNeeded()
            textFieldBottomConstraint.constant = -keyboardFrame.height + (tabbarHeight ?? 44) + padding
            self.layoutIfNeeded()
             
        }
    }
    
    func fillPinnwand() {
        pinnwandLabel.text = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt."
    }
    
    //MARK: - Setup Methods
    func setupViews() {
        addSubview(ueberMich)
        addSubview(pinnwandLabel)
        addSubview(textField)
    }
    
    func confBounds() {
        ueberMich.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
        textField.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
        pinnwandLabel.anchor(top: ueberMich.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: padding, paddingBottom: padding, paddingRight: padding, width: 0, height: 0)
        textFieldBottomConstraint = textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        textFieldBottomConstraint.isActive = true
    }
    
    func setHeightToZero() {
        heightOfLabelIsZero.isActive = true
        heightOfPinnwandIsZero.isActive = true
        heightOftextField.constant = 0
    }
    
    func resetHeight() {
        heightOfLabelIsZero.isActive = false
        heightOfPinnwandIsZero.isActive = false
        heightOftextField.constant = textfieldHeight
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PinnwandView: UITextFieldDelegate {
    
}
