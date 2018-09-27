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
    var user: User? {
        didSet {
            scrollView.usernameLabel.text = user?.username
            guard let profileImageUrl = user?.profileImageUrl else { return }
            scrollView.profileImageView.loadImage(urlString: profileImageUrl)
            backView.loadImage(urlString: profileImageUrl)
            setupNavBar()
            scrollView.user = user
        }
    }
    
    //MARK: - GUI Objects
    lazy var rectForBackView = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width+100)
    lazy var backView: BackView = {
        let view    = BackView(frame: rectForBackView, white: 0.2, black: 0, layerColor: LebensfitSettings.Colors.basicBackColor)
        return view
    }()
    
    let scrollView: ProfileScrollView = {
        let view = ProfileScrollView()
        return view
    }()
    
    
    //MARK: - Init & View Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.parentVC = self
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = LebensfitSettings.Colors.basicBackColor
        setupViews()
        confBounds()
        scrollView.confBounds()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let vc = self.navigationController?.viewControllers.first
        if vc == self.navigationController?.visibleViewController {
            print("self")
            user = CDUser.sharedInstance.getCurrentUser()
        } else {
            print("notself")
            fetchUser()
        }
        scrollView.presentSteckbriefView()
        scrollView.scrollToTop()
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
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        //self.navigationController?.navigationBar.shadowImage    = image
        self.navigationController?.navigationBar.backgroundColor = LebensfitSettings.Colors.basicBackColor.withAlphaComponent(0.7)
    }
    
    func setupViews() {
        view.addSubview(backView)
        view.addSubview(scrollView)
    }
    
    func confBounds(){
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    override func viewDidLayoutSubviews() {
        let heightOfAllObjects: CGFloat = scrollView.calculateHeightOfAllObjects()
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: heightOfAllObjects)
        scrollView.heightOfContent.constant = heightOfAllObjects
    }
    
    //MARK: - Methods
    @objc func handleLogOut() {
        scrollView.scrollToTop()
        return
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
}
