//
//  IujuuError.swift
//  Iujuu
//
//  Created by Diego Ernst on 10/6/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation

enum IujuuErrorCodes: Int {

    case invalidDeepLink
    case loginParseResponseError
    case regaloNotFoundForCode
    case userNotLogged
    case unexpectedNil
    case userIdNotFound

}

extension NSError {

    static var iujuuErrorDomain: String {
        return "com.iujuu.app.errors"
    }

    static func ijError(code: IujuuErrorCodes, userInfo: [String: AnyObject]? = nil) -> NSError {
        return NSError(domain: NSError.iujuuErrorDomain, code: code.rawValue, userInfo: userInfo)
    }

}
