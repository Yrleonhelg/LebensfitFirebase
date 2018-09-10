//
//  HELG+Tableview.swift
//  LebensfitFirebase
//
//  Created by Leon on 10.09.18.
//  Copyright © 2018 helgcreating. All rights reserved.
//

import UIKit

extension UITableView {
    
    func isLast(for indexPath: IndexPath) -> Bool {
        
        let indexOfLastSection = numberOfSections > 0 ? numberOfSections - 1 : 0
        //let indexOfLastRowInLastSection = numberOfRows(inSection: indexOfLastSection) - 1
        let indexOfLastRowInLastSection = numberOfRows(inSection: indexPath.section) - 1
        //return indexPath.section == indexOfLastSection && indexPath.row == indexOfLastRowInLastSection
        return indexPath.row == indexOfLastRowInLastSection
    }
}
