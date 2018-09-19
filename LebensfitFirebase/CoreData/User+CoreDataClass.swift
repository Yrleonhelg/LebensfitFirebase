//
//  User+CoreDataClass.swift
//  LebensfitFirebase
//
//  Created by Leon on 18.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//
//

import Foundation
import CoreData


public class User: NSManagedObject {

    convenience init(uid: String, dictionary: [String: Any]) {
        let managedContext = PersistenceService.context
        self.init(context: managedContext)
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
    }
    
}
