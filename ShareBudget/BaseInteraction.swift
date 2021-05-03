//
//  BaseInteraction.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import CoreData
import UIKit

typealias APIResultBlock = (Any?, ErrorTypeAPI) -> Void

protocol BaseInteractionDelegate: class {
    func didChangeContent()
    func willChangeContent()
    func changed(at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
}

protocol BaseInteractionProtocol: class {}

class BaseInteraction: NSObject {}
