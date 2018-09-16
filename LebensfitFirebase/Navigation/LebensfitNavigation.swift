//
//  PILATESNavigation.swift
//  PilatesTest
//
//  Created by Leon on 28.08.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit


class LebensfitNavigation: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarDefault()
    }
}

extension UINavigationController {
    func setNavigationBarDefault() {
        self.navigationBar.isTranslucent = false
        self.navigationBar.prefersLargeTitles = false
        
        self.navigationController?.navigationBar.barTintColor = LebensfitSettings.Colors.buttonBG
        self.navigationController?.navigationBar.backgroundColor = LebensfitSettings.Colors.buttonBG

        
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationBar.tintColor = LebensfitSettings.Colors.darkRed

        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .right
        let attributes = [NSAttributedStringKey.foregroundColor:UIColor.black,
                          NSAttributedStringKey.paragraphStyle:paragraph]
        self.navigationBar.titleTextAttributes = attributes
        
    }
}
