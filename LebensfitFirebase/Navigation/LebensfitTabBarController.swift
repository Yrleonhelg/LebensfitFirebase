//
//  PILATESTabBarController.swift
//  PilatesTest
//
//  Created by Leon Helg on 29.08.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import Firebase

class LebensfitTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CDUser.sharedInstance.deleteUsers()
        //Only let the user pass when they're logged in.
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        CDUser.sharedInstance.createCurrentUser()
        print("created")
        setupTabBar()
        setupViewControllers()
    }
    
    func setupTabBar() {
        view.backgroundColor        = LebensfitSettings.Colors.buttonBG
        tabBar.autoresizesSubviews  = true
        tabBar.isTranslucent        = true
        self.tabBar.tintColor       = LebensfitSettings.Colors.darkRed
        self.tabBar.unselectedItemTintColor = LebensfitSettings.Colors.darkGray
        
        let topBorder               = CALayer()
        topBorder.frame             = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor   = UIColor.rgb(229, 231, 235, 1).cgColor
        
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
    }
    
    func setupViewControllers() {
        //Images:
        let calendarImage = UIImage(named: LebensfitSettings.UI.iconNames.calendar)
        let shopImage = UIImage(named: LebensfitSettings.UI.iconNames.shop)
        let mapImage = UIImage(named: LebensfitSettings.UI.iconNames.map)
        let userImage = UIImage(named: LebensfitSettings.UI.iconNames.benutzer)
        
        //Calendar
        let calendarVC = TerminController()
        let calendarNavigationController = LebensfitNavigation(rootViewController: calendarVC)
        calendarNavigationController.tabBarItem = UITabBarItem(title: "Kalender", image: calendarImage, tag: 0)
        calendarNavigationController.title = "Kalender"
        
        //Home / videos
        let homeController = ShopController(collectionViewLayout: UICollectionViewFlowLayout())
        let homeNavigationController = LebensfitNavigation(rootViewController: homeController)
        homeNavigationController.title = "Shop"
        homeNavigationController.tabBarItem = UITabBarItem(title: "Shop", image: shopImage, tag: 0)
        
        //map
        let mapController = MapController()
        let mapNavigationController = LebensfitNavigation(rootViewController: mapController)
        mapNavigationController.title = "Karte"
        mapNavigationController.tabBarItem = UITabBarItem(title: "Karte", image: mapImage, tag: 0)
        
        //profile
        let profileController = ProfileController()
//        profileController.userId = Auth.auth().currentUser?.uid
        let profileNavigationController = LebensfitNavigation(rootViewController: profileController)
        profileNavigationController.title = "Profil"
        profileNavigationController.tabBarItem = UITabBarItem(title: "Profil", image: userImage, tag: 0)
        
        viewControllers = [calendarNavigationController, homeNavigationController, mapNavigationController, profileNavigationController]
    }
}

