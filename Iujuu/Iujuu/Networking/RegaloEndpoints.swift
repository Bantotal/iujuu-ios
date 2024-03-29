//
//  Regalo.swift
//  Iujuu
//
//  Created by Mathias Claassen on 9/27/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import Alamofire
import Opera
import SwiftDate

extension Router.Regalo {

    struct Create: PostRouteType {

        let userId: Int
        let motivo: String
        let descripcion: String
        let closeDate: Date
        let targetAmount: Int
        let perPersonAmount: Int
        let regalosSugeridos: [String]
        let accountId: String

        var path: String {
            return "\(Router.baseUsuariosString)/\(userId)/regalos"
        }

        var parameters: [String : Any]? {
            return ["regalo": cleanedDict([
                "descripcion": descripcion,
                "motivo": motivo,
                "fechaDeCierre": closeDate.string(format: .iso8601(options: .withInternetDateTimeExtended)),
                "montoObjetivo": targetAmount,
                "montoPorPersona": perPersonAmount,
                "cuentaId": accountId,
                "regalosSugeridos": regalosSugeridos.map({ sugerencia in
                    return ["descripcion": sugerencia, "votos": 1]
                })
                ])]
        }

    }

    struct List: GetRouteType {

        let userId: Int

        var path: String {
            return "\(Router.baseUsuariosString)/\(userId)/regalos"
        }
    }

    struct Get: GetRouteType {

        let code: String
        var path: String { return "regalos/codigo/\(code)" }

    }

    struct VotarRegalo: PostRouteType {

        let userId: Int
        let regaloId: Int
        let voto: String

        var path: String {
            return "\(Router.baseUsuariosString)/\(userId)/regalos/\(regaloId)/votar"
        }

        var parameters: [String : Any]? {
            return ["voto": voto]
        }
    }
    
    struct DeleteRegaloSuggestion: PostRouteType {

        let userId: Int
        let regaloId: Int
        let voto: String

        var path: String {
            return "\(Router.baseUsuariosString)/\(userId)/regalos/\(regaloId)/eliminarSugerencia"
        }

        var parameters: [String : Any]? {
            return ["voto": voto]
        }

    }

    struct PagarRegalo: PostRouteType {

        let userId: Int
        let regaloId: Int
        let importe: String
        let comentario: String?
        let imagen: String?

        var path: String {
            return "\(Router.baseUsuariosString)/\(userId)/regalos/\(regaloId)/pagar"
        }

        var parameters: [String : Any]? {
            return ["pago": cleanedDict(["importe": importe, "foto": imagen, "comentario": comentario])]
        }
    }

    struct Edit: PostRouteType {

        let userId: Int
        let regaloId: Int
        let descripcion: String
        let closeDate: Date
        let targetAmount: Int
        let perPersonAmount: Int
        let regalosSugeridos: [RegaloSugerido]

        var path: String {
            return "\(Router.baseUsuariosString)/\(userId)/regalos/\(regaloId)/actualizar"
        }

        var parameters: [String : Any]? {
            return cleanedDict([
                "descripcion": descripcion,
                "fechaDeCierre": closeDate.string(format: .iso8601(options: .withInternetDateTimeExtended)),
                "montoObjetivo": targetAmount,
                "montoPorPersona": perPersonAmount,
                "regalosSugeridos": regalosSugeridos.map({ regalo in
                    return ["descripcion": regalo.regaloDescription, "votos": regalo.votos]
                })
            ])
        }

    }

    struct Join: PostRouteType {

        let userId: Int
        let regaloCode: String
        var path: String { return "usuarios/\(userId)/regalos/\(regaloCode)/unirme" }
        var parameters: [String : Any]? { return ["regaloCodigo": regaloCode] }

    }

    struct CloseRegalo: PostRouteType {

        let userId: Int
        let regaloId: Int
        let email: String

        var path: String {
            return "\(Router.baseUsuariosString)/\(userId)/regalos/\(regaloId)/cerrar"
        }

        var parameters: [String : Any]? {
            return ["email": email]
        }

    }

}
