//
//  ProfileHeader.swift
//  LebensfitFirebase
//
//  Created by Leon on 04.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class ProfileHeader: BaseCell, ReusableView{
    
    //MARK: - Properties
    var user: User? {
        didSet {
            setupProfileImage()
        }
    }
    
    //MARK: GUI Objects
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let ownedVideosLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17)])
        attributedText.append(NSAttributedString(string: "Videos", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)]))
        label.attributedText = attributedText
        
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let tokensLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17)])
        attributedText.append(NSAttributedString(string: "Token", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)]))
        label.attributedText = attributedText
        
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    //    let followingLabel: UILabel = {
    //        let label = UILabel()
    //
    //        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
    //        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
    //        label.attributedText = attributedText
    //
    //        label.numberOfLines = 0
    //        label.textAlignment = .center
    //        return label
    //    }()
    
    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        return button
    }()
    
    let topDividerView: UIView = {
        let tdv = UIView()
        tdv.backgroundColor = UIColor.lightGray
        return tdv
    }()
    
    let bottomDividerView: UIView = {
        let bdv = UIView()
        bdv.backgroundColor = UIColor.lightGray
        return bdv
    }()
    
    lazy var controlStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        return sv
    }()
    
    lazy var aboutStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [ownedVideosLabel, tokensLabel])
        sv.distribution = .fillEqually
        return sv
    }()
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    //MARK: - Setup
    override func setupViews() {
        addSubview(profileImageView)
        addSubview(aboutStackView)
        addSubview(controlStackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        addSubview(usernameLabel)
        addSubview(editProfileButton)
    }
    
    override func confBounds() {
        let paddingFromBorder: CGFloat = 15
        
        //Profile Image
        profileImageView.anchor(top: topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: paddingFromBorder, paddingLeft: paddingFromBorder, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        
        //Control Stackview
        controlStackView.anchor(top: nil, left: leftAnchor, bottom: self.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        topDividerView.anchor(top: controlStackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        bottomDividerView.anchor(top: controlStackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        //About Stackview
        aboutStackView.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 6, paddingRight: paddingFromBorder, width: 0, height: 50)
        
        //Username
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: controlStackView.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: paddingFromBorder, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        //Edit button
        editProfileButton.anchor(top: aboutStackView.bottomAnchor, left: aboutStackView.leftAnchor, bottom: profileImageView.bottomAnchor, right: aboutStackView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 0, width: 0, height: 34)
        
    }
    
    fileprivate func setupProfileImage() {
        guard let profileImageUrl = user?.profileImageUrl else { return }
        
        guard let url = URL(string: profileImageUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err { print("Failed to fetch the profile image:", err); return }
            //perhaps check for response status of 200 (HTTP OK)
            guard let data = data else { return }
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }}.resume()
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
