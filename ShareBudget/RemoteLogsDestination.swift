//
//  RemoteLogsDestination.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 10.05.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import JustLog
import le
import XCGLogger

class RemoteLogsDestination: AppleSystemLogDestination {
    private var logDetails = LogDetails(level: XCGLogger.Level.info, date: Date(), message: "", functionName: "", fileName: "", lineNumber: 0)

    override func output(logDetails: LogDetails, message: String) {
        self.logDetails = logDetails

        super.output(logDetails: logDetails, message: message)
    }

    override func write(message _: String) {
        // LELog.sharedInstance().log(NSString(string: message))
//        BFLog("\(Dependency.userCredentials.email) -> \(message)")

        var userInfo = logDetails.userInfo
        userInfo["log_type"] = logDetails.level.description
        userInfo["message"] = logDetails.message
        userInfo["function"] = logDetails.functionName
        userInfo["file"] = logDetails.fileName
        Logger.shared.info_objc(logDetails.message, userInfo: userInfo)
    }
}
