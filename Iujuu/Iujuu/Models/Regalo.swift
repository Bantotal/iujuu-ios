//
//  Regalo.swift
//  Iujuu
//
//  Created by Diego Ernst on 9/20/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation

import Foundation
import Decodable
import RealmSwift

final class Regalo: Object {

    dynamic var id: Int = Int.min
    dynamic var saldo: Double = 0
    dynamic var fechaDeInicio = Date()
    dynamic var fechaDeFin = Date()
    dynamic var titulo = ""
    dynamic var regaloSugerido: String?
    dynamic var montoSugeridoDelRegalo: Double = 0
    dynamic var montoSugeridoPorPersona: Double = 0
    dynamic var imagen: String?
    dynamic var estado: String?

    var imageUrl: URL? {
        return URL(string: imagen ?? "")
    }

    override class func primaryKey() -> String? {
        return "id"
    }

    override static func ignoredProperties() -> [String] {
        return ["imageUrl"]
    }

}

extension Regalo: Decodable {

    static func decode(_ j: Any) throws -> Regalo {
        let data: [AnyHashable: Any] = [
            "id": try j => "regaloId" as Int,
            "saldo": try j => "saldo" as Double,
            "fechaDeInicio": try j => "fechaDeInicio" as Date,
            "fechaDeFin": try j => "fechaDeFin" as Date,
            "titulo": try j => "titulo" as String,
            "regaloSugerido": try? j => "regaloSugerido" as String,
            "montoSugeridoDelRegalo": try? j => "montoSugeridoDelRegalo" as Double,
            "imagen": try? j => "imagen" as String,
            "estado": try? j => "saldo" as String
        ]
        return Regalo(value: data)
    }

}
