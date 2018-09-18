//
//  CDUser.swift
//  LebensfitFirebase
//
//  Created by Leon on 18.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class CDUser: NSObject {
    static let sharedInstance = CDUser()
    let managedContext = PersistenceService.context
    
    //create
    func createNewUser() {
        deleteUsers()
        //let newUser = User(context: managedContext)
        
        Database.fetchUserWithUID(uid: (Auth.auth().currentUser?.uid)!) { (user) in
//            newUser.uid = user.uid
//            newUser.username = user.username
//            newUser.email = user.email
//            newUser.profileImageUrl = user.profileImageUrl
            print(user.username)
        }
        
        do {
            try managedContext.save()
        } catch {
            print("Error beim erstellen eines neuen Benutzers: ",error)
        }
        
    }
    
    //read
    func loadUser() -> User {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        var users = [User]()
        
        do {
            users = try managedContext.fetch(fetchRequest)
            print(users)
        } catch {
            print("Error beim laden des Nutzer: ",error)
        }
        guard let user = users.last else { return User()}
        return user
    }
    
    //update
    func updateUsers() {
        
    }
    
    //delete
    func deleteUsers() {
        
        do {
            try managedContext.save()
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            try managedContext.execute(deleteRequest)
            try managedContext.save()
            print("Users deleted")
            
        } catch let err { print(err) }
        
    }
}
