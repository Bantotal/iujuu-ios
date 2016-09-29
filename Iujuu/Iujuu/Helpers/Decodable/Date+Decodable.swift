//
//  NSDate+Decodable.swift
//  Iujuu
//
//  Created by Xmartlabs SRL ( https://xmartlabs.com )
//  Copyright © 2016 Xmartlabs SRL. All rights reserved.
//

import Foundation
import Decodable
import SwiftDate

extension Date {

    public static func decode(_ json: Any) throws -> Date {
        let string = try String.decode(json)
        guard let date = string.toDate(format: DateFormat.iso8601Format(.extended)) else {
            throw DecodingError.typeMismatch(expected: Date.self, actual: String.self, DecodingError.Metadata(object: json))
        }
        return self.init(timeIntervalSince1970: date.timeIntervalSince1970)
    }

}
