//
//  ProfileModel.swift
//  LebensfitFirebase
//
//  Created by Leon on 13.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import Firebase

extension ProfileController {
//    func fetchUser() {
//
//        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
//        Database.fetchUserWithUID(uid: uid) { (user) in
//            self.user = user
//            if uid == Auth.auth().currentUser?.uid {
//                //self.navigationItem.title = self.user?.username
//            }
//        }
//    }
    func fetchUser() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        self.user = CDUser.sharedInstance.getUserForId(userId: uid)
    }
}
