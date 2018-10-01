//
//  ProfileScrollView.swift
//  LebensfitFirebase
//
//  Created by Leon on 25.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import Firebase

protocol profileScrollViewDelegate: Any {
    func viewDidLayoutSubviews()
    func openSearchUsersVC()
}

class ProfileScrollView: UIScrollView {
    
    //MARK: - Properties & Variables
    var delegateVC: profileScrollViewDelegate?
    var displayFittingHeightForInteractionViews = true
    var safeArea: CGFloat = 623.0
    var navbarHeight: CGFloat = 44
    var tabbarHeight: CGFloat = 49
    
    var heightOfContent = NSLayoutConstraint()
    var heightOfPinnwandStackView = NSLayoutConstraint()
    var heightOfSteckbriefView = NSLayoutConstraint()
    
    var heightOfAllPaddings: CGFloat    = 0
    var matchingHeightForFullPinnwand: CGFloat = 0
    var isCurrentUserVar = true
    var user: User? {
        didSet{
            guard let user = user else { return }
            if let name = user.username {
                pinnwandStackView.ueberMich.text = "\(name)'s Pins:"
            }
            isCurrentUser()
        }
    }
    
    //MARK: - GUI Objects
    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    var upperUIElements: [UIView]?
    
    let profileImageView: CustomImageView = {
        let iv              = CustomImageView()
        iv.clipsToBounds    = true
        iv.contentMode      = .scaleAspectFill
        iv.image            = UIImage(named: "basePP")
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label           = UILabel()
        label.text          = "username"
        label.textColor     = LebensfitSettings.Colors.basicTextColor
        label.font          = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .left
        return label
    }()
    
    let followButton: UIButton = {
        let button                  = UIButton()
        button.setTitle("Folgen", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor      = LebensfitSettings.Colors.basicTintColor
        button.layer.cornerRadius   = 20
        button.layer.borderWidth    = 1
        button.layer.borderColor    = LebensfitSettings.Colors.basicTintColor.cgColor
        return button
    }()
    
    let teilgenommeneKurseLabel: UILabel = {
        let label               = UILabel()
        label.textAlignment     = .center
        label.numberOfLines     = 0
        
        let attributedText      = NSMutableAttributedString(string: "2\n", attributes: [NSAttributedString.Key.foregroundColor: LebensfitSettings.Colors.basicTextColor, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)])
        attributedText.append(NSAttributedString(string: "Kurse", attributes: [NSAttributedString.Key.foregroundColor: LebensfitSettings.Colors.NITextColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]))
        label.attributedText    = attributedText
        return label
    }()
    
    let followerLabel: UILabel = {
        let label               = UILabel()
        label.textAlignment     = .center
        label.numberOfLines     = 0
        
        let attributedText      = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.foregroundColor: LebensfitSettings.Colors.basicTextColor, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)])
        attributedText.append(NSAttributedString(string: "Follower", attributes: [NSAttributedString.Key.foregroundColor: LebensfitSettings.Colors.NITextColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]))
        label.attributedText    = attributedText
        return label
    }()
    
    let videosLabel: UILabel = {
        let label               = UILabel()
        label.textAlignment     = .center
        label.numberOfLines     = 0
        
        let attributedText      = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.foregroundColor: LebensfitSettings.Colors.basicTextColor, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)])
        attributedText.append(NSAttributedString(string: "Videos", attributes: [NSAttributedString.Key.foregroundColor: LebensfitSettings.Colors.NITextColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]))
        label.attributedText    = attributedText
        return label
    }()
    
    lazy var controlStackView: UIStackView = {
        let sv          = UIStackView(arrangedSubviews: [teilgenommeneKurseLabel, followerLabel, videosLabel])
        sv.axis         = .horizontal
        sv.distribution = .fillEqually
        return sv
    }()
    
    let dividerView: UIView = {
        let dv              = UIView()
        dv.backgroundColor  = UIColor.lightGray
        return dv
    }()
    
    let segmentedController: UISegmentedControl = {
        let items               = ["Steckbrief", "Pinnwand"]
        let frame               = UIScreen.main.bounds
        
        let sc                  = UISegmentedControl(items: items)
        sc.selectedSegmentIndex = 0
        sc.frame                = CGRect(x: frame.minX + 10, y: frame.minY + 50, width: frame.width - 20, height: 30)
        sc.layer.cornerRadius   = 5.0
        sc.tintColor            = LebensfitSettings.Colors.basicTintColor
        return sc
    }()
    
    let steckbriefView: SteckbriefView = {
        let view = SteckbriefView()
        return view
    }()
    
    let pinnwandStackView: PinnwandStackView = {
        let view = PinnwandStackView()
        return view
    }()
    
    //MARK: -
    //MARK: - Init & View Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        upperUIElements = [profileImageView, usernameLabel, followButton, controlStackView, dividerView]
        setupViews()
    }
    
    //MARK: - Setup
    func setupViews() {
        addSubview(contentView)
        heightOfContent = contentView.heightAnchor.constraint(equalToConstant: 0)
        heightOfContent.isActive = true
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(followButton)
        contentView.addSubview(controlStackView)
        contentView.addSubview(dividerView)
        contentView.addSubview(segmentedController)
        segmentedController.addTarget(self, action: #selector(changeView(sender:)), for: .valueChanged)
        
        contentView.addSubview(steckbriefView)
        contentView.addSubview(pinnwandStackView)
        pinnwandStackView.isHidden = true
    }
    
    func confBounds(){
        heightOfAllPaddings = 0
        contentView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        contentView.widthAnchor.constraint(equalTo: self.frameLayoutGuide.widthAnchor, multiplier: 1).isActive = true
        
        profileImageView.anchor(top: contentView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 250, height: 250)
        profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        profileImageView.layer.cornerRadius = 250/2
        heightOfAllPaddings += 20
        
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        usernameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        heightOfAllPaddings += 10
        
        followButton.anchor(top: usernameLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 180, height: 40)
        followButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        controlStackView.anchor(top: followButton.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 15, paddingLeft: -10, paddingBottom: 0, paddingRight: -10, width: 0, height: 80)
        heightOfAllPaddings += 45
        
        dividerView.anchor(top: controlStackView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: -10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        heightOfAllPaddings -= 10
        
        segmentedController.anchor(top: dividerView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        heightOfAllPaddings += 10
        
        steckbriefView.anchor(top: segmentedController.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 0, height: 0)
        heightOfSteckbriefView = steckbriefView.heightAnchor.constraint(equalToConstant: safeArea)
        heightOfSteckbriefView.isActive = true
        
        pinnwandStackView.anchor(top: segmentedController.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: 0, height: 0)
        heightOfPinnwandStackView = pinnwandStackView.heightAnchor.constraint(equalToConstant: safeArea)
        heightOfPinnwandStackView.isActive = true
        
        heightOfAllPaddings += 10
    }
    
    //MARK: - Methods
    //calculates the height of all UI Object to then set the contentsize of the scrollview
    func calculateHeightOfAllObjects() -> CGFloat{
        guard let sum               = upperUIElements?.reduce(0, {$0 + $1.frame.height}) else { return 0}
        let heightOfPinnwand        = pinnwandStackView.calculate()
        let heightOfSegController   = segmentedController.frame.height
        safeArea                    = self.safeAreaLayoutGuide.layoutFrame.height
        
        matchingHeightForFullPinnwand = safeArea - segmentedController.frame.height - 10 //TODO: added 20 to heightofallpaddings so this might not be true anymore
        heightOfPinnwandStackView.constant = heightOfPinnwand
        
        return (displayFittingHeightForInteractionViews ? sum + heightOfAllPaddings + heightOfPinnwand + heightOfSegController : sum + heightOfAllPaddings + safeArea)
    }
    
    //sets different button propertys based if the displaying user is the current user
    func isCurrentUser() {
        if isCurrentUserVar {
            followButton.setTitle("Freunde finden", for: .normal)
            followButton.addTarget(self, action: #selector(findFriendsButtonPressed), for: .touchUpInside)
        } else {
            followButton.setTitle("Folgen", for: .normal)
            followButton.setTitle("Gefolgt", for: .selected)
            followButton.addTarget(self, action: #selector(followButtonPressed), for: .touchUpInside)
        }
    }
    
    @objc func changeView(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            changeViewTo(newView: pinnwandStackView, oldView: steckbriefView)
        default:
            changeViewTo(newView: steckbriefView, oldView: pinnwandStackView)
            break
        }
        scrollToInteractionViews()
        
    }
    
    //Scrolls down so that the divider between the info labels and the segmented Controller is at the bottom of the tabbar
    func scrollToInteractionViews() {
        displayFittingHeightForInteractionViews = false
        let dividerMinY             = dividerView.frame.minY
        let navbarHeight            = self.navbarHeight
        let statusbarHeight         = UIApplication.shared.statusBarFrame.height
        
        let point = dividerMinY - navbarHeight - statusbarHeight
        self.scrollToPoint(pointY: point)
        delegateVC?.viewDidLayoutSubviews()
        
        
    }
    
    func changeViewTo(newView: UIView, oldView: UIView) {
        newView.isHidden = false
        newView.alpha = 0
        UIView.animate(withDuration:0.4, animations: {
            oldView.alpha = 0
            newView.alpha = 1
        }) { (result: Bool) in
            oldView.isHidden = true
        }
    }
    
    @objc func followButtonPressed() {
        let selected = !followButton.isSelected
        selectButton(button: followButton, selected: selected)
    }
    @objc func findFriendsButtonPressed() {
        delegateVC?.openSearchUsersVC()
    }
    
    func selectButton(button: UIButton, selected: Bool) {
        if selected {
            button.backgroundColor      = .clear
            button.setTitleColor(LebensfitSettings.Colors.basicTintColor, for: .normal)
            button.isSelected           = true
        } else {
            button.backgroundColor      = LebensfitSettings.Colors.basicTintColor
            button.setTitleColor(LebensfitSettings.Colors.basicBackColor, for: .normal)
            button.isSelected           = false
        }
    }
    
    //MARK: - Do not change Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

