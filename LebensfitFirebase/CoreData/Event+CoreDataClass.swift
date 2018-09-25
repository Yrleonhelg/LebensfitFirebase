//
//  Event+CoreDataClass.swift
//  LebensfitFirebase
//
//  Created by Leon on 18.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//
//

import Foundation
import CoreData


public class Event: NSManagedObject {
    convenience init(id: Int32, type: EventTypeEnum, start: NSDate, finish: NSDate, needsApplication: Bool?) {
        let managedContext = PersistenceService.context
        self.init(context: managedContext)
        eventID = id
        eventName = type.eventName
        eventDescription = type.eventDescription
        eventLocation = type.eventLocation as NSObject
        eventStartingDate = start
        eventFinishingDate = finish
        if let app = needsApplication {
            eventNeedsApplication = app
        }
    }
    
}
