//
//  Dependency.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 03.06.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import JustLog
import url_builder
import XCGLogger

enum Environment {
    case testing
    case production
    case developmentLocal
    case developmentRemote
}

class Dependency {
    static let instance = Dependency()

    private init() {}

    static let loggerRemoteIdentifier = "advancedLogger.remoteDestination"

    static var logger: XCGLogger!
    static var coreDataName: String!
    static var restAPIVersion: String!
    static var userCredentials: UserCredentialsProtocol!
    static var backendURLComponents: NSURLComponents!

    static var backendConnection: URLComponents {
        Dependency.instance.restApiComponents()
    }

    class func environment() -> Environment {
        if let testPath = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] {
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

    class func configure() {
        configureUserCredentials()
        configureLogger()
        configureBackendConnection()
        configureDataBaseName()

        logger.info(environment)
    }

    private static let cacheDirectory: URL = {
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()

    private class func configureLogger() {
        Logger.shared.logstashHost = "listener.logz.io"
        Logger.shared.logstashPort = 5052
        Logger.shared.logzioToken = "KwzGuzHVRmyojtidIOicPEZrQbZEzGCQ"
        Logger.shared.enableConsoleLogging = false
        Logger.shared.setup()

        // Create a logger object with no destinations
        logger = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)

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
        logger.add(destination: systemDestination)

        // Create a file log destination
        let logPath: URL = cacheDirectory.appendingPathComponent("XCGLogger_Log.txt")
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
        logger.add(destination: fileDestination)

        if environment() == .production || environment() == .developmentRemote {
            // Remote destination
            let remoteLogsDestination = RemoteLogsDestination(identifier: loggerRemoteIdentifier)
            remoteLogsDestination.outputLevel = .debug
            remoteLogsDestination.showLogIdentifier = false
            remoteLogsDestination.showFunctionName = true
            remoteLogsDestination.showThreadName = false
            remoteLogsDestination.showLevel = true
            remoteLogsDestination.showFileName = true
            remoteLogsDestination.showLineNumber = true
            remoteLogsDestination.showDate = true

            logger.add(destination: remoteLogsDestination)
        }

        // Add basic app info, version info etc, to the start of the logs
        logger.logAppDetails()
    }

    private class func configureBackendConnection() {
        let components = NSURLComponents()
        Dependency.restAPIVersion = "v1"

        switch environment() {
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

        backendURLComponents = components
    }

    func restApiUrlBuilder(environment: Environment = Dependency.environment()) -> URL.Builder {
        let builder: URL.Builder

        switch environment {
        case .developmentLocal:
            builder = URL.Builder.http.host("127.0.0.1").appendPath(Dependency.restAPIVersion).port(5000)

        case .developmentRemote:
            builder = URL.Builder
                .https
                .host("sharebudget-development.herokuapp.com")
                .appendPath(Dependency.restAPIVersion)

        case .production:
            builder = URL.Builder
                .https
                .host("sharebudget-development.herokuapp.com")
                .appendPath(Dependency.restAPIVersion)

        case .testing:
            builder = URL.Builder.scheme("")
        }

        return builder
    }

    func restApiComponents() -> URLComponents {
        var components = URLComponents()

        switch Dependency.environment() {
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

        return components
    }

    private class func configureUserCredentials() {
        userCredentials = UserCredentials.instance
    }

    private class func configureDataBaseName() {
        if environment() == .testing {
            coreDataName = "ShareBudgetTest"
            return
        }

        coreDataName = "ShareBudget"
    }
}
