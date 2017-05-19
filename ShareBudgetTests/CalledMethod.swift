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
    var selector: Selector
    
    init(selector: Selector) {
        self.selector = selector
    }
}

extension CalledMethod: Hashable {
    var hashValue: Int {
        return selector.hashValue
    }
    
    static func == (lhs: CalledMethod, rhs: CalledMethod) -> Bool {
        return lhs.selector == rhs.selector
    }
}
