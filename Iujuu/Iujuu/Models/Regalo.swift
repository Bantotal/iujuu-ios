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
import Opera

final class Regalo: Object, OperaDecodable, IUObject {

    dynamic var id: Int = Int.min
    dynamic var saldo: Double = 0
    dynamic var fechaDeCierre = Date()
    dynamic var motivo = ""
    dynamic var descripcion = ""
    dynamic var regaloSugerido: String?
    dynamic var amount = 0
    dynamic var perPerson = 0
    dynamic var isAdministrator = false
    dynamic var active = true
    dynamic var paid = true
    dynamic var codigo: String?


    convenience init(id: Int, saldo: Double, fechaDeCierre: Date, motivo: String, descripcion: String,
                     regaloSugerido: String?, amount: Int, perPerson: Int, active: Bool?, isAdministrator: Bool?, paid: Bool?, codigo: String?) {
        self.init()
        self.id = id
        self.saldo = saldo
        self.fechaDeCierre = fechaDeCierre
        self.motivo = motivo
        self.descripcion = descripcion
        self.regaloSugerido = regaloSugerido
        self.amount = amount
        self.perPerson = perPerson
        active.map { self.active = $0 }
        isAdministrator.map { self.isAdministrator = $0 }
        paid.map { self.paid = $0 }
        self.codigo = codigo

    }

    override class func primaryKey() -> String? {
        return "id"
    }

    func getMotivo() -> Motivo? {
        return Motivo(rawValue: motivo)
    }

}

extension Regalo: Decodable {

    static func decode(_ j: Any) throws -> Regalo {
        return try Regalo(id: j => "id",
                          saldo: j => "saldo",
                          fechaDeCierre: j => "fechaDeCierre",
                          motivo: j => "motivo",
                          descripcion: j => "descripcion",
                          regaloSugerido: j =>? "regaloSugerido",
                          amount: j => "montoObjetivo",
                          perPerson: j => "montoPorPersona",
                          active: j =>? "activo",
                          isAdministrator: j =>? "esAdministrador",
                          paid: j =>? "pago",
                          codigo: j =>? "codigo")
    }

}
