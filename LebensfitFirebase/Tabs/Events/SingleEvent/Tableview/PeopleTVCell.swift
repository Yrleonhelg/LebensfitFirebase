//
//  TeilnehmerTVCell.swift
//  LebensfitFirebase
//
//  Created by Leon on 13.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import Firebase

class UserTVCell: UITableViewCell, ReusableView {
    //MARK: - Properties & Variables
    var user: User? {
        didSet {
            usernameLabel.text          = user?.username
            guard let profileImageUrl   = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl, nil)
            if user?.uid == Auth.auth().currentUser?.uid {
                isCurrentUser()
            }
        }
    }
    
    //MARK: - GUI Objects
    let selectionDot: UIView = {
        let view                  = UIView()
        view.backgroundColor      = LebensfitSettings.Colors.basicTintColor
        view.layer.cornerRadius   = 7.5
        return view
    }()
    
    let profileImageView: CustomImageView = {
        let customview              = CustomImageView()
        customview.contentMode      = .scaleAspectFill
        customview.clipsToBounds    = true
        return customview
    }()
    
    let usernameLabel: UILabel = {
        let label   = UILabel()
        label.text  = "Username"
        label.font  = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    //MARK: - Init & View Loading
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = LebensfitSettings.Colors.basicBackColor
        setupViews()
    }
    
    //MARK: - Setup
    func setupViews() {
        addSubview(profileImageView)
        addSubview(usernameLabel)
    }
    
    //called from rowforsection to provide the correct info from the start
    func confBounds(){
        let frameHeight = self.frame.height
        let pictureHeight = frameHeight - 10
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: pictureHeight, height: pictureHeight)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = pictureHeight / 2
        usernameLabel.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
    }
    
    func isCurrentUser() {
        profileImageView.layer.borderColor = LebensfitSettings.Colors.basicTintColor.cgColor
        profileImageView.layer.borderWidth = 2
        addSubview(selectionDot)
        selectionDot.anchor(top: nil, left: nil, bottom: nil, right: usernameLabel.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 15, height: 15)
        selectionDot.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor).isActive = true
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
