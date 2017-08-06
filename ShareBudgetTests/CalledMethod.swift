//
//  CalledMethod.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 19.05.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class CalledMethod {
    var counter = 0
    var name: String
    
    init(_ selector: Selector) {
        self.name = selector.description
    }
    
    init(_ selector: String) {
        self.name = selector
    }
}

extension CalledMethod: Hashable {
    var hashValue: Int {
        return name.hashValue
    }
    
    static func == (lhs: CalledMethod, rhs: CalledMethod) -> Bool {
        return lhs.name == rhs.name
    }
}
