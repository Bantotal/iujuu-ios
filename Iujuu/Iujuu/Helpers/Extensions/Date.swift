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
        return self.string(format: DateFormat.custom("dd/MM/yyyy"))
    }

    func daysFrom(date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day!
    }

    func hoursFrom(date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour!
    }

}
