//
//  Constants.swift
//  Iujuu
//
//  Created by Xmartlabs SRL ( https://xmartlabs.com )
//  Copyright (c) 2016 Xmartlabs SRL. All rights reserved.
//

import Foundation
import XLSwiftKit

struct Constants {

	struct Network {
        static let baseUrl = URL(string: "http://localhost:3000/api")!
        static let AuthTokenName = "access_token"
        static let SuccessCode = 200
        static let successRange = 200..<300
        static let Unauthorized = 401
        static let NotFoundCode = 404
        static let ServerError = 500
    }

    struct Keychain {
        static let serviceIdentifier = UIApplication.bundleIdentifier
        static let sessionToken = "session_token"
        static let deviceToken = "device_token"
    }

    struct Formatters {

        static let debugConsoleDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            formatter.timeZone = TimeZone(identifier: "UTC")!
            return formatter
        }()

    }

    struct Debug {
        static let crashlytics = false
        static let jsonResponse = false
    }
}
