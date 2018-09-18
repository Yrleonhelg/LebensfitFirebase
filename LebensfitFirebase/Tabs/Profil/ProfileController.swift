//
//  ProfileController.swift
//  LebensfitFirebase
//
//  Created by Leon on 13.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController {
    //MARK: - Properties & Variables
    var userId: String?
    lazy var rectForBackView = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width+100)
    
    var user: User? {
        didSet {
            usernameLabel.text = user?.username
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
            backView.loadImage(urlString: profileImageUrl)
            resetNavBar()
        }
    }
    
    //MARK: - GUI Objects
    let profileImageView: CustomImageView = {
        let iv              = CustomImageView()
        iv.clipsToBounds    = true
        iv.contentMode      = .scaleAspectFill
        iv.image            = UIImage(named: "profile_selected")
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label           = UILabel()
        label.text          = "username"
        label.textColor     = .white
        label.font          = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .left
        return label
    }()
    
    lazy var backView: BackView = {
        let view    = BackView(frame: rectForBackView, white: 0.2, black: 0)
        //view.image  = UIImage(named: "")
        return view
    }()
    
    let picture: UIImageView = {
        let pic                 = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        pic.clipsToBounds       = true
        pic.contentMode         = .scaleAspectFill
        pic.image               = UIImage(named: "plus_photo")
        pic.layer.borderColor   = UIColor.white.cgColor
        pic.layer.borderWidth   = 2
        return pic
    }()
    
    let followButton: UIButton = {
        let button                  = UIButton()
        button.setTitle("Folgen", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor      = LebensfitSettings.Colors.darkRed
        button.layer.cornerRadius   = 20
        return button
    }()
    
    let teilgenommeneKurseLabel: UILabel = {
        let label               = UILabel()
        label.textAlignment     = .center
        label.numberOfLines     = 0
        
        let attributedText      = NSMutableAttributedString(string: "2\n", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17)])
        attributedText.append(NSAttributedString(string: "Kurse", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)]))
        label.attributedText    = attributedText
        return label
    }()
    
    let followerLabel: UILabel = {
        let label               = UILabel()
        label.textAlignment     = .center
        label.numberOfLines     = 0
        
        let attributedText      = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17)])
        attributedText.append(NSAttributedString(string: "Follower", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)]))
        label.attributedText    = attributedText
        return label
    }()
    
    let videosLabel: UILabel = {
        let label               = UILabel()
        label.textAlignment     = .center
        label.numberOfLines     = 0
        
        let attributedText      = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17)])
        attributedText.append(NSAttributedString(string: "Videos", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)]))
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
        sc.tintColor            = .white
        return sc
    }()
    
    let steckbriefView: SteckbriefView = {
        let sbv = SteckbriefView()
        return sbv
    }()
    
    let pinnwandView: PinnwandView = {
        let pwv = PinnwandView()
        return pwv
    }()
    
    
    //MARK: - Init & View Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNavBar()
        setupViews()
        confBounds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if userId == Auth.auth().currentUser?.uid {
            user = CDUser.sharedInstance.loadUser()
        } else {
            fetchUser()
        }
        presentSteckbriefView()
    }
    
    //MARK: - Setup
    func setupNavBar() {
        self.navigationItem.title = ""
        if user?.uid == Auth.auth().currentUser?.uid {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "logout")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
        }
        setupNavBarBackground()
    }
    
    func setupNavBarBackground() {
        let renderer    = UIGraphicsImageRenderer(size: rectForBackView.size)
        let image       = renderer.image { ctx in
            backView.drawHierarchy(in: backView.bounds, afterScreenUpdates: true)
        }
        
        self.navigationController?.navigationBar.isTranslucent  = true
        //self.navigationController?.navigationBar.barTintColor = .clear
        //self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        self.navigationController?.navigationBar.shadowImage    = image

        profileImageView.removeFromSuperview()
        usernameLabel.removeFromSuperview()
        setupViews()
        confBounds()
    }
    
    func setupViews() {
        view.addSubview(backView)
        view.addSubview(profileImageView)
        view.addSubview(usernameLabel)
        view.addSubview(controlStackView)
        view.addSubview(dividerView)
        view.addSubview(segmentedController)
        segmentedController.addTarget(self, action: #selector(changeView(sender:)), for: .valueChanged)
    }
    
    func confBounds(){
        profileImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 200)
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.layer.cornerRadius = 200/2
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if userId != Auth.auth().currentUser?.uid {
            view.addSubview(followButton)
            followButton.anchor(top: usernameLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 160, height: 40)
            followButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            followButton.addTarget(self, action: #selector (resetNavBar), for: .touchUpInside)
            controlStackView.anchor(top: followButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: -10, paddingBottom: 0, paddingRight: -10, width: 0, height: 80)
        } else {
            controlStackView.anchor(top: usernameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: -10, paddingBottom: 0, paddingRight: -10, width: 0, height: 80)
        }
        dividerView.anchor(top: controlStackView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: -10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        segmentedController.anchor(top: dividerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        
    }
    
    //MARK: - Methods
    @objc func resetNavBar() {
        setupNavBar()
        setupNavBarBackground()
    }
    
    @objc func changeView(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            presentPinnwandView()
        default:
            presentSteckbriefView()
        }
    }
    
    func presentSteckbriefView() {
        pinnwandView.removeFromSuperview()
        view.addSubview(steckbriefView)
        steckbriefView.anchor(top: segmentedController.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func presentPinnwandView() {
        steckbriefView.removeFromSuperview()
        view.addSubview(pinnwandView)
        pinnwandView.anchor(top: segmentedController.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()

                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)

            } catch let signOutErr { print("Failed to sign out:", signOutErr) }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Do not change Methods
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarDefault()
    }
}
