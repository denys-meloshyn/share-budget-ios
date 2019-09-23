//
// Created by Denys Meloshyn on 22/09/2019.
// Copyright (c) 2019 Denys Meloshyn. All rights reserved.
//

import Foundation

extension URL {
    struct Builder {
        private let scheme: String?
        private let host: String?
        private let port: Int?
        private let paths: [String]
        private let queryItems: [URLQueryItem]?

        init(scheme: String? = nil,
             host: String? = nil,
             port: Int? = nil,
             paths: [String] = [],
             queryItems: [URLQueryItem]? = nil) {
            self.scheme = scheme
            self.host = host
            self.port = port
            self.paths = paths
            self.queryItems = queryItems
        }

        func build() -> URL? {
            var urlComponents = URLComponents()
            urlComponents.scheme = scheme
            urlComponents.host = host
            urlComponents.port = port
            urlComponents.path = paths.joined(separator: "/")
            urlComponents.queryItems = queryItems

            return urlComponents.url
        }

        func scheme(_ scheme: String) -> Builder {
            Builder(scheme: scheme, host: host, port: port, paths: paths, queryItems: queryItems)
        }

        func host(_ host: String) -> Builder {
            Builder(scheme: scheme, host: host, port: port, paths: paths, queryItems: queryItems)
        }

        func port(_ port: Int) -> Builder {
            Builder(scheme: scheme, host: host, port: port, paths: paths, queryItems: queryItems)
        }

        func appendPath(_ newSegment: String) -> Builder {
            Builder(scheme: scheme, host: host, port: port, paths: paths + [newSegment], queryItems: queryItems)
        }

        func appendQueryParameter(key: String, value: String) -> Builder {
            Builder(scheme: scheme,
                    host: host,
                    port: port,
                    paths: paths,
                    queryItems: (queryItems ?? []) + [URLQueryItem(name: key, value: value)])
        }
    }
}
