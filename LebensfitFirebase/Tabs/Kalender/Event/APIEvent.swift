//
//  UserFetch.swift
//  LebensfitFirebase
//
//  Created by Leon on 13.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//
import UIKit
import Firebase

extension TeilnehmerTableView {
    func fetchUsers() {
        print("Fetching users..")
        if users != nil {
            users.removeAll()
        }
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
//                if key == Auth.auth().currentUser?.uid {
//                    print("Found myself, omit from list")
//                    return
//                }

                guard let userDictionary = value as? [String: Any] else { return }
                
                let user = User(uid: key, dictionary: userDictionary)
                self.users.append(user)
            })
            
            self.users.sort(by: { (u1, u2) -> Bool in
                return u1.username?.compare(u2.username!) == .orderedAscending
            })
            DispatchQueue.main.async( execute: {
                self.participantsTableView.reloadData()
                self.parentVC?.teilnehmerLoaded()
            })
            print("all users fetched")
            
        }) { (err) in
            print("Failed to fetch users for search:", err)
        }
    }
}
