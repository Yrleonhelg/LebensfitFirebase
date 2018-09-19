//
//  Video+CoreDataProperties.swift
//  LebensfitFirebase
//
//  Created by Leon on 19.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//
//

import Foundation
import CoreData


extension Video {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Video> {
        return NSFetchRequest<Video>(entityName: "Video")
    }

    @NSManaged public var name: String?
    @NSManaged public var videoId: String?
    @NSManaged public var videoUrl: String?
    @NSManaged public var userOwningThis: NSSet?

}

// MARK: Generated accessors for userOwningThis
extension Video {

    @objc(addUserOwningThisObject:)
    @NSManaged public func addToUserOwningThis(_ value: User)

    @objc(removeUserOwningThisObject:)
    @NSManaged public func removeFromUserOwningThis(_ value: User)

    @objc(addUserOwningThis:)
    @NSManaged public func addToUserOwningThis(_ values: NSSet)

    @objc(removeUserOwningThis:)
    @NSManaged public func removeFromUserOwningThis(_ values: NSSet)

}
