//
//  Dependency.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 03.06.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import XCGLogger
import BugfenderSDK

enum Environment {
    case testing
    case production
    case developmentLocal
    case developmentRemote
}

class Dependency {
    static let sharedInstance = Dependency()
    
    private init() {
        self.configure()
    }
    
    let loggerRemoteIdentifier = "advancedLogger.remoteDestination"
    
    var logger: XCGLogger!
    var userCredentials: UserCredentials.Type!
    var backendURLComponents: NSURLComponents!
    var backendConnection: NSURLComponents {
        get {
            return backendURLComponents.copy() as! NSURLComponents
        }
    }
    
    func environment() -> Environment {
        if let testPath = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"]  {
            let url = URL(fileURLWithPath: testPath)
            
            if url.pathExtension == "xctestconfiguration" {
                return .testing
            }
        }
        
        #if DEVELOPMENT_LOCAL
            return Environment.developmentLocal
        #elseif DEVELOPMENT_REMOTE
            return Environment.developmentRemote
        #else
            return Environment.production
        #endif
    }
    
    func configure() {
        self.configureUserCredentials()
        self.configureLogger()
        self.configureBackendConnection()
        
        self.logger.info(self.environment)
    }
    
    let cacheDirectory: URL = {
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()
    
    private func configureLogger() {
        //LELog.sharedInstance().token = "3c7c276a-44b2-4804-8f48-03c7cf3b43fb"
        
        Bugfender.activateLogger("x041vOzFfgsTGl7PGfHlzlof9lPXxBjb")
        Bugfender.setPrintToConsole(false)
        Bugfender.enableUIEventLogging()  // optional, log user interactions automatically
        
        // Create a logger object with no destinations
        self.logger = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)
        
        // Create a destination for the system console log (via NSLog)
        let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.systemDestination")
        
        // Optionally set some configuration options
        systemDestination.outputLevel = .debug
        systemDestination.showLogIdentifier = false
        systemDestination.showFunctionName = true
        systemDestination.showThreadName = false
        systemDestination.showLevel = true
        systemDestination.showFileName = true
        systemDestination.showLineNumber = true
        systemDestination.showDate = true
        
        // Add the destination to the logger
        self.logger.add(destination: systemDestination)
        
        // Create a file log destination
        let logPath: URL = self.cacheDirectory.appendingPathComponent("XCGLogger_Log.txt")
        let fileDestination = FileDestination(writeToFile: logPath, identifier: "advancedLogger.fileDestination")
        
        // Optionally set some configuration options
        fileDestination.outputLevel = .debug
        fileDestination.showLogIdentifier = false
        fileDestination.showFunctionName = true
        fileDestination.showThreadName = true
        fileDestination.showLevel = true
        fileDestination.showFileName = true
        fileDestination.showLineNumber = true
        fileDestination.showDate = true
        
        // Process this destination in the background
        fileDestination.logQueue = XCGLogger.logQueue
        
        // Add the destination to the logger
        self.logger.add(destination: fileDestination)
        
        if (self.environment() == .production) {
            // Remote destination
            let remoteLogsDestination = RemoteLogsDestination(identifier: self.loggerRemoteIdentifier)
            remoteLogsDestination.outputLevel = .debug
            remoteLogsDestination.showLogIdentifier = false
            remoteLogsDestination.showFunctionName = true
            remoteLogsDestination.showThreadName = false
            remoteLogsDestination.showLevel = true
            remoteLogsDestination.showFileName = true
            remoteLogsDestination.showLineNumber = true
            remoteLogsDestination.showDate = true
            
            self.logger.add(destination: remoteLogsDestination)
        }
        
        // Add basic app info, version info etc, to the start of the logs
        self.logger.logAppDetails()
    }
    
    private func configureBackendConnection() {
        let components = NSURLComponents()
        
        switch self.environment() {
        case .developmentLocal:
            components.scheme = "http"
            components.host = "127.0.0.1"
            components.port = 5000
            
        case .developmentRemote:
            components.scheme = "https"
            components.host = "sharebudget-development.herokuapp.com"
            
        case .production:
            components.scheme = "https"
            components.host = "sharebudget-development.herokuapp.com"
            
        default:
            break
        }
        
        self.backendURLComponents = components
    }
    
    private func configureUserCredentials() {
        self.userCredentials = UserCredentials.self
    }
}
