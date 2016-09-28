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
        let name: String
        let closeDate: Date
        let targetAmount: Int
        let perPersonAmount: Int
        let account: Account

        var path: String {
            return "\(Router.baseUsuariosString)/\(userId)/regalos"
        }

        var parameters: [String : Any]? {
            return cleanedDict([
                "descripcion": name,
                "motivo": motivo,
                "fechaDeCierre": closeDate.toString(format: DateFormat.iso8601Format(.date)),
                "montoObjetivo": targetAmount,
                "montoPorPersona": perPersonAmount
                // TODO: Add account data
                ])
        }

    }
}