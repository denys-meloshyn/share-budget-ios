//
//  CalledMethodManager.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 19.05.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class CalledMethodManager {
    var methods = [CalledMethod]()
    
    func add(_ method: Selector) {
        let filterItems = methods.filter { (it) -> Bool in
            it.selector == method
        }
        
        if filterItems.count > 0 {
            let current = filterItems[0]
            current.counter += 1
        }
        else {
            let new = CalledMethod(selector: method)
            methods.append(new)
        }
    }
    
    func method(for selector: Selector) -> CalledMethod? {
        let filterItems = methods.filter { (it) -> Bool in
            it.selector == selector
        }
        
        return filterItems.first
    }
}
