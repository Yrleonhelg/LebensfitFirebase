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
    
    static func fetchUserWithUID(uid: String, completion: @escaping (String, [String : Any]) -> ()) {
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            
            print("fetchUserWithUID succeeded")
            completion(uid, userDictionary)
        }) { (err) in
            print("fetchUserWithUID Failed: ", err)
        }
    }
}
