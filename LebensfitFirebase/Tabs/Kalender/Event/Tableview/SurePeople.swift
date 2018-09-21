//
//  SurePeople.swift
//  LebensfitFirebase
//
//  Created by Leon on 19.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class SurePeople: PeopleTableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        peopleLabel.text = "Teilnehmer:"
    }
    
    override func loadUsers() {
        print("Class: \(#file) Function: \(#function)")
        guard let parent = parentVC else { return }
        users = parent.thisEvent.eventSureParticipants?.allObjects as! [User]
        super.loadUsers()
        finishedLoading = true
        parent.teilnehmerLoaded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
