//
//  Realm+Iujuu.swift
//  Iujuu
//
//  Created by Mathias Claassen on 10/3/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import RealmSwift

protocol IUObject {
    var id: Int { get }
}

func == (lhs: IUObject, rhs: IUObject) -> Bool {
    return lhs.id == rhs.id
}
