//
//  NetworkUser.swift
//  Iujuu
//
//  Created by Xmartlabs SRL ( https://xmartlabs.com )
//  Copyright © 2016 Xmartlabs SRL. All rights reserved.
//

import Foundation
import Alamofire
import Opera
import SwiftDate

extension Router.Session {

    struct Register: PostRouteType {

        let nombre: String
        let apellido: String
        let documento: String?
        let fechaDeNacimiento: Date?
        let username: String?
        let email: String
        let password: String

        var path: String {
            return Router.baseUsuariosString
        }

        var parameters: [String : Any]? {
            return cleanedDict([
                "nombre": nombre,
                "apellido": apellido,
                "email": email,
                "password": password,
                "documento": documento,
                "fechaDeNacimiento": fechaDeNacimiento?.toString(format: DateFormat.iso8601Format(.date)),
                "username": username
            ])
        }

    }

    struct Login: PostRouteType {
        
        let username: String?
        let email: String?
        let password: String

        var path: String {
            return "\(Router.baseUsuariosString)/login"
        }

        var parameters: [String : Any]? {
            return cleanedDict([
                "email": email,
                "password": password,
                "username": username
                ])
        }
        
    }
}
