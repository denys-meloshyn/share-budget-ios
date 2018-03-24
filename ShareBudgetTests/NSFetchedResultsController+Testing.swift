//
//  NSFetchedResultsController+Testing.swift
//  ShareBudgetTests
//
//  Created by Denys Meloshyn on 06.08.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

extension NSFetchedResultsController {
    @objc func numberOfObjects() -> Int {
        let result = self.sections!.reduce(0, { (result: Int, item: NSFetchedResultsSectionInfo) -> Int in
            result + item.numberOfObjects
        })
        
        return result
    }
    
    @objc func performSilentFailureFetch() {
        try! self.performFetch()
    }
}
