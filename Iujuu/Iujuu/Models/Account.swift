//
//  Account.swift
//  Iujuu
//
//  Created by Mathias Claassen on 9/26/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import Decodable
import RealmSwift

enum AccountType: String {

    case Galicia
    case CreditCard

}

final class Account: Object {

    dynamic var id: Int = Int.min
    dynamic var type: String = ""
    dynamic var objectDescription: String = ""
    dynamic var accountNumber: String = ""
    dynamic var sucursal: String = ""

    override class func primaryKey() -> String? {
        return "id"
    }

    var accountType: AccountType? {
        return AccountType(rawValue: type)
    }

    convenience init(
        id: Int,
        type: String,
        description: String,
        accountNumber: String,
        sucursal: String) {

        self.init()
        self.id = id
        self.type = type
        self.objectDescription = description
        self.accountNumber = accountNumber
        self.sucursal = sucursal
    }

}

extension Account: Decodable {

    static func decode(_ j: Any) throws -> Account {
        return try Account(id: j => "accountId",
            type: j => "tipo",
            description: j => "description",
            accountNumber: j => "number",
            sucursal: j => "sucursal"
        )
    }
    
}
