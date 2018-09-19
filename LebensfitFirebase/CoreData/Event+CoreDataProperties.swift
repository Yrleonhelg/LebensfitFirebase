//
//  Event+CoreDataProperties.swift
//  LebensfitFirebase
//
//  Created by Leon on 19.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var eventDescription: String?
    @NSManaged public var eventFinishingDate: NSDate?
    @NSManaged public var eventID: Int32
    @NSManaged public var eventIsOver: Bool
    @NSManaged public var eventLocation: NSObject?
    @NSManaged public var eventName: String?
    @NSManaged public var eventNeedsApplication: Bool
    @NSManaged public var eventStartingDate: NSDate?
    @NSManaged public var eventAdministrator: NSSet?
    @NSManaged public var eventMaybeParticipants: NSSet?
    @NSManaged public var eventSureParticipants: NSSet?
    @NSManaged public var eventNopeParticipants: NSSet?


    
}

// MARK: Generated accessors for eventAdministrator
extension Event {

    @objc(addEventAdministratorObject:)
    @NSManaged public func addToEventAdministrator(_ value: User)

    @objc(removeEventAdministratorObject:)
    @NSManaged public func removeFromEventAdministrator(_ value: User)

    @objc(addEventAdministrator:)
    @NSManaged public func addToEventAdministrator(_ values: NSSet)

    @objc(removeEventAdministrator:)
    @NSManaged public func removeFromEventAdministrator(_ values: NSSet)

}

// MARK: Generated accessors for eventMaybeParticipants
extension Event {

    @objc(addEventMaybeParticipantsObject:)
    @NSManaged public func addToEventMaybeParticipants(_ value: User)

    @objc(removeEventMaybeParticipantsObject:)
    @NSManaged public func removeFromEventMaybeParticipants(_ value: User)

    @objc(addEventMaybeParticipants:)
    @NSManaged public func addToEventMaybeParticipants(_ values: NSSet)

    @objc(removeEventMaybeParticipants:)
    @NSManaged public func removeFromEventMaybeParticipants(_ values: NSSet)

}

// MARK: Generated accessors for eventSureParticipants
extension Event {

    @objc(addEventSureParticipantsObject:)
    @NSManaged public func addToEventSureParticipants(_ value: User)

    @objc(removeEventSureParticipantsObject:)
    @NSManaged public func removeFromEventSureParticipants(_ value: User)

    @objc(addEventSureParticipants:)
    @NSManaged public func addToEventSureParticipants(_ values: NSSet)

    @objc(removeEventSureParticipants:)
    @NSManaged public func removeFromEventSureParticipants(_ values: NSSet)

}

// MARK: Generated accessors for eventNopeParticipants
extension Event {

    @objc(addEventNopeParticipantsObject:)
    @NSManaged public func addToEventNopeParticipants(_ value: User)

    @objc(removeEventNopeParticipantsObject:)
    @NSManaged public func removeFromEventNopeParticipants(_ value: User)

    @objc(addEventNopeParticipants:)
    @NSManaged public func addToEventNopeParticipants(_ values: NSSet)

    @objc(removeEventNopeParticipants:)
    @NSManaged public func removeFromEventNopeParticipants(_ values: NSSet)

}
