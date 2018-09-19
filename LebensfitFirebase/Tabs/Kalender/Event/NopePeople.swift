//
//  NopePeople.swift
//  LebensfitFirebase
//
//  Created by Leon on 19.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

class NopePeople: PeopleTableView {
    
    var finishedLoading: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func loadNopeUsers() {
        guard let parent = parentVC else { return }
        let users = parent.thisEvent.eventNopeParticipants
        print("Nope: ")
        print(users)
        //        for user in users {
        //            print(user.username)
        //        }
        finishedLoading = true
        parent.teilnehmerLoaded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
