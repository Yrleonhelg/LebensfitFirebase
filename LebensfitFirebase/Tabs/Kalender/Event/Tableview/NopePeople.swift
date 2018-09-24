//
//  NopePeople.swift
//  LebensfitFirebase
//
//  Created by Leon on 19.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class NopePeople: PeopleTableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        peopleLabel.text = "Absagen:"
    }
    
    override func loadUsers() {
        print("Class: \(#file) Function: \(#function)")
        guard let parentCont = parentVC else { return }
        users = (parentCont.thisEvent.eventNopeParticipants?.allObjects as! [User])
        finishedLoading = true
        super.loadUsers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
