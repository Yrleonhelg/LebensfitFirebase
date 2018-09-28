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
    var navbarHeight: CGFloat = 44 {
        didSet {
            scrollView.navbarHeight = navbarHeight
        }
    }
    var tabbarHeight: CGFloat = 49 {
        didSet {
            scrollView.tabbarHeight = tabbarHeight
        }
    }
    
    //MARK: - GUI Objects
    lazy var rectForBackView = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width+100)
    lazy var backView: BackView = {
        let view    = BackView(frame: rectForBackView, white: 0.2, black: 0, layerColor: LebensfitSettings.Colors.basicBackColor)
        return view
    }()
    
    lazy var scrollView: ProfileScrollView = {
        let view = ProfileScrollView()
        return view
    }()
    
    
    //MARK: - Init & View Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        scrollView.parentVC = self
        scrollView.delegate = self
        self.navbarHeight = self.navigationController?.navigationBar.frame.height ?? 44
        self.tabbarHeight = self.tabBarController?.tabBar.frame.height ?? 49
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
        
        self.navigationController?.navigationBar.isTranslucent      = true
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        self.navigationController?.navigationBar.shadowImage        = image
        self.navigationController?.navigationBar.backgroundColor    = LebensfitSettings.Colors.basicBackColor.withAlphaComponent(0.7)
        extendedLayoutIncludesOpaqueBars = true
    }
    
    func setupViews() {
        view.addSubview(backView)
        view.addSubview(scrollView)
    }
    
    func confBounds(){
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    //MARK: - Methods
    @objc func handleLogOut() {
        scrollView.pinnwandStackView.pinnwandTableView.reloadData()
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

extension ProfileController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        //Put the username of the profile in the navigationbar, as soon as the "Big" username isn't fully visible anymore.
        let statusbarHeight = UIApplication.shared.statusBarFrame.height
        let contentOffset = scrollView.contentOffset.y
        let usernameY = self.scrollView.usernameLabel.frame.minY
   
        if statusbarHeight + contentOffset >= usernameY {
            self.navigationItem.title = self.user?.username
            self.navigationController?.navigationBar.isTranslucent  = false
        } else {
            self.navigationItem.title = ""
            self.navigationController?.navigationBar.isTranslucent  = true
        }
        
        //make the interactionviews shrink to the fitting size when the user scrolled up far enough
        let pinnwandY = self.scrollView.pinnwandStackView.frame.maxY
        let value = contentOffset + self.scrollView.safeArea + statusbarHeight + tabbarHeight //Actually this is not quite correct but the closest dynamic value I could imagine
        
        if value < pinnwandY {
            if self.scrollView.displayFittingHeightForInteractionViews == false {
                self.scrollView.displayFittingHeightForInteractionViews = true
                viewDidLayoutSubviews()
            }
        } 
    }
}

extension ProfileController: profileSVToParentVC {
    override func viewDidLayoutSubviews() {
        let heightOfAllObjects: CGFloat = scrollView.calculateHeightOfAllObjects()
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: heightOfAllObjects)
        scrollView.heightOfContent.constant = heightOfAllObjects
    }
}
