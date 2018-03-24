//
//  NSFetchedResultsController+Iteration.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 04.08.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import Foundation
import CoreData

extension NSFetchedResultsController {
    @objc func iterate(block: (IndexPath) -> Void) {
        if let sections = self.sections {
            for sectionIndex in 0..<sections.count {
                let section = sections[sectionIndex]
                for rowIndex in 0..<section.numberOfObjects {
                    let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                    block(indexPath)
                }
            }
        }
    }
}
