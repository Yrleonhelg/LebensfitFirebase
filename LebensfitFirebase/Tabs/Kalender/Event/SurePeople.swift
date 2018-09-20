//
//  SurePeople.swift
//  LebensfitFirebase
//
//  Created by Leon on 19.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class SurePeople: PeopleTableView {

    var sureUsers: [User]! = [User]()
    var finishedLoading: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func loadSureUsers() {
        guard let parent = parentVC else { return }
        users = (parent.thisEvent.eventSureParticipants?.allObjects as! [User]) ?? []
        finishedLoading = true
        parent.teilnehmerLoaded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
