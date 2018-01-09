//
//  BaseInteraction.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

typealias APIResultBlock = (Any?, ErrorTypeAPI) -> Void

protocol BaseInteractionDelegate: class {
    func didChangeContent()
    func willChangeContent()
    func changed(at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
}

protocol BaseInteractionProtocol: class {
}

class BaseInteraction: NSObject, BaseInteractionProtocol {
    
}
