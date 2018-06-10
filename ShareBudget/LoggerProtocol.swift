//
//  LoggerProtocol.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 09.06.2018.
//  Copyright © 2018 Denys Meloshyn. All rights reserved.
//

import XCGLogger

protocol LoggerProtocol {
    func logError(_ message: String)
}

extension XCGLogger: LoggerProtocol {
    func logError(_ message: String) {
        error("Can't perform fetch request")
    }
}
