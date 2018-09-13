//
//  EventStruct.swift
//  LebensfitFirebase
//
//  Created by Leon on 10.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit
import MapKit

//MARK: Protocol
protocol DefaultEvent {
    var eventName: String { get }
    var eventDescription: String { get }
}

protocol AtLocation {
    var eventLocation: CLLocationCoordinate2D { get }
}


enum EventTypeEnum: DefaultEvent, AtLocation {
    case pilatesChair
    case flyingYogaAndPilates
    case kidsFit
    case pilatesFitMatte
    case businessYoga
    case taiJi
    case theraFitHit
    case feetUpYoga
    case yogaFit
    case rueckenFit
    case drumsAlive
    case fitImPark
    case yogaMitDaniUndRita
    
    var eventName: String {
        switch self {
        case .pilatesChair:
            return EventNameStruct.pilatesChair
            
        case .flyingYogaAndPilates:
            return EventNameStruct.flyingYogaAndPilates
            
        case .kidsFit:
            return EventNameStruct.kidsFit
            
        case .pilatesFitMatte:
            return EventNameStruct.pilatesFitMatte
            
        case .businessYoga:
            return EventNameStruct.businessYoga
            
        case .taiJi:
            return EventNameStruct.taiJi
            
        case .theraFitHit:
            return EventNameStruct.theraFitHit
            
        case .feetUpYoga:
            return EventNameStruct.feetUpYoga
            
        case .yogaFit:
            return EventNameStruct.yogaFit
            
        case .rueckenFit:
            return EventNameStruct.rueckenFit
            
        case .drumsAlive:
            return EventNameStruct.drumsAlive
            
        case .fitImPark:
            return EventNameStruct.fitImPark
            
        case .yogaMitDaniUndRita:
            return EventNameStruct.yogaMitDaniUndRita
            
//        default:
//            return EventNameStruct.defaultName
        }
    }
    
    var eventDescription: String {
        switch self {
        case .pilatesChair:
            return EventDescritionStruct.pialtesChairDesc
        default:
            return EventDescritionStruct.defaultDesc
        }
    }
    
    var eventLocation: CLLocationCoordinate2D {
        switch self {
        case .pilatesChair:
            return EventLocationStruct.turnhalleEisenwerk
        default:
            return EventLocationStruct.zuercherStrasse
        }
    }
}

//MARK: Name
struct EventNameStruct {
    static var pilatesChair = "Pilates Chair"
    static var flyingYogaAndPilates = "Flying Yoga & Pilates"
    static var kidsFit = "Kids fit"
    static var pilatesFitMatte = "Pilates fit Matte"
    static var businessYoga = "Business Yoga"
    static var taiJi = "Tai Ji mit Christa"
    static var theraFitHit = "Thera fit Hit"
    static var feetUpYoga = "FeetUp® Yoga"
    static var yogaFit = "Yoga Fit"
    static var rueckenFit = "Rücken Fit"
    static var drumsAlive = "Drums Alive®"
    static var fitImPark = "Fit Im Park"
    static var yogaMitDaniUndRita = "Yoga mit Dani und Rita"
    static var defaultName = "Pilates"
}

//MARK: Description
struct EventDescritionStruct {
    static var pialtesChairDesc = "In diesem Kurs machen wir tolle Pilates Übungen mit einem Tisch ;)"
    static var defaultDesc = "In diesem Kurs sind alle die noch nichts mit Pilates am Hut haben, herzig willkommen."
}

//MARK: Location
struct EventLocationStruct {
    static var appleHC = CLLocationCoordinate2DMake(37.332077, -122.02962)
    static var zuerich = CLLocationCoordinate2DMake(47.366670, 8.55000)
    static var turnhalleEisenwerk = CLLocationCoordinate2D(latitude: 47.561088, longitude: 8.894019)
    static var zuercherStrasse = CLLocationCoordinate2D(latitude: 47.553217, longitude: 8.891721)
}

//MARK: - Actuall Class
class Event {
    var eventID: Int?
    var eventType: EventTypeEnum?
    var eventName: String?
    var eventDescription: String?
    var eventLocation: CLLocationCoordinate2D?
    var eventStartingDate: Date?
    var eventFinishingDate: Date?
    var eventNeedsApplication = false
    var eventParticipants: [String]?
    
    init(id: Int, type: EventTypeEnum, start: Date, finish: Date, needsApplication: Bool?) {
        eventID = id
        eventType = type
        eventName = type.eventName
        eventDescription = type.eventDescription
        eventLocation = type.eventLocation
        eventStartingDate = start
        eventFinishingDate = finish
        if let app = needsApplication {
            eventNeedsApplication = app
        }
    }
    
    func printAll() {
        print("ID: \(eventID!)")
        print("Type: \(eventType!)")
        print("Name: \(eventName!)")
        print("Beschreibung: \(eventDescription!)")
        print("Standort: \(eventLocation!)")
        print("Start: \(eventStartingDate!)")
        print("Ende: \(eventFinishingDate!)")
        print("Anmeldung?: \(eventNeedsApplication)")
        print("____________________________")
    }
}

//MARK: - Currently out of use



////MARK: EventStruct
//struct ANormalEvent: DefaultEvent, AtLocation {
//    var eventName: String
//    var eventDescription: String
//    var eventLocation: CLLocationCoordinate2D
//}


//struct EventNameNeedsApplication {
//    static var pilatesChairApplication = false
//    static var flyingYogaAndPilatesApplication = "Flying Yoga & Pilates"
//    static var kidsFitApplication = "Kids fit"
//    static var pilatesFitMatteApplication = "Pilates fit Matte"
//    static var businessYogaApplication = "Business Yoga"
//    static var taiJiApplication = "Tai Ji mit Christa"
//    static var theraFitHitApplication = "Thera fit Hit"
//    static var feetUpYogaApplication = "FeetUp® Yoga"
//    static var yogaFitApplication = "Yoga Fit"
//    static var rueckenFitApplication = "Rücken Fit"
//    static var drumsAliveApplication = "Drums Alive®"
//    static var fitImParkApplication = "Fit Im Park"
//    static var yogaMitDaniUndRitaApplication = "Yoga mit Dani und Rita"
//    static var defaultNameApplication = "Pilates"
//}

//var normalesPilatesEvent = EventStruct(eventName: .pilatesChair, eventDescription: .defaultDesc, eventLocation: .appleHC)
