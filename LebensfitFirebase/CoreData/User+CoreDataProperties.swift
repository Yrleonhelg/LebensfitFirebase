//
//  User+CoreDataProperties.swift
//  LebensfitFirebase
//
//  Created by Leon on 18.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//
//

import Foundation
import CoreData
import Firebase


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var uid: String?
    @NSManaged public var username: String?
    @NSManaged public var profileImageUrl: String?
    @NSManaged public var role: String?
    @NSManaged public var email: String?
    @NSManaged public var boughtVideos: NSSet?
    @NSManaged public var participatedEvents: NSSet?
    @NSManaged public var upcomingSureEvents: NSSet?
    @NSManaged public var upcomingMaybeEvents: NSSet?
    @NSManaged public var following: NSSet?
    @NSManaged public var followers: NSSet?
    
    convenience init(uid: String, dictionary: [String: Any]) {
        let managedContext = PersistenceService.context
        self.init(context: managedContext)
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
    }


}

// MARK: Generated accessors for boughtVideos
extension User {

    @objc(addBoughtVideosObject:)
    @NSManaged public func addToBoughtVideos(_ value: Video)

    @objc(removeBoughtVideosObject:)
    @NSManaged public func removeFromBoughtVideos(_ value: Video)

    @objc(addBoughtVideos:)
    @NSManaged public func addToBoughtVideos(_ values: NSSet)

    @objc(removeBoughtVideos:)
    @NSManaged public func removeFromBoughtVideos(_ values: NSSet)

}

// MARK: Generated accessors for participatedEvents
extension User {

    @objc(addParticipatedEventsObject:)
    @NSManaged public func addToParticipatedEvents(_ value: Event)

    @objc(removeParticipatedEventsObject:)
    @NSManaged public func removeFromParticipatedEvents(_ value: Event)

    @objc(addParticipatedEvents:)
    @NSManaged public func addToParticipatedEvents(_ values: NSSet)

    @objc(removeParticipatedEvents:)
    @NSManaged public func removeFromParticipatedEvents(_ values: NSSet)

}

// MARK: Generated accessors for upcomingSureEvents
extension User {

    @objc(addUpcomingSureEventsObject:)
    @NSManaged public func addToUpcomingSureEvents(_ value: Event)

    @objc(removeUpcomingSureEventsObject:)
    @NSManaged public func removeFromUpcomingSureEvents(_ value: Event)

    @objc(addUpcomingSureEvents:)
    @NSManaged public func addToUpcomingSureEvents(_ values: NSSet)

    @objc(removeUpcomingSureEvents:)
    @NSManaged public func removeFromUpcomingSureEvents(_ values: NSSet)

}

// MARK: Generated accessors for upcomingMaybeEvents
extension User {

    @objc(addUpcomingMaybeEventsObject:)
    @NSManaged public func addToUpcomingMaybeEvents(_ value: Event)

    @objc(removeUpcomingMaybeEventsObject:)
    @NSManaged public func removeFromUpcomingMaybeEvents(_ value: Event)

    @objc(addUpcomingMaybeEvents:)
    @NSManaged public func addToUpcomingMaybeEvents(_ values: NSSet)

    @objc(removeUpcomingMaybeEvents:)
    @NSManaged public func removeFromUpcomingMaybeEvents(_ values: NSSet)

}

// MARK: Generated accessors for following
extension User {

    @objc(addFollowingObject:)
    @NSManaged public func addToFollowing(_ value: User)

    @objc(removeFollowingObject:)
    @NSManaged public func removeFromFollowing(_ value: User)

    @objc(addFollowing:)
    @NSManaged public func addToFollowing(_ values: NSSet)

    @objc(removeFollowing:)
    @NSManaged public func removeFromFollowing(_ values: NSSet)

}

// MARK: Generated accessors for followers
extension User {

    @objc(addFollowersObject:)
    @NSManaged public func addToFollowers(_ value: User)

    @objc(removeFollowersObject:)
    @NSManaged public func removeFromFollowers(_ value: User)

    @objc(addFollowers:)
    @NSManaged public func addToFollowers(_ values: NSSet)

    @objc(removeFollowers:)
    @NSManaged public func removeFromFollowers(_ values: NSSet)

}
