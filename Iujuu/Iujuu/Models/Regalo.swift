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

final class RegaloSugerido: Object, OperaDecodable {

    dynamic var regaloDescription = ""
    dynamic var votos = 0

    convenience init(regaloDescription: String, votos: Int) {
        self.init()
        self.regaloDescription = regaloDescription
        self.votos = votos
    }

}

extension RegaloSugerido: Decodable {

    static func decode(_ j: Any) throws -> RegaloSugerido {
        return try RegaloSugerido(
                          regaloDescription: j => "descripcion",
                          votos: j => "votos"
                        )
    }

}

final class Regalo: Object, OperaDecodable, IUObject {

    dynamic var id: Int = Int.min
    dynamic var saldo: Double = 0
    dynamic var fechaDeCierre = Date()
    dynamic var motivo = ""
    dynamic var descripcion = ""
    var regalosSugeridos = List<RegaloSugerido>()
    var participantes = List<RLMString>()
    dynamic var amount = 0
    dynamic var perPerson = 0
    dynamic var cuentaId = ""
    dynamic var usuarioAdministradorId: Int = 0
    dynamic var isAdministrator = false
    dynamic var active = true
    dynamic var paid = true
    dynamic var codigo: String?


    convenience init(id: Int, saldo: Double, fechaDeCierre: Date, motivo: String, descripcion: String,
                     regalosSugeridos: [RegaloSugerido], participantes: [String], amount: Int, perPerson: Int, cuentaId: String, active: Bool?,
                     usuarioAdministradorId: String, isAdministrator: Bool, paid: Bool?, codigo: String?) {
        self.init()
        self.id = id
        self.saldo = saldo
        self.fechaDeCierre = fechaDeCierre
        self.motivo = motivo
        self.descripcion = descripcion
        self.regalosSugeridos.append(objectsIn: regalosSugeridos)
        self.participantes.append(objectsIn: participantes.map({ RLMString(string: $0)}) )
        self.amount = amount
        self.perPerson = perPerson
        self.cuentaId = cuentaId
        self.usuarioAdministradorId = Int(usuarioAdministradorId) ?? 0
        self.isAdministrator = isAdministrator
        active.map { self.active = $0 }
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
                          regalosSugeridos: j => "regalosSugeridos",
                          participantes: j => "participantes",
                          amount: j => "montoObjetivo",
                          perPerson: j => "montoPorPersona",
                          cuentaId: j => "cuentaId",
                          active: j =>? "activo",
                          usuarioAdministradorId: j => "usuarioAdministradorId",
                          isAdministrator: j => "esAdministrador",
                          paid: j =>? "pago",
                          codigo: j =>? "codigo")
    }

}
