//
//  UserStruct.swift
//  LebensfitFirebase
//
//  Created by Leon on 04.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import Foundation

struct User {
    let username: String
    let profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
    }
}
