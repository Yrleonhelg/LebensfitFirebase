//
//  APIRegister.swift
//  LebensfitFirebase
//
//  Created by Leon on 18.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import Firebase

extension SignUpController {
    func registerToFireBase(email: String, user: String, pw: String) {
        let email       = email
        let username    = user
        let password    = pw
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error: Error?) in
            if let err = error { print("Failed to create user:", err); return }
            print("Successfully created user:", user?.user.uid ?? "")
            
            guard let image = self.plusPhotoButton.imageView?.image else { return }
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
            let filename = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child(filename)
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                if let err = err { print("Failed to upload profile image:", err); return}
                
                // Firebase 5 Update: Must now retrieve downloadURL
                storageRef.downloadURL(completion: { (downloadURL, err) in
                    if let err = err { print("Failed to fetch downloadURL:", err); return }
                    guard let profileImageUrl = downloadURL?.absoluteString else { return }
                    print("Successfully uploaded profile image:", profileImageUrl)
                    guard let uid = user?.user.uid else { return }
                    
                    let dictionaryValues = ["username": username, "profileImageUrl": profileImageUrl]
                    let values = [uid: dictionaryValues]
                    
                    Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                        
                        if let err = err { print("Failed to save user info into db:", err); return }
                        print("Successfully saved user info to db")
                        CDUser.sharedInstance.createNewUser()
                        
                        guard let LebensfitTabBarController = UIApplication.shared.keyWindow?.rootViewController as? LebensfitTabBarController else { return }
                        LebensfitTabBarController.setupTabBar()
                        LebensfitTabBarController.setupViewControllers()
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    })
                })
            })
        })
    }
}
