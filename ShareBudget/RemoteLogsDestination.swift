//
//  RemoteLogsDestination.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 10.05.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import le
import XCGLogger

class RemoteLogsDestination: AppleSystemLogDestination {
    override func write(message: String) {
        LELog.sharedInstance().log(NSString(string: message))
    }
}
