//
//  NSDate.swift
//  Iujuu
//
//  Created by Xmartlabs SRL ( https://xmartlabs.com )
//  Copyright (c) 2016 Xmartlabs SRL. All rights reserved.
//

import Foundation
import SwiftDate

extension Date {

    func dblog() -> String {
        return Constants.Formatters.debugConsoleDateFormatter.string(from: self)
    }

    func dateString() -> String? {
        return self.toString(format: DateFormat.custom("dd/MM/yyyy"))
    }
}
