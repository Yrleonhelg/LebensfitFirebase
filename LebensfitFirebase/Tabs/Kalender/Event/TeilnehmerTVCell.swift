//
//  TeilnehmerTVCell.swift
//  LebensfitFirebase
//
//  Created by Leon on 13.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import Firebase

class TeilnehmerTVCell: UITableViewCell, ReusableView {
    //MARK: - Properties & Variables
    let padding: CGFloat = 20
    var user: User? {
        didSet {
            print("set")
            usernameLabel.text = user?.username
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
            if user?.uid == Auth.auth().currentUser?.uid {
                usernameLabel.textColor = UIColor.green
            }
        }
    }
    
    //MARK: - GUI Objects
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    
    //MARK: - Init & View Loading
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setupViews()
        //confBounds()
    }
    
    
    //MARK: - Setup
    func setupViews() {
        addSubview(profileImageView)
        addSubview(usernameLabel)
    }
    
    func confBounds(){
        let height = self.frame.height
        let pictureHeight = height - 10
        print(self.frame.height)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: padding, paddingBottom: 0, paddingRight: 0, width: pictureHeight, height: pictureHeight)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = pictureHeight / 2
        usernameLabel.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
