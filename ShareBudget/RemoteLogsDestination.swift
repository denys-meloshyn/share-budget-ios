//
//  RemoteLogsDestination.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 10.05.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import le
import JustLog
import XCGLogger
import BugfenderSDK

class RemoteLogsDestination: AppleSystemLogDestination {
    private var logDetails = LogDetails(level: XCGLogger.Level.info, date: Date(), message: "", functionName: "", fileName: "", lineNumber: 0)
    
    override func output(logDetails: LogDetails, message: String) {
        self.logDetails = logDetails
        
        super.output(logDetails: logDetails, message: message)
    }
    
    override func write(message: String) {
        //LELog.sharedInstance().log(NSString(string: message))
        BFLog("\(Dependency.userCredentials.email) -> \(message)")
        
        var userInfo = logDetails.userInfo
        userInfo["user"] = Dependency.userCredentials.email
        userInfo["log_type"] = self.logDetails.level.description
        userInfo["message"] = self.logDetails.message
        userInfo["function"] = self.logDetails.functionName
        userInfo["file"] = self.logDetails.fileName
        Logger.shared.info_objc(self.logDetails.message, userInfo: userInfo)
    }
}
