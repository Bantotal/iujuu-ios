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

final class User: Object {

    dynamic var id: Int = Int.min
    dynamic var nombre: String = ""
    dynamic var apellido: String = ""
    dynamic var email: String = ""
    dynamic var username: String?
    dynamic var documento: String?
    dynamic var fechaDeNacimiento: Date?
    dynamic var avatar: String?

    var avatarUrl: URL? {
        return URL(string: avatar ?? "")
    }

    override class func primaryKey() -> String? {
        return "id"
    }

    override static func ignoredProperties() -> [String] {
        return ["avatarUrl"]
    }

    convenience init(
        id: Int,
        nombre: String,
        apellido: String,
        email: String,
        username: String? = nil,
        documento: String? = nil,
        fechaDeNacimiento: Date? = nil,
        avatar: String? = nil) {

        self.init()
        self.id = id
        self.nombre = nombre
        self.apellido = apellido
        self.email = email
        self.username = username
        self.documento = documento
        self.fechaDeNacimiento = fechaDeNacimiento
        self.avatar = avatar
    }

}

extension User: Decodable {

    static func decode(_ j: Any) throws -> User {
        return try User(
            id: j => "userId",
            nombre: j => "nombre",
            apellido: j => "apellido",
            email: j => "email",
            username: j =>? "username",
            documento: j =>? "documento",
            fechaDeNacimiento: j => "fechaDeNacimiento",
            avatar: j =>? "avatar"
        )
    }

}
