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
        static let baseUrl = URL(string: "http://dec01.cloudapp.net/apiIUJUU/api/")!
        static let dynamicLinkUrl = "https://cht58.app.goo.gl/"
        static let AuthTokenName = "access_token"
        static let SuccessCode = 200
        static let successRange = 200..<300
        static let Unauthorized = 401
        static let NotFoundCode = 404
        static let ValidationError = 422
        static let ServerError = 500

        struct Galicia {
            static let baseUrl = URL(string: "http://galicia.desarrollo.fluxit.com.ar/api/v1")!
            static let AuthHeaderName = "Authorization"
            static let callbackUrl = "http://iujuu/callback"
            static let argentineCurrency = "ARS"
        }
    }

    struct Keychain {
        static let serviceIdentifier = UIApplication.bundleIdentifier
        static let sessionToken = "session_token"
        static let deviceToken = "device_token"
        static let galiciaToken = "galicia_token"
        static let userIdentifier = "userIdentifier"
    }

    struct Formatters {

        static let debugConsoleDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            formatter.timeZone = TimeZone(identifier: "UTC")!
            return formatter
        }()

        static let intCurrencyFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 0
            formatter.minimumFractionDigits = 0
            formatter.locale = Locale(identifier: "es_AR")
            return formatter
        }()
    }

    struct Debug {
        static let crashlytics = false
        static let jsonResponse = false
    }

    struct Cells {
        static let ListItemMargin: CGFloat = 36
    }

    struct Texts {
        #if STAGING
        static let shareBaseUrl = "https://cht58.app.goo.gl/?link=https://com.iujuu.app.staging/invite?code%3D{0}&ibi=com.iujuu.app.staging"
        #else
        static let shareBaseUrl = "https://cht58.app.goo.gl/?link=https://com.iujuu.app/invite?code%3D{0}&ibi=com.iujuu.app"
        #endif
    }

    struct Oauth {
        static let Host = "galicia-host"
        static let ClientId = "8c4179cb-a2ad-478f-9ddc-d6a58d2d038b"
        static let ClientSecret = "26d74708-4476-41e1-b0a9-448212011ac0"
        static let Scope = "global"
        static let authorizationUrl = "http://galicia.desarrollo.fluxit.com.ar/auth/oauth/authorize"
        static let accessTokenUrl = "http://galicia.desarrollo.fluxit.com.ar/auth/oauth/token"
        static let loginUrl = "http://galicia.desarrollo.fluxit.com.ar/auth/login"
        static let callbackUrl = "http://galicia.desarrollo.fluxit.com.ar/pagos/" //"http://localhost:8084/pagos/"
        static let responseType = "code"
    }

    struct Tasks {
        static let onboardingCompleted = "onboardingCompleted"
    }

}
