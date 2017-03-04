//
//  BaseInteraction.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

typealias APIResultBlock = (Any?, ErrorTypeAPI) -> (Void)

@objc protocol BaseInteractionDelegate: class {
    @objc optional func didChangeContent()
    @objc optional func willChangeContent()
    @objc optional func changed(at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
}

class BaseInteraction: NSObject {
    
}
