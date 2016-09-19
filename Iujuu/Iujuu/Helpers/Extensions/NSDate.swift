//
//  NSDate.swift
//  Iujuu
//
//  Created by Xmartlabs SRL ( https://xmartlabs.com )
//  Copyright (c) 2016 Xmartlabs SRL. All rights reserved.
//

import Foundation

extension Date {

    func dblog() -> String {
        return Constants.Formatters.debugConsoleDateFormatter.string(from: self)
    }

}
