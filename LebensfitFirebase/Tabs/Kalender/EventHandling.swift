//
//  EventHandling.swift
//  LebensfitFirebase
//
//  Created by Leon on 11.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import EventKit

extension TerminController {
    func fillArray() {
        var startDate = Date()
        var finDate = Date()
        for i in 0..<10 {
            finDate = Calendar.current.date(byAdding: .minute, value: 50, to: startDate)!
            let event = Event(id: i, type: .pilatesChair, start: startDate, finish: finDate, needsApplication: nil)
            eventArray.append(event)
            startDate = Calendar.current.date(byAdding: .minute, value: 60*6, to: startDate)!
            //event.printAll()
        }
//print(eventArray)
    }
    
    func addEventToCalendar() {
        let eventStore:EKEventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if let err = error { print("Failed to add Event", err); return }
            if granted {
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = "title"
                event.startDate = Date()
                event.endDate = Date()
                event.notes = "Notes"
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError { print("Failed to save Event:  \(error)"); return}
                print("Event Saved")
            }
            
        }
    }
}
