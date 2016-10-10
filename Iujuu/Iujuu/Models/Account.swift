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
import Opera

enum AccountType: String {

    case Galicia
    case CreditCard

}

final class Account: Object {

    /// Database ID
    dynamic var accountId: Int = 0
    /// id of Galicia
    dynamic var id: String = ""
    dynamic var type: String = ""
    dynamic var balance: Int = 0
    dynamic var currency: String = ""
    dynamic var cbu: String?

    override class func primaryKey() -> String? {
        return "accountId"
    }

    var accountType: AccountType? {
        return AccountType(rawValue: type)
    }

    convenience init(
        id: String,
        type: String,
        balance: Int,
        currency: String,
        cbu: String?) {

        self.init()
        self.id = id
        self.type = type
        self.balance = balance
        self.currency = currency
        self.cbu = cbu
    }

}

extension Account: Decodable, OperaDecodable {

    static func decode(_ j: Any) throws -> Account {
        return try Account(id: j => "id",
            type: j => "type",
            balance: j => "balance",
            currency: j => "currency",
            cbu: j =>? "cbu"
        )
    }

}
