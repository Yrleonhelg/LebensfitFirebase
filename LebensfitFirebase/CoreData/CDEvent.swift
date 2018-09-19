//
//  CDEvent.swift
//  LebensfitFirebase
//
//  Created by Leon on 18.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import CoreData

class CDEvent: NSObject {
    static let sharedInstance = CDEvent()
    let managedContext = PersistenceService.context
    
    //create
    func createNewEvent(id: Int32, name: String, startdate: Date, enddate: Date, needsApp: Bool) {
        let newEvent = Event(context: managedContext)

        do {
            try managedContext.save()
        } catch {
            print("Error beim erstellen eines neuen Benutzers: ",error)
        }
        
        loadEvents()
    }
    
    //read
    func loadEvents() {
        
        
        
    }
    
    //update
    func updateEvent() {
        
    }
    
    //delete
    func deleteEvent(eventId: Int32) {
        
        
        
    }
}
