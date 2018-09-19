//
//  HELG+Firebase.swift
//  LebensfitFirebase
//
//  Created by Leon on 13.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//


import Foundation
import Firebase

extension Database {
    
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print("Fetching User for post")
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            //maybe create a User Class which has nothing to do with coredata and create the CD Class based on that result.
            let user = User(uid: uid, dictionary: userDictionary)
            print("Fetching complete")
            completion(user)
            
            
        }) { (err) in
            print("Failed to fetch user for posts:", err)
        }
    }
}
