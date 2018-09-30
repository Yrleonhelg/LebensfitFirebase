//
//  APISearchUsers.swift
//  LebensfitFirebase
//
//  Created by Leon Helg on 30.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import CoreData
import Firebase

extension SearchUserProfileTableViewController {
    func fetchUsers() {
        
        let allUsers = CDUser.sharedInstance.getUsers()
        let currentUserId = Auth.auth().currentUser?.uid
        
        for user in allUsers {
            if user.uid == currentUserId {
                print("Found myself, omit from list")
            } else {
                self.users.append(user)
            }
            
        }
        
        self.users.sort(by: { (u1, u2) -> Bool in
            return u1.username?.compare(u2.username ?? "") == .orderedAscending
        })
        self.filteredUsers = self.users
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

