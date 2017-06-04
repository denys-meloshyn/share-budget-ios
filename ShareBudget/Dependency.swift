//
//  Dependency.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 03.06.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import XCGLogger

enum Environment {
    case production
    case developmentLocal
    case developmentRemote
}

class Dependency {
    static var logger: XCGLogger!
    @NSCopying static var backendConnection: NSURLComponents!
    
    static let environment: Environment = {
        #if DEVELOPMENT_LOCAL
            return Environment.developmentLocal
        #elseif DEVELOPMENT_REMOTE
            return Environment.developmentRemote
        #else
            return Environment.production
        #endif
    }()
}
