//
//  loadEverything.swift
//  LebensfitFirebase
//
//  Created by Leon on 20.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import Firebase
import CoreData

class loadEverything {
    static let managedContext = PersistenceService.context
    
    static func createAllUsers() {
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                guard let userDictionary = value as? [String: Any] else { return }
                _ = User(uid: key, dictionary: userDictionary, context: managedContext)
            })
        }
        )}
}
