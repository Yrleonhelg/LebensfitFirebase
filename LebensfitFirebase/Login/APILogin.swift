//
//  APILogin.swift
//  LebensfitFirebase
//
//  Created by Leon on 18.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import Firebase

extension LoginController {
    func loginToFireBase(email: String, pw: String) {

        Auth.auth().signIn(withEmail: email, password: pw, completion: { (user, err) in
            if let err = err { print("Failed to sign in with email:", err); return }
            print("Successfully logged back in with user:", user?.user.uid ?? "")
            
            guard let LebensfitTabBarController = UIApplication.shared.keyWindow?.rootViewController as? LebensfitTabBarController else { return }
            LebensfitTabBarController.setupTabBar()
            LebensfitTabBarController.setupViewControllers()
            
            self.dismiss(animated: true, completion: nil)
        })
    }
}
