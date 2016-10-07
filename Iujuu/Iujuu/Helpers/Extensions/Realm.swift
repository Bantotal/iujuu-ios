//
//  Realm.swift
//  Iujuu
//
//  Created by user on 10/3/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import RealmSwift

class RLMString: Object {
    dynamic var string: String = ""

    convenience init(string: String) {
        self.init()
        self.string = string
    }
}
