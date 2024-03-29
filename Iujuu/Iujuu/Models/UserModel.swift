//
//  ExampleObject.swift
//  Iujuu
//
//  Created by Xmartlabs SRL ( https://xmartlabs.com )
//  Copyright © 2016 Xmartlabs SRL. All rights reserved.
//

import Foundation
import Decodable
import RealmSwift
//import Opera


final class User: Object {

    dynamic var id: Int = Int.min
    dynamic var email: String?
    dynamic var company: String?
    dynamic var username: String = ""
    dynamic var avatarUrlString: String?

    let followers = List<User>()

    var avatarUrl: URL? {
        return URL(string: self.avatarUrlString ?? "")
    }

    /**
     Return property names that should be ignored by Realm. Realm will not persist these properties.
     */
    override static func ignoredProperties() -> [String] {
        return []
    }

    convenience init(id: Int, email: String?, avatarUrlString: String?, company: String?, username: String) {
        self.init()
        self.id = id
        self.email = email
        self.avatarUrlString = avatarUrlString
        self.company = company
        self.username = username
    }
}

//extension User: Decodable, OperaDecodable {
//
//    static func decode(_ j: AnyObject) throws -> User {
//        return try User(id: j => "id",
//                 email: j =>? "email",
//       avatarUrlString: j =>? "avatar_url",
//               company: j =>? "name",
//              username: j => "login")
//    }
//
//}
