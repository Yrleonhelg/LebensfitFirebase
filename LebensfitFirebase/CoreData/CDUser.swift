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
    func createCurrentUser() {
        Database.fetchUserWithUID(uid: (Auth.auth().currentUser?.uid)!) { (userId, userDictionary)  in
            _ = User(uid: userId, dictionary: userDictionary, context: self.managedContext)
        }
        do {
            try managedContext.save()
            print("user saved")
        } catch {
            print("Error beim erstellen eines neuen Benutzers: ",error)
        }
        
    }
    
    func createUserWithID(userId: String) {
        Database.fetchUserWithUID(uid: userId) { (userId, userDictionary)  in
            _ = User(uid: userId, dictionary: userDictionary, context: self.managedContext)
        }
        do {
            try managedContext.save()
            print("user saved")
        } catch {
            print("Error beim erstellen eines neuen Benutzers: ",error)
        }
    }
    
    //read
    func loadUsers() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            _ = try managedContext.fetch(fetchRequest)
            print("loadUsers: All users loaded")
        } catch {
            print("Error beim laden des Nutzer: ",error)
        }
    }
    
    func getUsers() -> [User] {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        var users = [User]()
        
        do {
            users = try managedContext.fetch(fetchRequest)
            print("getUsers: All users loaded")
        } catch {
            print("Error beim laden des Nutzer: ",error)
        }
        return users
    }
    
    func getCurrentUser() -> User? {
        let allUsers = getUsers()
        guard let key = Auth.auth().currentUser?.uid else { print("returning ",allUsers.first!); return allUsers.first!}
        for i in 0..<allUsers.count {
            if key == allUsers[i].uid {
                return allUsers[i]
            }
        }
        return nil
    }
    
    func getUserForId(userId: String) -> User {
        let allUsers = getUsers()
        
        for i in 0..<allUsers.count {
            if userId == allUsers[i].uid {
                return allUsers[i]
            }
        }
        print("No user for passed id")
        return allUsers.first!
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
