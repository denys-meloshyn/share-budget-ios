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
    
    func add(_ method: String = #function) {
        let filterItems = methods.filter { (it) -> Bool in
            it.name == method
        }
        
        if filterItems.count > 0 {
            let current = filterItems[0]
            current.counter += 1
        } else {
            let new = CalledMethod(method)
            methods.append(new)
        }
    }
    
    func add(_ method: Selector) {
        self.add(method.description)
    }
    
    func method(for selector: String) -> CalledMethod? {
        let filterItems = methods.filter { (it) -> Bool in
            it.name == selector
        }
        
        return filterItems.first
    }
    
    func method(for selector: Selector) -> CalledMethod? {
        return method(for: selector.description)
    }
}
